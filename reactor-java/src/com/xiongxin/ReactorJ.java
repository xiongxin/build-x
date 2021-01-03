package com.xiongxin;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicInteger;

public class ReactorJ {

    // 处理业务操作的线程
    private static ExecutorService workPool = Executors.newCachedThreadPool();

    // 封装selector.select()等时间轮训代码
    abstract class ReactorThread extends Thread {
        Selector selector;
        LinkedBlockingQueue<Runnable> taskQueue = new LinkedBlockingQueue<>();

        public abstract void handler(SelectableChannel channel) throws Exception;

        private ReactorThread() throws IOException {
            selector = Selector.open();
        }

        volatile boolean running = false;

        @Override
        public void run() {
            while (running) {
                try {
                    Runnable task;
                    while ((task = taskQueue.poll()) != null) {
                        task.run();
                    }
                    selector.select(1000);

                    var selected = selector.selectedKeys();
                    var iter = selected.iterator();
                    while (iter.hasNext()) {
                        var key = iter.next();
                        iter.remove();

                        var readyOps = key.readyOps();
                        if ((readyOps & (SelectionKey.OP_READ | SelectionKey.OP_ACCEPT)) != 0 || readyOps == 0) {
                            try {
                                var channel = (SelectableChannel) key.attachment();
                                channel.configureBlocking(false);
                                handler(channel);
                                if (!channel.isOpen()) {
                                    key.cancel();
                                }
                            } catch (Exception e) {
                                key.cancel();
                                e.printStackTrace();
                            }
                        }
                    }
                    selector.selectNow();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        private void doStart() {
            if (!running) {
                running = true;
                start();
            }
        }

        // 为什么register要以任务提交的形式，让reactor线程去处理？
        // 因为线程在执行channel注册到selector的过程中，会和调用selector.select()方法的线程争用同一把锁
        // 而select()方法实在eventLoop中通过while循环调用的，争抢的可能性很高，为了让register能更快的执行，就放到同一个线程来处理
        private SelectionKey register(SelectableChannel channel) throws Exception {
            var futureTask = new FutureTask<>(() -> channel.register(selector, 0, channel));
            taskQueue.add(futureTask);
            return futureTask.get();
        }
    }

    private ServerSocketChannel serverSocketChannel;

    private ReactorThread[] mainReactorThreads = new ReactorThread[1];
    private ReactorThread[] subReactorThreads = new ReactorThread[8];

    private void newGroup() throws IOException {
        for (var i = 0; i < subReactorThreads.length; i++) {
            subReactorThreads[i] = new ReactorThread() {
                @Override
                public void handler(SelectableChannel channel) throws Exception {
                    // work 线程只负责处理IO处理，不处理accept时间
                    var ch = (SocketChannel) channel;
                    var requestBuffer = ByteBuffer.allocate(1024);
                    while (ch.isOpen() && ch.read(requestBuffer) != -1) {
                        if (requestBuffer.position() > 0) break;
                    }
                    if (requestBuffer.position() == 0) return;
                    requestBuffer.flip();
                    var content = new byte[requestBuffer.limit()];
                    requestBuffer.get(content);
                    System.out.println(new String(content));
                    System.out.println(Thread.currentThread().getName() + "收到数据，来自:" + ch.getRemoteAddress());

                    workPool.submit(() -> {}); //业务操作 数据库 接口

                    var response = """
                            HTTP/1.1 200 OK
                            Content-Length: 11
                            
                            Hello world                         
                            """;
                    var buffer = ByteBuffer.wrap(response.getBytes());
                    while (buffer.hasRemaining())
                        ch.write(buffer);
                }
            };
        }

        for (var i = 0; i < mainReactorThreads.length; i++) {
            mainReactorThreads[i] = new ReactorThread() {
                AtomicInteger incr = new AtomicInteger(0);

                @Override
                public void handler(SelectableChannel channel) throws Exception {
                    var ch = (ServerSocketChannel) channel;
                    var socketChannel = ch.accept();
                    socketChannel.configureBlocking(false);

                    var index = incr.getAndIncrement() % subReactorThreads.length;
                    var workEventLoop = subReactorThreads[index];
                    workEventLoop.doStart();
                    var selectionKey = workEventLoop.register(socketChannel);
                    selectionKey.interestOps(SelectionKey.OP_READ);
                    System.out.println(Thread.currentThread().getName() + "收到新连接 : " + socketChannel.getRemoteAddress());
                }
            };
        }
    }

}
