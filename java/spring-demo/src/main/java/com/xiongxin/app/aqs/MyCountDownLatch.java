package com.xiongxin.app.aqs;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.AbstractQueuedSynchronizer;

public class MyCountDownLatch {

    /**
     * 同步控制器
     * 使用ＡＱＳ代表提供的总数
     */
    private static final class Sync extends AbstractQueuedSynchronizer {

        private static final long serialVersionUID = 6669976996930163565L;

        Sync(int count) {
            setState(count);
        }

        int getCount() {
            return getState();
        }

        /**
         * -1 保持当前线程登台
         * １　放行
         * 0 zero if acquisition in shared  mode succeeded but no subsequent shared-mode acquire can succeed;
         * @param acquires
         * @return
         */
        protected int tryAcquireShared(int acquires) {
            return (getState() == 0) ? 1 : -1; //　如果还有线程没有执行完毕，讲当前线程暂停
        }

        protected boolean tryReleaseShared(int releases) {
            // Decrement count; signal when transition to zero
            for (;;) {
                int c = getState();
                if (c == 0)
                    return false;

                int nextc = c - 1;
                if (compareAndSetState(c, nextc)) {
                    return nextc == 0;
                }
            }
        }
    }
    private final Sync sync;
    public MyCountDownLatch(int count) {
        if (count < 0) throw new IllegalArgumentException("count < 0");

        sync = new Sync(count);
    }

    public void await() throws InterruptedException {
        sync.acquireSharedInterruptibly(1);
    }

    public boolean await(long timeout, TimeUnit unit) throws InterruptedException {
        return sync.tryAcquireSharedNanos(1, unit.toNanos(timeout));
    }

    public void countDown() {
        sync.releaseShared(1);
    }

    public long getCount() {
        return sync.getCount();
    }

    public String toString() {
        return super.toString() + "[Count = " + sync.getCount() + "]";
    }

}
