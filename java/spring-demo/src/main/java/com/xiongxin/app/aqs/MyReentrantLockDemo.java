package com.xiongxin.app.aqs;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class MyReentrantLockDemo {

    private int i = 0;

    private void add() {
        i++;
    }

    public static void main(String[] args) throws InterruptedException {


        MyReentrantLock lock = new MyReentrantLock();
        MyReentrantLockDemo demo = new MyReentrantLockDemo();

        List<String> s1 = new ArrayList<>();
        List<String> s2 = null;

        System.out.println(s1 == s2);

        for (int i = 0; i < 10; i++) {
            new Thread(() -> {

                lock.lock();
                try {
                    for (int j = 0; j < 1000; j++) {
                        demo.add();
                    }
                } finally {
                    lock.unlock();
                }
            }).start();
        }


        TimeUnit.SECONDS.sleep(10);

        System.out.println(demo.i);
    }
}
