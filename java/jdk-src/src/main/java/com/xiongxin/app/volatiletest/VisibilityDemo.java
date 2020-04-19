package com.xiongxin.app.volatiletest;

// -server -XX:+UnlockDiagnosticVMOptions -XX:+PrintAssembly -XX:+LogCompilation -XX:LogFile=jit.log
import java.util.Arrays;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

public class VisibilityDemo {
  private volatile boolean flag = true;
  private int a;
  private boolean b;
  private Integer c;
  private double d;

  public static void main(String[] args) throws InterruptedException {
    VisibilityDemo demo1 = new VisibilityDemo();
    Thread t = new Thread(() -> {
      int i = 0;
      try {
        TimeUnit.SECONDS.sleep(2);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      System.out.println(i);
    });

    t.start();
    t.join();


    demo1.flag = false;
    System.out.println("被设置为false");
    System.out.println(demo1.a);
    System.out.println(demo1.b);
    System.out.println(demo1.c);
    System.out.println(demo1.d);

    AtomicLong atomicLong = new AtomicLong();
    atomicLong.set(-1L);
    System.out.println("args = " + atomicLong.get());
  }
}
