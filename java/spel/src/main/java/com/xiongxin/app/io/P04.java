package com.xiongxin.app.io;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PushbackInputStream;

public class P04 {

    public static void main(String[] args) {

        String srcFile = "luci1.txt";
        try (PushbackInputStream pis = new PushbackInputStream(new FileInputStream(srcFile))) {
            // Read one byte at a time and display it
            byte byteData;
            while ((byteData = (byte) pis.read()) != -1) {
                System.out.print((char) byteData);
                pis.unread(byteData);

                byteData = (byte) pis.read();
                System.out.print((char) byteData);
            }

        } catch (FileNotFoundException e) {
            FileUtil.printFileNotFoundMsg(srcFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
