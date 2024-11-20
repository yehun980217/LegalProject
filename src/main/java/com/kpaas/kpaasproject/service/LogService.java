package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.UserDTO;
import org.apache.ibatis.annotations.Param;

public interface LogService {
    String getUserPwdById(String userId) ;

    UserDTO getUserById(String userId) ;

    // 카카오 토큰 받기
    public String getAccessToken(String code);

    // 카카오 로그인 정보 저장
    public UserDTO getUserInfo(String access_Token);

    String findUserIdByNameAndPhone(String userName, String userPhoneNum);
    public UserDTO findUserByIdNamePhone(String userId, String userName, String userPhoneNum);

    void updatePassword(@Param("userId") String userId, @Param("userPwd") String newPassword);

}
