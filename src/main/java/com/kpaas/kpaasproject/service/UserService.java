package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.UserDTO;

import java.util.List;

public interface UserService {
    List<String> getUserId(); // 회원가입 시 아이디 중복 검사

    int insertUser(UserDTO userDto);

    void deleteUserById(String userId);
}
