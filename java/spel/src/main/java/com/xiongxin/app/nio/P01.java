package com.xiongxin.app.nio;

import java.nio.ByteBuffer;

public class P01 {

    public static void main(String[] args) {
        ByteBuffer bb = ByteBuffer.allocateDirect(8);

        System.out.println("Capacity: " + bb.capacity());
        System.out.println("Limit: " + bb.limit());
        System.out.println("Position: " + bb.position());

        printBufferInfo(bb);

        for (int i = 50; i < 58; i++) {
            bb.put((byte) i);
        }

        System.out.println("After populating data");
        printBufferInfo(bb);

    }


    public static void printBufferInfo(ByteBuffer bb) {
        int limit = bb.limit();
        System.out.println("Position = " + bb.position() + ", Limit = " + limit);

        // Use absolute reading without affecting the position
        System.out.println("Data: ");
        for (int i = 0; i < limit; i++) {
            System.out.print(bb.get(i) + " ");
        }
        System.out.println();
    }
}
