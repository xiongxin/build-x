package com.xiongxin.app.springsecuritydemo.mapper;

import com.xiongxin.app.springsecuritydemo.model.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;


@Mapper
@Repository
public interface SysUserMapper {

    SysUser findByUsername(String username);
}
