package com.kpaas.kpaasproject.mapper;

import com.kpaas.kpaasproject.dto.UserDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.HashMap;
import java.util.Map;

@Mapper
public interface LogMapper {
    //아이디에 저장된 비밀번호 가져오기
    String findUserPwd(String userId) ;

    //아이디 통한 유저 정보 받아오기 (세션에 넣을 거)
    UserDTO getUserInfoById(String userId) ;

    // 카카오로 받은 정보가 회원목록에 있는지 확인
    public UserDTO findKakao(HashMap<String, Object> userInfo);

    // 카카오 회원 정보 저장
    public void kakaoInsert(HashMap<String, Object> userInfo);

    public String findUserByNameAndPhone(String userName, String userPhoneNum);
    public UserDTO findUserByIdNamePhone(String userId, String userName, String userPhoneNum);

    void updatePassword(@Param("userId") String userId, @Param("newPassword") String newPassword);

    void updatePassword(Map<String, String> paramMap);
}
