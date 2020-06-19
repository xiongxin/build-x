package com.xiongxin.app.nio;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.Pipe;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.util.Random;

public class PipeTest {

    public static void main(String[] args) throws IOException {
        WritableByteChannel out = Channels.newChannel(System.out);
        // Start worker and get read end of channel
        ReadableByteChannel workerChannel = startWorker(10);
        ByteBuffer buffer = ByteBuffer.allocate(100);

        while (workerChannel.read(buffer) >= 0) {
            buffer.flip();
            out.write(buffer);  // 通过管道从其他线程读取数据之后写入到当前线程的屏幕上
            buffer.clear();
        }
    }

    private static ReadableByteChannel startWorker(int reps) throws IOException {
        Pipe pipe = Pipe.open();
        Worker worker = new Worker(pipe.sink(), reps); // 获取到的池子channel，可以往里面倒东西

        worker.start();

        return pipe.source(); // 返回管道的可读channel，可以读取内容
    }

    /**
     * A worker thread object which writes data down a channel.
     * Note: this object knows nothing about Pipe, uses only a
     * generic WritableByteChannel.
     */
    private static class Worker extends Thread
    {
        WritableByteChannel channel;
        private int reps;

        Worker(WritableByteChannel channel, int reps)
        {
            this.channel = channel;
            this.reps = reps;
        }

        // Thread execution begins here
        public void run()
        {
            ByteBuffer buffer = ByteBuffer.allocate(100);

            try {
                for (int i = 0; i < this.reps; i++) {
                    doSomeWork(buffer);

                    // channel may no take it all at once
                    while (channel.write(buffer) > 0);
                }

                this.channel.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        private String[] products = {
                "No good deed goes unpunished",
                "To be, or what?",
                "No matter where you go, there you are",
                "Just say \"Yo\"",
                "My karma ran over my dogma"
        };

        private Random random = new Random();

        private void doSomeWork(ByteBuffer buffer)
        {
            int product = random.nextInt(products.length);

            buffer.clear();
            buffer.put(products[product].getBytes());
            buffer.put("\r\n".getBytes());
            buffer.flip();
        }
    }
}
