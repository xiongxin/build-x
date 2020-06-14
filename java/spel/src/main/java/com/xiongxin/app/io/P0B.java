package com.xiongxin.app.io;

import java.io.IOException;
import java.io.StreamTokenizer;
import java.io.StringReader;

import static java.io.StreamTokenizer.TT_NUMBER;
import static java.io.StreamTokenizer.TT_WORD;

public class P0B {

    public static void main(String[] args) {
        String str = "This is a test, 208.22 which is simple 50";
        StringReader sr = new StringReader(str);
        StreamTokenizer st = new StreamTokenizer(sr);

        try {
            while (st.nextToken() != StreamTokenizer.TT_EOF) {
                switch (st.ttype) {
                    case TT_WORD:
                        System.out.println("String value: " + st.sval);
                        break;
                    case TT_NUMBER:
                        System.out.println("Number value: " + st.nval);
                        break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
