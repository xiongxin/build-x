package com.xiongxin.app.aqs;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.AbstractQueuedSynchronizer;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;

/**
 * 1. 和 synchronized 类似的功能，但是扩展了部分能力
 *
 * 2. ReenterantLock 的拥有这是最后一个成功获取锁，但是没有释放锁.
 *    一个线程在调用lock时会返回，当锁没有拥有者时会成功获取锁。该方法
 *    也会立即返回，如果锁已经被占有了. 我们可以用过方法 isHeldByCurrentThread
 *    或者getHoldCount
 * 3. 构造次类接收一个可选的`公平`参数，当为ture时，会有益于等待时间最长的线程。
 *  　否则这个锁不会保证任何的获取顺序.
 */
public class MyReentrantLock implements Lock, Serializable {
    private static final long serialVersionUID = 6422032213993199504L;

    /**
     * 同步器提供了所有的实现机制
     */
    private final Sync sync;


    /**
     * 锁的同步控制器。子类包括公平和非公平版本，使用 AQS state 代表锁的获取数量
     */
    abstract static class Sync extends AbstractQueuedSynchronizer {
        private static final long serialVersionUID = -4954550594109731645L;


        /**
         * 执行lock, 提供一个快速的非公平锁版本
         */
        abstract void lock();

        /**
         * 处理非公平tryLock. tryAcquire的实现在子类中，
         * 两者都需要非公平的tryLock方法
         */
        final boolean nofairTryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState();
            if (c == 0) {
                if (compareAndSetState(0, acquires)) { // 没有的话，就直接获取到当前锁了
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            else if (current == getExclusiveOwnerThread()) { //重入判断
                int nextc = c + acquires;
                if (nextc < 0) // 溢出
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);
                return true;
            }

            return false;
        }

        protected final boolean tryRelease(int releases) {
            int c = getState() - releases;
            if (Thread.currentThread() != getExclusiveOwnerThread()) // 如果当前线程没有拥有锁，而释放会报错
                throw new IllegalMonitorStateException();
            boolean free = false;
            if (c == 0) { // 减到０才是完全释放
                free = true;
                setExclusiveOwnerThread(null);
            }

            setState(c);

            return free;
        }

        protected final boolean isHeldExclusively() {
            // 在有拥有者之前我们必须读取状态
            // 我们不需要处理当前线程释放是拥有者
            return getExclusiveOwnerThread() == Thread.currentThread();
        }


        final ConditionObject newCondition() {
            return new ConditionObject();
        }

        // Methods relayed from outer class

        final Thread getOwner() {
            return getState() == 0 ? null : getExclusiveOwnerThread();
        }

        final int getHoldCount() {
            return isHeldExclusively() ? getState() : 0;
        }

        final boolean isLocked() {
            return getState() != 0;
        }

        /**
         *
         */
        private void readObject(ObjectInputStream s) throws IOException, ClassNotFoundException {
            s.defaultReadObject();
            setState(0); // 重置无锁状态
        }
    }

    /**
     * 非公平锁
     */
    static final class NonfairSync extends Sync {
        private static final long serialVersionUID = 8414350251657951586L;

        @Override
        void lock() {
            if (compareAndSetState(0, 1)) { // 尝试比较一下，不行就入队列
                setExclusiveOwnerThread(Thread.currentThread());
            } else {
                acquire(1); // 当前线程没有成功获取到锁时才加入队列
                                // 会调用我们的tryAcquire判断释放能获取到锁
            }
        }

        protected final boolean tryAcquire(int acquires) {
            return nofairTryAcquire(acquires);
        }
    }

    /**
     * 公平对象锁
     */
    static final class FairSync extends Sync {

        @Override
        void lock() {
            acquire(1); //直接入队
        }

        /**
         * 公平版本的tryAcquire.
         * 不保证公平性：除非递归调用　或者　没有其他的等待着　或者　他是第一个想要获取锁的人
         */
        protected final boolean tryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState();
            if (c == 0) {
                if (!hasQueuedPredecessors() && // 1. 初始化的情况, 头尾相等,都是空的node对象
                                                // 2. 尾部 <- newNode
                                                // 3. 自璇设置 尾部是newNode,尾部的next是newNode
                                                // 4. 头尾不相等时，肯定有已经加入的线程
                                                // 头尾不相等并且头部的下一个为空　　或者　头尾不相等　头部的下一个线程不是当前线程
                                                // 由于该方法不能保证在调用之后有新的线程入队，所以我们必须还要加个判断
                    compareAndSetState(0, 1)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
            } else if (current == getExclusiveOwnerThread()){ // 相同的线程,直接获取锁 由于当前线程获取了锁，下面的操作都是线程安全的
                int nextc = c + acquires;
                if ( nextc < 0 )
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);

                return true;
            }

            // 否则就等待入队列了
            return false;
        }
    }

    public MyReentrantLock() {
        sync = new NonfairSync();
    }

    public MyReentrantLock(boolean fair) {
        sync = fair ? new FairSync() : new NonfairSync();
    }

    @Override
    public void lock() {
        sync.lock();
    }

    /**
     * 获取锁除非当前线程被中断了
     *
     * @throws InterruptedException
     */
    @Override
    public void lockInterruptibly() throws InterruptedException {
        sync.acquireSharedInterruptibly(1);
    }

    @Override
    public boolean tryLock() {
        return sync.nofairTryAcquire(1);
    }

    @Override
    public boolean tryLock(long time, TimeUnit unit) throws InterruptedException {
        return sync.tryAcquireNanos(1, unit.toNanos(time));
    }

    @Override
    public void unlock() {
        sync.release(1);
    }

    @Override
    public Condition newCondition() {
        return sync.newCondition();
    }

    public int getHoldCount() {
        return sync.getHoldCount();
    }
}
