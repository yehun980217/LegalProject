package com.kpaas.kpaasproject.controller;

import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.service.AdminService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@AllArgsConstructor
public class AdminController {

    @Autowired
    AdminService adminService;

    private final BCryptPasswordEncoder passwordEncoder;

    @GetMapping("/admin/adminSignUp")
    public String adminSignUp() {
        return "admin/adminSignUp";
    }

    @PostMapping("/admin/adminSignUp")
    public String userSignUp(UserDTO userDto) {

        String originPwd = userDto.getUserPwd();
        System.out.println("originPwd" + originPwd);

        //userPwd에 암호화하여 저장
        //(암호화할 비번, BCrypt.gensalt())
        String userPwd = BCrypt.hashpw(originPwd, BCrypt.gensalt());
        System.out.println("userPwd" + userPwd);

        //암호화된 비번 userPwd를 userVo에 저장
        userDto.setUserPwd(userPwd);


        //복호화 확인 위한 객체 생성
        BCryptPasswordEncoder e = new BCryptPasswordEncoder()	;

        //복호화 위한 matches(입력비밀번호, 암호화 비밀번호)
        System.out.println("일치확인" + e.matches(originPwd, userPwd)) ;


        // 최종 DB저장
        adminService.insertAdmin(userDto);

        return "redirect:/";
    }
}
