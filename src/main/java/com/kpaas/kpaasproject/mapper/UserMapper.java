package com.kpaas.kpaasproject.mapper;

import com.kpaas.kpaasproject.dto.UserDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {
    List<String> getUserId(); // 회원가입 시 아이디 중복 검사

    int insertUser(UserDTO userDto);

    void deleteUserById(String userId);
}
