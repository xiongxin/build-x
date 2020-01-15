package com.xiongxin.app.intercepts;

import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Signature;

import java.util.Properties;
import java.util.concurrent.Executor;

@Intercepts({@Signature(
        type = Executor.class,
        method = "insert",
        args = {MappedStatement.class, Object.class}
)})
public class ExamplePlugin implements Interceptor {
    private Properties properties = new Properties();

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        Object returnObj = invocation.proceed();
        System.out.println("returnObj = " + returnObj);
        return returnObj;
    }

    @Override
    public Object plugin(Object target) {
        return null;
    }

    @Override
    public void setProperties(Properties properties) {
        this.properties = properties;
    }
}
