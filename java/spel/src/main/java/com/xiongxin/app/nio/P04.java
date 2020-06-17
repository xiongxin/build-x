package com.xiongxin.app.nio;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.util.Arrays;

public class P04 {

    public static void main(String[] args) {

        Charset cs = Charset.forName("UTF-8");
        CharBuffer cb = CharBuffer.wrap("中文城市");
        ByteBuffer encodeData = cs.encode(cb);
        System.out.print(Arrays.toString(encodeData.array()));

        CharBuffer decodeData = cs.decode(encodeData);

        System.out.println(decodeData.toString());

        System.out.println(" ".length());
    }
}
