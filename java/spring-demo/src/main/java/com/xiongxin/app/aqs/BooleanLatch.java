package com.xiongxin.app.aqs;

import java.util.concurrent.locks.AbstractQueuedSynchronizer;

/**
 * Here is a latch lass that is like a
 * CountDownLatch except that is only require a single to fire.
 * Because a latch is non-exclusive, it uses the shared acquire
 * and release methods.
 */
public class BooleanLatch {

    private static class Sync extends AbstractQueuedSynchronizer {
        boolean isSignalled() {
            return getState() != 0;
        }

        /**
         * Attempts to acquire in shared mode. This method should query if
         * the state of the object permits it to be acquired in the shared
         * mode, and if so to acquire it.
         *
         * This method is always invoked by the thread performing
         * acquire. If thisthis method reports failure, the acquire method
         * may queue the thread, if it is not already queued, until it is
         * signalled by a release from some other thread.
         *
         * @param ignore the acquire argument. This value is always the one
         *               passed to an acquire wait. The value is otherwise
         *               uniterpreted and can represent anything you like.
         * @return a negative value on failure; zero if acquisition in shared
         *         mode succeeded but no subsequent shared-mode acquire can
         *         succed; and a positive value if acquisition in shared mode
         *         succeeded and subsequent shared-mode acquires might also
         *         succeed, in which case a subsequent waiting thread must
         *         check availability. (Support for three different return
         *         values enables this method to be used in contexts where
         *         acquires only sometimes act exclusively.) Upon
         *         success, this object has been acquired.
         *
         *
         * 负数代表失败，０代表成功，正数代表成功，接下来的也能成功
         */
        protected int tryAcquireShared(int ignore) {
            return isSignalled() ? 1 : -1;
        }

        protected boolean tryReleaseShared(int ignore) {
            setState(1);
            return true;
        }
    }

    private final Sync sync = new Sync();
    public boolean isSignalled() {
        return sync.isSignalled();
    }

    public void signal() {
        sync.releaseShared(1);
    }

    public void await() throws InterruptedException {
        sync.acquireSharedInterruptibly(1);
    }
}
