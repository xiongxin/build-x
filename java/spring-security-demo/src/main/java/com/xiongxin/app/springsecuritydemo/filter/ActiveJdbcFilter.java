package com.xiongxin.app.springsecuritydemo.filter;


import org.javalite.activejdbc.Base;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import java.io.IOException;

//@Component
public class ActiveJdbcFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        long before = System.currentTimeMillis();

        try {
            Base.open();
            Base.openTransaction();
            filterChain.doFilter(servletRequest, servletResponse);
            Base.commitTransaction();
        } catch (IOException | ServletException e) {
            Base.rollbackTransaction();
            throw e;
        } finally {
            Base.close();
        }

    }
}
