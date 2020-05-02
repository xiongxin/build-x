package com.xiongxin.app;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class App {

    public static void main(String[] args) throws UnsupportedEncodingException {
        String text = URLEncoder.encode("http://openhome.cc?name=林","big5");
        System.out.println(text);

        String ct = "Content-Type: multipart/form-data; boundary=----WebKitFormBoundarygxgtHUzAr98RwUHZ";

        String c1 = "是\n" +
                "------WebKitFormBoundary3FSOZA5bqVfdDGu5\n" +
                "Content-Disposition: form-data; name=\"filename\"; filename=\"rui-magalhaes-7-ip-wpox4Y-unsplash.jpg\"\n" +
                "Content-Type: image/jpeg\n" +
                "\n" +
                "ÿØÿà\u0010";

        int pos = c1.indexOf("filename=\"");
        System.out.println((c1.indexOf("----WebKitFormBoundary3FSOZA5bqVfdDGu5")));
        System.out.println((c1.indexOf("----WebKitFormBoundary3FSOZA5bqVfdDGu5") - 4));
        System.out.println(c1.charAt(c1.indexOf("----WebKitFormBoundary3FSOZA5bqVfdDGu5") - 4));
        System.out.println(c1.indexOf("c"));
        System.out.println(c1.indexOf("c"));
        System.out.println(c1.indexOf("c"));
    }
}
