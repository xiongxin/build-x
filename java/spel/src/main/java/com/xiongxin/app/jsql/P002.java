package com.xiongxin.app.jsql;

import net.sf.jsqlparser.JSQLParserException;
import net.sf.jsqlparser.expression.*;
import net.sf.jsqlparser.expression.operators.arithmetic.*;
import net.sf.jsqlparser.expression.operators.conditional.AndExpression;
import net.sf.jsqlparser.expression.operators.conditional.OrExpression;
import net.sf.jsqlparser.expression.operators.relational.*;
import net.sf.jsqlparser.parser.CCJSqlParserManager;
import net.sf.jsqlparser.schema.Column;
import net.sf.jsqlparser.statement.select.*;

import java.io.StringReader;

public class P002 {
    private static final CCJSqlParserManager parserManager = new CCJSqlParserManager();

    public static void main(String[] args) throws JSQLParserException {
        String statement = "SELECT a.col1, col2 b, col3 AS c FROM table WHERE a.id = b.id and c = 'a' and col1 = 10 AND col2 = 20 AND col3 = 30 limit 10";

        Select select = (Select) parserManager.parse(new StringReader(statement));
        PlainSelect plainSelect = (PlainSelect) select.getSelectBody();

        plainSelect.getSelectItems().forEach(selectItem -> {
            selectItem.accept(new SelectItemVisitorAdapter() {
                @Override
                public void visit(SelectExpressionItem item) {
                    if (item.getAlias() == null) {
                        Column column = (Column) item.getExpression();
                        System.out.println(column.getName(false));
                    } else {
                        System.out.println(item.getAlias().getName());
                    }
                }
            });
        });


        System.out.println("==========");
        System.out.println("offset = " + plainSelect.getLimit().getOffset());
        System.out.println("rowCount = " + plainSelect.getLimit().getRowCount());

        System.out.println("==========");
        BinaryExpression binaryExpression = (BinaryExpression) plainSelect.getWhere();

        binaryExpression.accept(new ExpressionVisitorAdapter(){
            @Override
            public void visit(EqualsTo expr) {
                if (!(expr.getRightExpression() instanceof Column)) {
                    System.out.println( "左值： " + ((Column) expr.getLeftExpression()).getColumnName() + ":" + expr.getRightExpression());
                }
                visitBinaryExpression(expr);
            }

            @Override
            public void visit(Column column) {
                super.visit(column);
            }

            @Override
            public void visit(GreaterThan expr) {
                visitBinaryExpression(expr);
            }

            @Override
            public void visit(GreaterThanEquals expr) {
                visitBinaryExpression(expr);
            }


        });
    }
}
