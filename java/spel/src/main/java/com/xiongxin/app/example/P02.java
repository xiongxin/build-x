package com.xiongxin.app.example;

import org.springframework.expression.EvaluationContext;
import org.springframework.expression.Expression;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.SpelCompilerMode;
import org.springframework.expression.spel.SpelParserConfiguration;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.SimpleEvaluationContext;

import java.util.ArrayList;
import java.util.List;

public class P02 {

    public static class Simple {
        public List<Boolean> booleanList = new ArrayList<>();
    }

    public static class Demo {
        public List<String> list;
    }

    public static void main(String[] args) {
        Simple simple = new Simple();
        simple.booleanList.add(true);

        EvaluationContext context = SimpleEvaluationContext.forReadOnlyDataBinding().build();
        ExpressionParser parser = new SpelExpressionParser();

        parser.parseExpression("booleanList[0]")
                .setValue(context, simple, false);

        System.out.println(simple.booleanList.get(0));

        // Turn on:
        // - auto null reference initialization
        // - auto collection growing
        SpelParserConfiguration configuration = new SpelParserConfiguration(
                SpelCompilerMode.IMMEDIATE,
                P02.class.getClassLoader());
        ExpressionParser parser1 = new SpelExpressionParser(configuration);
        Expression expression = parser1.parseExpression("list[3]");
        Demo demo = new Demo();
        demo.list = new ArrayList<>();
        demo.list.add("a");
        demo.list.add("b");
        demo.list.add("c");
        demo.list.add("d");
        demo.list.add("e");
        Object o = expression.getValue(demo);

        System.out.println("demo.list.3 = " + o);
    }
}
