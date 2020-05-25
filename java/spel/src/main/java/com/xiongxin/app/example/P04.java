package com.xiongxin.app.example;

import org.springframework.expression.AccessException;
import org.springframework.expression.BeanResolver;
import org.springframework.expression.EvaluationContext;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;

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
    }
}
