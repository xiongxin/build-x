package com.xiongxin.app.springsecuritydemo.mapper;

import com.xiongxin.app.springsecuritydemo.model.SysPermission;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface SysPermissionMapper {

    List<SysPermission> findAll();
    List<SysPermission> findByAdminUserId( @Param("UserId") int userId);
}
