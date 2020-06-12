package com.xiongxin.app;

public class P00 {

    private int i = 1;
    private String a = "abc";

    public static void main(String[] args) {
        tryFinally();
    }


    static void tryFinally() {
        try {
            int a = 1;
            int b = 0;
            int c = a / b;
        } catch (Exception e) {
            System.out.println("捕获到异常");
        } finally {
            System.out.println("finally最先执行");
        }
    }

    void createBuffer() {
        int buffer[];
        int bufsz = 100;
        int value = 12;
        buffer = new int[bufsz];
        buffer[10] = value;
        value = buffer[11];

        P00 p00 = new P00();
        this.a = "a";
    }

    int[][][] create3DArray() {
        int grid[][][];
        grid = new int[10][5][];
        return grid;
    }
}
