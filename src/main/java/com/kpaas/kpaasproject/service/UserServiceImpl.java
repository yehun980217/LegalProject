package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService{
    @Autowired
    UserMapper userMapper;

    @Override
    public List<String> getUserId() { // 회원가입 시 아이디 중복 검사
        return userMapper.getUserId();
    }

    @Override
    public int insertUser(UserDTO userDto) {
        return userMapper.insertUser(userDto);
    }

    @Override
    public void deleteUserById(String userId) {
        System.out.println("탈퇴실행2");
        System.out.println("진행 아이디는 " + userId);
        userMapper.deleteUserById(userId); // DB에서 해당 회원 정보 삭제
    }

}
