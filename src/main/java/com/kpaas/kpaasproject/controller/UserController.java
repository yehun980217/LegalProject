package com.kpaas.kpaasproject.controller;

import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@AllArgsConstructor
public class UserController {
    @Autowired
    UserService userService;

    private final BCryptPasswordEncoder passwordEncoder;

    @ResponseBody
    @PostMapping("/signUp/chkId")
    public String chkId(String userId) { // 회원가입 시 아이디 중복 검사
        List<String> userIdList = userService.getUserId();
        if (userIdList.contains(userId)) {
            return "fail";
        }
        return "success";
    }

    @PostMapping("/signUp/userSignUp")
    public String userSignUp(UserDTO userDto, String sample4_roadAddress, String sample4_detailAddress, String birthYear, String birthMonth, String birthDay) {

        String monthStr = String.format("%02d", Integer.parseInt(birthMonth)); // 두 자리로 포맷팅
        String dayStr = String.format("%02d", Integer.parseInt(birthDay)); // 두 자리로 포맷팅

        String userBirth = birthYear + monthStr + dayStr; // 19980217

        userDto.setUserBirth(userBirth);
        // 웹페이지에서 회원가입 시 입력한 값이 userVo 멤버 변수 안에 자동 저장 여기서 입력한 pwd 를 originPwd에 입력
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


        String userAddress = sample4_roadAddress + " " + sample4_detailAddress;
        userDto.setUserAddress(userAddress);

        // 최종 DB저장
        userService.insertUser(userDto);

        return "redirect:/";
    }

    @PostMapping("/signup/userSignOut")
    public String userSignOut(HttpSession session, @RequestParam(value = "userId", required = false) String userId) {
        UserDTO userDto = (UserDTO) session.getAttribute("loggedInUser");

        if (userDto != null) {
            System.out.println("탈퇴 실행 - 세션에 저장된 userId: " + userDto.getUserId());
            System.out.println("폼으로 전달된 userId: " + userId);
            userService.deleteUserById(userDto.getUserId());
            session.invalidate();
        } else {
            System.out.println("세션에 userDTO가 없습니다.");
        }

        return "redirect:/";
    }


}
