package com.xiongxin.app;

import com.xiongxin.app.dao.TagDAO;
import com.xiongxin.app.domain.Example;
import com.xiongxin.app.domain.Tag;
import com.xiongxin.app.enums.Fruit;
import com.xiongxin.app.table.TagTableDynamicSqlSupport;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.mybatis.dynamic.sql.SqlTable;
import org.mybatis.dynamic.sql.insert.render.InsertStatementProvider;
import org.mybatis.dynamic.sql.render.RenderingStrategies;
import org.mybatis.dynamic.sql.render.RenderingStrategy;
import org.mybatis.dynamic.sql.select.render.SelectStatementProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Date;

import static org.mybatis.dynamic.sql.SqlBuilder.insert;
import static org.mybatis.dynamic.sql.SqlBuilder.select;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args ) throws IOException {
        String resource = "mybatis-config.xml";
        Logger logger = LoggerFactory.getLogger(App.class);
        logger.info("abc");
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);

        Fruit fruit = Fruit.Apple;
        System.out.println(fruit.name());

        try (SqlSession session = sqlSessionFactory.openSession()) {
            TagDAO tagDAO = session.getMapper(TagDAO.class);
            Tag tag = tagDAO.selectById(25);
            tag.setFruit(Fruit.Banner);
            tag.setExample(new Example("dd"));
            System.out.println("tag = " + tag + ", id=" + tagDAO.insert(tag) + ", update = " + tagDAO.updateById(25));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
