package com.xiongxin.app.example;

import org.springframework.expression.AccessException;
import org.springframework.expression.BeanResolver;
import org.springframework.expression.EvaluationContext;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;

import java.util.Arrays;

public class P04 {

    public static class MyBeanResolver implements BeanResolver {

        @Override
        public Object resolve(EvaluationContext context, String beanName) throws AccessException {
            return "bean";
        }
    }

    public static void main(String[] args) {
        ExpressionParser parser = new SpelExpressionParser();
        StandardEvaluationContext context = new StandardEvaluationContext();
        context.setBeanResolver(new MyBeanResolver());

//        String bean = parser.parseExpression("@something").getValue(context, String.class);
        String bean = parser.parseExpression("&something").getValue(context, String.class);
        System.out.println(bean);

        byte[] FLAGS = new byte[256];

        for (int ch = '0'; ch <= '9'; ch++) {
            FLAGS[ch] |= 0x01 | 0x02;
        }
        for (int ch = 'A'; ch <= 'F'; ch++) {
            FLAGS[ch] |= 0x02;
        }
        for (int ch = 'a'; ch <= 'f'; ch++) {
            FLAGS[ch] |= 0x02;
        }
        for (int ch = 'A'; ch <= 'Z'; ch++) {
            FLAGS[ch] |= 0x04;
        }
        for (int ch = 'a'; ch <= 'z'; ch++) {
            FLAGS[ch] |= 0x04;
        }
        System.out.println(Arrays.toString(FLAGS));

        System.out.println("\0");
    }
}
