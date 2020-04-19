package com.xiongxin.app.base;

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public class P01 {
  public static String convertStreamToString(InputStream is) {
    BufferedReader reader = new BufferedReader(new InputStreamReader(is));
    StringBuilder sb = new StringBuilder();

    String line = null;

    try {
      while ((line = reader.readLine()) != null) {
        sb.append(line + "\n");
      }
    } catch (IOException e) {
      e.printStackTrace();
    } finally {
      try {
        is.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }

    return sb.toString();
  }



  public static void main(String[] args) throws IllegalAccessException, InstantiationException {
    Number n = 0;

    Class aClass = n.getClass();

    System.out.println("args = " + Integer.TYPE.toString());

    List<String> list = new ArrayList<String>();

    System.out.println(list.getClass().toGenericString());



    //System.out.println(convertStreamToString(P01.class.getResourceAsStream("/Demo1.txt")));


    String str = "kkasdkfjlkasjdlk";

    System.out.println(str.lastIndexOf('k'));

    String Str = new String("www.runoob.com");
    System.out.println(Str.matches("(.*)runoob(.*)"));

    String[] strings = new String[] {"abc","def"};
    System.out.println(String.join("/", strings));

    System.out.println(String.format("字符串: %,d%n", 1132432432));
  }
}
