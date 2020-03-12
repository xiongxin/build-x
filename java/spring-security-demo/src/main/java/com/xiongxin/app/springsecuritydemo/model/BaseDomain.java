package com.xiongxin.app.springsecuritydemo.model;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

public class BaseDomain implements Serializable {

    protected Long id;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    protected Date created;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    protected Date updated;
    protected String extra; // 表额外字段

    public Long getId( ) {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    public Date getCreated( ) {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public Date getUpdated( ) {
        return updated;
    }

    public void setUpdated(Date updated) {
        this.updated = updated;
    }

    public String getExtra( ) {
        return extra;
    }

    public void setExtra(String extra) {
        this.extra = extra;
    }
}
