package com.xiongxin.app.springsecuritydemo.web;


import com.xiongxin.app.springsecuritydemo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private UserService userService;

    @GetMapping({ "/", "/welcome" })
    public String index(Model model) {
        System.out.println(userService.findRolesById(1));
        return "index";
    }
}
