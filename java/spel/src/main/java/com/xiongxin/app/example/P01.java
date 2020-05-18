package com.xiongxin.app.example;

import org.springframework.expression.EvaluationContext;
import org.springframework.expression.Expression;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.common.TemplateParserContext;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;

import java.util.Arrays;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;

public class P01 {

    public static class User {
        private int age;
        private String name;

        public int getAge() {
            return age;
        }

        public void setAge(int age) {
            this.age = age;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public User(int age, String name) {
            this.age = age;
            this.name = name;
        }
    }

    public static void main(String[] args) {
        String greetingExp = "Hello, #{ new java.util.Date() }" +
                "#{ T(Math).random() }, #{ 'hello'.concat(',world') } ," +
                " #{ #user.age + ' ' + #map['a'] + ' ' + #list[0] + ' ' + #user.name }";
        ExpressionParser parser = new SpelExpressionParser();
        EvaluationContext context = new StandardEvaluationContext();

        context.setVariable("user", new User(12, "xx"));

        List<String> stringList = Arrays.asList("abc", "ddd");

        context.setVariable("list", stringList);
        context.setVariable("map", new HashMap<String, String>() {{
            this.put("a", "a1");
            this.put("b", "b1");
        }});

        Expression expression = parser.parseExpression(greetingExp,
                new TemplateParserContext());

        System.out.println(expression.getValue(context, String.class));


        System.out.println("================");

        ExpressionParser parser1 = new SpelExpressionParser();
        Expression expression1 = parser1.parseExpression("name");
        String name = expression1.getValue(new User(12, "xx"), String.class);
        expression1 = parser1.parseExpression("age == 13");
        boolean result = expression1.getValue(new User(13, "dd"),Boolean.class);
        System.out.println("name = " + name +", age == 13 =  " + result);
    }
}
