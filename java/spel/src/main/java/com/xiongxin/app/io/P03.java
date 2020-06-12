package com.xiongxin.app.io;

import com.xiongxin.app.io.FileUtil;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class P03 {

    public static void main(String[] args) {
        String destFile = "luci2.txt";
        // Get the line separator for the current platform
        String lineSeparator = System.getProperty("line.separator");

        String line1 = "abc1";
        String line2 = "abc2";
        String line3 = "abc3";
        String line4 = "abc4";

        try (FileOutputStream fos = new FileOutputStream(destFile)) {
            // Write all four lines to the output stream as bytes
            fos.write(line1.getBytes());
            fos.write(lineSeparator.getBytes());

            fos.write(line2.getBytes());
            fos.write(lineSeparator.getBytes());

            fos.write(line3.getBytes());
            fos.write(lineSeparator.getBytes());

            fos.write(line4.getBytes());
            fos.write(lineSeparator.getBytes());

            // Flush the written bytes to the file
            fos.flush();

            // Display the output file path
            System.out.print("Text has been written to " +
                    (new File(destFile)).getAbsolutePath());

        } catch (FileNotFoundException e) {
            FileUtil.printFileNotFoundMsg(destFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
