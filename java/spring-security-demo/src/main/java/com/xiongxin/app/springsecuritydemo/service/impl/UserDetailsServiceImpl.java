package com.xiongxin.app.springsecuritydemo.service.impl;

import com.xiongxin.app.springsecuritydemo.mapper.SysPermissionMapper;
import com.xiongxin.app.springsecuritydemo.mapper.SysUserMapper;
import com.xiongxin.app.springsecuritydemo.mapper.UserMapper;
import com.xiongxin.app.springsecuritydemo.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private SysPermissionMapper sysPermissionMapper;

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        SysUser user = sysUserMapper.findByUsername(username);
        if (user == null)
            throw new UsernameNotFoundException(username);

        List<SysPermission> permissions = sysPermissionMapper.findByAdminUserId(user.getId());
        Set<GrantedAuthority> grantedAuthorities = new HashSet<>();

        for (SysPermission permission : permissions) {
            if (permission != null && permission.getName() != null) {
                grantedAuthorities.add(new SimpleGrantedAuthority(permission.getName()));
            }
        }

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                grantedAuthorities
        );
    }
}
