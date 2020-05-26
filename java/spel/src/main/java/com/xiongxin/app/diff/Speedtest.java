package com.xiongxin.app.diff;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.LinkedList;

public class Speedtest {

    public static void main(String args[]) throws IOException {
        String text1 = readFile("/home/xiongxin/Code/build-x/java/spel/Speedtest1.txt");
        String text2 = readFile("/home/xiongxin/Code/build-x/java/spel/Speedtest2.txt");

        diff_match_patch dmp = new diff_match_patch();
        dmp.Diff_Timeout = 0;

        long start_time = System.nanoTime();
        LinkedList<diff_match_patch.Diff> rs = dmp.diff_main(text1, text2, false);

        rs.forEach(diff -> {
            System.out.println(diff.text);
            System.out.println(diff.operation);
        });

        long end_time = System.nanoTime();
        System.out.printf("Elapsed time: %f\n", ((end_time - start_time) / 1000000000.0));
    }

    private static String readFile(String filename) throws IOException {
        // Read a file from disk and return the text contents.
        StringBuilder sb = new StringBuilder();
        FileReader input = new FileReader(filename);
        BufferedReader bufRead = new BufferedReader(input);
        try {
            String line = bufRead.readLine();
            while (line != null) {
                sb.append(line).append('\n');
                line = bufRead.readLine();
            }
        } finally {
            bufRead.close();
            input.close();
        }
        return sb.toString();
    }
}