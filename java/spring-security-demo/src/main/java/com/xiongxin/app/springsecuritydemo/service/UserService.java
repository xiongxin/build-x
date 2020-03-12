package com.xiongxin.app.springsecuritydemo.service;

import com.xiongxin.app.springsecuritydemo.mapper.UserMapper;
import com.xiongxin.app.springsecuritydemo.model.Role;
import com.xiongxin.app.springsecuritydemo.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


public interface UserService {
    User findByUsername(String username);
    void save(User user);
    List<Role> findRolesById(int id);
}
