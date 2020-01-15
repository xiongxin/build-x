package com.xiongxin.app.dao;

import com.xiongxin.app.domain.Tag;
import com.xiongxin.app.table.TagTableDynamicSqlSupport;
import org.apache.ibatis.annotations.InsertProvider;
import org.apache.ibatis.annotations.Mapper;
import org.mybatis.dynamic.sql.SqlBuilder;
import org.mybatis.dynamic.sql.insert.render.InsertStatementProvider;
import org.mybatis.dynamic.sql.render.RenderingStrategies;
import org.mybatis.dynamic.sql.util.SqlProviderAdapter;

@Mapper
public interface TagDAO {

    int insert(Tag tag);

    Tag selectById(int id);
}
