package com.kpaas.kpaasproject.controller;

import com.kpaas.kpaasproject.dto.UserDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Slf4j
@Controller
public class HomeController {

    private final String CLIENT_ID = "J4wziIcpqpqstZNyKsEF";
    private final String CLIENT_SECRET = "1aB2n0iE2L";
    private final String API_URL = "https://openapi.naver.com/v1/search/news.json";

    @GetMapping("/")
    public String index(){
        return "index";
    }



    @GetMapping("/login")
    public String loginPage() {
        return "login/userLogin";
    }

    @GetMapping("/signup/userSignUp")
    public String userSignUp() {
        return "signup/userSignUp";
    }

    @GetMapping("/login/userFind")
    public String userFind() {
        return "login/userFind";
    }

    @GetMapping("signup/userSignOut")
    public String userSignOut(UserDTO userDto) {
        return "signup/userSignOut";
    }
}