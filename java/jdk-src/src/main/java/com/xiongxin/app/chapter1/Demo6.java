package com.xiongxin.app.chapter1;

import java.util.Arrays;

public class Demo6 {

  public static Object baozidian = null;

  public static void main(String[] args) throws InterruptedException {
    Demo6 demo6 = new Demo6();
    demo6.waitNotifyTest();
  }

  public void waitNotifyTest() throws InterruptedException {

    new Thread(() -> {
      if (baozidian == null) {
        synchronized (this) {
          try {
            System.out.println("1.进入等待");
            this.wait();
          } catch (InterruptedException e) {
            e.printStackTrace();
          }
        }
        System.out.println("2.买到包子，回家");
      }
    }).start();

    new Thread(() -> {
      baozidian = new Object();
      synchronized (this) {
        this.notifyAll();
        System.out.println("3.通知消费");
      }
    }).start();
  }
}
