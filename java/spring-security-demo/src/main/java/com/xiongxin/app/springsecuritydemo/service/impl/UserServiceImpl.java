package com.xiongxin.app.springsecuritydemo.service.impl;

import com.xiongxin.app.springsecuritydemo.mapper.UserMapper;
import com.xiongxin.app.springsecuritydemo.model.Role;
import com.xiongxin.app.springsecuritydemo.model.User;
import com.xiongxin.app.springsecuritydemo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Transactional(readOnly = true)
    @Override
    public User findByUsername(String username) {
        return userMapper.selectOneByUsername(username);
    }

    @Override
    public void save(User user) {
        user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
        userMapper.save(user);
    }

    @Override
    public List<Role> findRolesById(int id) {
        return userMapper.selectRolesById(id);
    }
}
