package com.xiongxin.app.example;

import java.util.Arrays;

public class P04 {

    public static void main(String[] args) {
        byte[] FLAGS = new byte[256];

        for (int ch = '0'; ch <= '9'; ch++) {
            FLAGS[ch] |= 0x01 | 0x02;
        }
        for (int ch = 'A'; ch <= 'F'; ch++) {
            FLAGS[ch] |= 0x02;
        }
        for (int ch = 'a'; ch <= 'f'; ch++) {
            FLAGS[ch] |= 0x02;
        }
        for (int ch = 'A'; ch <= 'Z'; ch++) {
            FLAGS[ch] |= 0x04;
        }
        for (int ch = 'a'; ch <= 'z'; ch++) {
            FLAGS[ch] |= 0x04;
        }
        System.out.println(Arrays.toString(FLAGS));

        System.out.println("\0");
    }
}
