package com.xiongxin.app.domain;


import com.xiongxin.app.table.TagTableDynamicSqlSupport;
import org.mybatis.dynamic.sql.SqlBuilder;
import org.mybatis.dynamic.sql.insert.render.InsertStatementProvider;
import org.mybatis.dynamic.sql.render.RenderingStrategies;
import org.mybatis.dynamic.sql.update.render.UpdateStatementProvider;

import java.util.Date;


public class Tag {
    private Integer id;
    private String name;
    private Integer pid;
    private Date created;
    private Date updated;

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public Date getUpdated() {
        return updated;
    }

    public void setUpdated(Date updated) {
        this.updated = updated;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getPid() {
        return pid;
    }

    public void setPid(Integer pid) {
        this.pid = pid;
    }

    public static InsertStatementProvider<Tag> getInsertStatement(Tag tag) {
        return SqlBuilder.insert(tag).into(TagTableDynamicSqlSupport.tagTable)
                .map(TagTableDynamicSqlSupport.name).toProperty("name")
                .map(TagTableDynamicSqlSupport.pid).toProperty("pid")
                .map(TagTableDynamicSqlSupport.created).toProperty("created")
                .map(TagTableDynamicSqlSupport.updated).toProperty("updated")
                .build()
                .render(RenderingStrategies.MYBATIS3);
    }

}
