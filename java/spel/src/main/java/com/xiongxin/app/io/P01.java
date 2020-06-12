package com.xiongxin.app.io;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

public class P01 {

    public static void main(String[] args) throws IOException {
        // The data source
        String srcFile = "luci1.txt";
        // Create a file input stream
        FileInputStream fin = new FileInputStream(srcFile);

        int data;
        byte byteData;

        // Read the first byte
//        data = fin.read();
//        while (data != -1) {
//            // Display the read data on the console. Note the cast
//            // from int to byte - (byte) data
//            byteData = (byte) data;
//            // Cast the byte data to char to display the data
//            System.out.print((char) byteData);
//
//            // Try reading another byte
//            data = fin.read();
//        }

        while ((data = fin.read()) != -1) {
            System.out.print((char) data);
        }

        try {
            fin.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
