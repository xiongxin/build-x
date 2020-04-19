package com.xiongxin.app.thread;

import com.xiongxin.app.chapter1.Demo6;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class Demo09 {

  void testCommon(ThreadPoolExecutor threadPoolExecutor) throws InterruptedException {
    for (int i = 0; i < 15; i++) {
      int n = i;
      threadPoolExecutor.submit(() -> {
        try {
          System.out.println("开始执行:" + n);
          Thread.sleep(3000L);
          System.err.println("执行结束:" + n);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
      });
      System.out.println("任务提交成功:" + i);
    }

    // 查看现场数量,查看队列等待数量
    Thread.sleep(500L);
    System.out.println("当前线程数量为：" + threadPoolExecutor.getPoolSize());
    System.out.println("当前线程等待的数量为：" + threadPoolExecutor.getQueue().size());
    Thread.sleep(15000L);
    System.out.println("当前线程数量为：" + threadPoolExecutor.getPoolSize());
    System.out.println("当前线程等待的数量为：" + threadPoolExecutor.getQueue().size());

  }


  private void threadPoolExecutorTest1() throws InterruptedException {
    ThreadPoolExecutor threadPoolExecutor
            = new ThreadPoolExecutor(5, 10, 5, TimeUnit.SECONDS,new LinkedBlockingQueue<>());

    testCommon(threadPoolExecutor);
  }

  private void threadPoolExecutorTest2() throws InterruptedException {
    ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(5, 10, 5, TimeUnit.SECONDS,
            new LinkedBlockingQueue<>(3), (r, e) -> {
      System.out.println("有任务被拒绝!");
    });
    testCommon(threadPoolExecutor);
  }

  public static void main(String[] args) throws InterruptedException {
    Demo09 demo09 = new Demo09();
    demo09.threadPoolExecutorTest2();
  }
}
