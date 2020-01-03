package com.xiongxin.app;

import com.xiongxin.app.dao.TagDAO;
import com.xiongxin.app.domain.Tag;
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
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);

        try (SqlSession session = sqlSessionFactory.openSession()) {
            TagDAO tagDAO = session.getMapper(TagDAO.class);

            Tag tag = new Tag();
            tag.setName("Python3");
            tag.setPid(1);
            tag.setCreated(new Date());
            tag.setUpdated(new Date());


            int rows = tagDAO.insert(Tag.getInsertStatement(tag));

            System.out.println("args = " + rows);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
