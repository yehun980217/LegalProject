package com.kpaas.kpaasproject.dto;

import lombok.Data;

import java.util.Date;

@Data
public class UserDTO {
    private int userNo ;
    private String userId ;
    private String userPwd ;
    private String userPhoneNum ;
    private String userName ;
    private String userAddress ;
    private Date userRegDate ;
    private String userGrade ;
    private String userResignYn ;
    private String userBirth;
}
