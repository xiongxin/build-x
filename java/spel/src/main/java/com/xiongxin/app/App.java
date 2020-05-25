package com.xiongxin.app;

/**
 * Hello world!
 *
 */
public class App 
{
    public static class A<T> {
        public T a;
    }

    public static void main( String[] args )
    {

        A<String> a = new A<>();
        a.a = "abc";

        System.out.println( "Hello World!" );
    }
}
