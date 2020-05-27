package com.xiongxin.app;

/**
 * 在表达式的执行上下文中注册,使用 @myBeanName 和 &myBeanName表达式时
 * 可以从factory bean中获取bean
 */
public interface BeanResolver {


    Object resolve()
}
