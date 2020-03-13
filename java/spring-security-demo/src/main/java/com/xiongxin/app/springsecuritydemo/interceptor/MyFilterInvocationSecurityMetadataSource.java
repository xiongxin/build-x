package com.xiongxin.app.springsecuritydemo.interceptor;


import com.xiongxin.app.springsecuritydemo.mapper.SysPermissionMapper;
import com.xiongxin.app.springsecuritydemo.model.SysPermission;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Service
public class MyFilterInvocationSecurityMetadataSource implements FilterInvocationSecurityMetadataSource {

    @Autowired
    private SysPermissionMapper permissionMapper;

    private HashMap<String, Collection<ConfigAttribute>> map = null;


    /**
     * 加载权限表中所有权限
     */
    public void loadResourceDefined() {
        map = new HashMap<>();
        Collection<ConfigAttribute> array;
        ConfigAttribute cfg;

        List<SysPermission> permissions = permissionMapper.findAll();
        for (SysPermission permission: permissions) {
            array = new ArrayList<>();
            //此处只添加了用户的名字，其实还可以添加更多权限的信息，
            // 例如请求方法到ConfigAttribute的集合中去。
            // 此处添加的信息将会作为MyAccessDecisionManager类的decide的第三个参数。
            cfg = new SecurityConfig(permission.getName());
            array.add(cfg);
            //用权限的getUrl() 作为map的key，用ConfigAttribute的集合作为 value，
            map.put(permission.getUrl(), array);
        }
    }

    /**
     * 此方法是为了判定用户请求的url 是否在权限表中，如果在权限表中，
     * 则返回给 decide 方法，用来判定用户是否有此权限。如果不在权限表中则放行。
     *
     * @param o
     * @return
     * @throws IllegalArgumentException
     */
    @Override
    public Collection<ConfigAttribute> getAttributes(Object o) throws IllegalArgumentException {
        if (map == null) loadResourceDefined();

        HttpServletRequest request = ((FilterInvocation) o).getHttpRequest();
        AntPathRequestMatcher matcher;
        String resUrl;

        for (Iterator<String> iterator = map.keySet().iterator();iterator.hasNext();){
            resUrl = iterator.next();
            matcher = new AntPathRequestMatcher(resUrl);
            if (matcher.matches(request)) {
                return map.get(resUrl);
            }
        }

        return null;
    }

    @Override
    public Collection<ConfigAttribute> getAllConfigAttributes() {
        return null;
    }

    @Override
    public boolean supports(Class<?> aClass) {
        return true;
    }
}
