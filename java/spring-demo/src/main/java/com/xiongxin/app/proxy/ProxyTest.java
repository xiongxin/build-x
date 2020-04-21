package com.xiongxin.app.proxy;

import java.lang.reflect.Proxy;

public class ProxyTest {


    public static void main(String[] args) {


        IHello iHello = (IHello) Proxy.newProxyInstance(IHello.class.getClassLoader(),
                new Class[] {IHello.class},
                new MyInvocationHandler(new HelloImpl()));


        iHello.sayHello();
    }
}
