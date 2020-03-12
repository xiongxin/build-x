package com.xiongxin.app.springsecuritydemo.service.impl;

import com.xiongxin.app.springsecuritydemo.mapper.UserMapper;
import com.xiongxin.app.springsecuritydemo.model.Role;
import com.xiongxin.app.springsecuritydemo.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Set;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    private UserMapper userMapper;

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userMapper.selectOneByUsername(username);
        if (user == null)
            throw new UsernameNotFoundException(username);

        // 读取用户角色
        Set<GrantedAuthority> grantedAuthorities = new HashSet<>();
        for (Role role : userMapper.selectRolesById(user.getId())) {
            grantedAuthorities.add(new SimpleGrantedAuthority(role.getName()));
        }

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                grantedAuthorities
        );
    }
}
