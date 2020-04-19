package com.xiongxin.app.springsecuritydemo.web;


import com.xiongxin.app.springsecuritydemo.form.UserForm;
import com.xiongxin.app.springsecuritydemo.mapper.SysUserMapper;
import com.xiongxin.app.springsecuritydemo.model.SysUser;
import com.xiongxin.app.springsecuritydemo.model.User;
import com.xiongxin.app.springsecuritydemo.service.SecurityService;
import com.xiongxin.app.springsecuritydemo.service.UserService;
import com.xiongxin.app.springsecuritydemo.validator.UserFormValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;


@Controller
public class UserController {


    @Autowired
    private UserService userService;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private SysUserMapper mapper;
    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    private UserFormValidator userFormValidator;


    @GetMapping("/registration")
    public String registration(Model model) {
        model.addAttribute("userForm", new UserForm());

        return "registration";
    }


    @PostMapping("/registration")
    public String registration(@ModelAttribute("userForm") UserForm userForm, BindingResult bindingResult) {
        userFormValidator.validate(userForm, bindingResult);

        if (bindingResult.hasErrors()) {
            return "registration";
        }

        SysUser user = new SysUser();
        user.setPassword(bCryptPasswordEncoder.encode(userForm.getPassword()));
        user.setUsername(userForm.getUsername());

        mapper.save(user);

        securityService.autoLogin(userForm.getUsername(), userForm.getPassword());

        return "redirect:/";
    }


    @GetMapping("/login")
    public String login(Model model, String error, String logout) {
        if (error != null) {
            model.addAttribute("error", "Your username or password is invalid.");
        }

        if (logout != null) {
            model.addAttribute("message", "You have been logged out successfully.");
        }

        return "login";
    }
}
