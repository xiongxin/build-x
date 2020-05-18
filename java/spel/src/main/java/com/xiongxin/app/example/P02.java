package com.xiongxin.app.example;

import org.springframework.expression.EvaluationContext;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.SimpleEvaluationContext;

import java.util.ArrayList;
import java.util.List;

public class P02 {

    public static class Simple {
        public List<Boolean> booleanList = new ArrayList<>();
    }

    public static void main(String[] args) {
        Simple simple = new Simple();
        simple.booleanList.add(true);

        EvaluationContext context = SimpleEvaluationContext.forReadOnlyDataBinding().build();
        ExpressionParser parser = new SpelExpressionParser();

        parser.parseExpression("booleanList[0]")
                .setValue(context, simple, false);

        System.out.println(simple.booleanList.get(0));
    }
}
