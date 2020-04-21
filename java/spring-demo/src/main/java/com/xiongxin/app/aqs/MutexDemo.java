package com.xiongxin.app.aqs;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class MutexDemo {

    private int i = 0;

    private void add() {
        i++;
    }

    public static void main(String[] args) throws InterruptedException {


        MutexDemo demo = new MutexDemo();
        Mutex mutex = new Mutex();

        List<String> s1 = new ArrayList<>();
        List<String> s2 = null;

        System.out.println(s1 == s2);

        for (int i = 0; i < 2; i++) {
            new Thread(() -> {

                mutex.lock();
                try {
                    for (int j = 0; j < 1000; j++) {
                        demo.add();
                    }
                } finally {
                    mutex.unlock();
                }
            }).start();
        }


        TimeUnit.SECONDS.sleep(3);

        System.out.println(demo.i);
    }
}
