package com.xiongxin.app.springsecuritydemo.mapper;

import com.xiongxin.app.springsecuritydemo.model.Role;
import com.xiongxin.app.springsecuritydemo.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface UserMapper {

    User selectOneById( @Param("id") int id);
    User selectOneByUsername( @Param("username") String username);
    List<Role> selectRolesById(@Param("id") int id);
    void save(User user);
}
