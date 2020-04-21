package com.xiongxin.app.aqs;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class MyCountDownDemo {

    public static void main(String[] args) throws InterruptedException {


        MyCountDownLatch countDownLatch = new MyCountDownLatch(2);

        for (int i = 0; i < 2; i++) {
            new Thread(() -> {
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                System.out.println( Thread.currentThread() + "执行完毕");
                countDownLatch.countDown();
            }).start();
        }

        System.out.println("Main 等待两个子线程执行完毕");
        countDownLatch.await();
        System.out.println("Main 等待执行完毕");
    }
}
