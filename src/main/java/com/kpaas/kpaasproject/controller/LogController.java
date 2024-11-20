package com.kpaas.kpaasproject.controller;

import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.service.LogService;
import com.kpaas.kpaasproject.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/login/*")
@AllArgsConstructor
@RequiredArgsConstructor
public class LogController {
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Autowired
    UserService userService;

    @Autowired
    LogService logService;

    @GetMapping("/userLogin")
    public String loginForm(HttpSession session, Model model) {

        if(session.getAttribute("userDTO")!=null) {
            return "/" ;
        }else {
//
//            /* 네이버아이디로 인증 URL을 생성하기 위하여 NaverService클래스의 getAuthorizationUrl메소드 호출 */
//            String naverAuthUrl = naverService.getAuthorizationUrl(session);
//
//            System.out.println("네이버:" + naverAuthUrl);            //네이버
//            model.addAttribute("naverUrl", naverAuthUrl);
//
            return "login/userLogin" ;
        }
    }

    @PostMapping("/login/userLogin")
    public String loginChkMtd(String userId, String userPwd, Model model, RedirectAttributes rttr, HttpSession session) {
        List<String> userIdList = userService.getUserId();
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        if(userIdList.contains(userId)) {
            String dbUserPwd = logService.getUserPwdById(userId);
            if(encoder.matches(userPwd, dbUserPwd)) {
                session.setAttribute("loggedInUser", logService.getUserById(userId));
                return "redirect:/";
            } else {
                rttr.addFlashAttribute("result", "fail");
                return "redirect:/login/userLogin";
            }
        } else {
            rttr.addFlashAttribute("result", "noSignUser");
            return "redirect:/login/userLogin";
        }
    }


    @PostMapping("/logout")
    public String logOutMtd(String userId, HttpSession session, RedirectAttributes rttr) {

        System.out.println("userId!!!!! : " + userId);
        UserDTO userDTO = (UserDTO)session.getAttribute("userDTO");

//        if(userDto==null) {
//            return "redirect:/" ;
//        }else {
//           if(session.getAttribute("kakaoToken")!=null) {
//                String kakaoToken = (String)session.getAttribute("kakaoToken");
//                kakaoService.kakaoLogout(kakaoToken);
//            }

        session.invalidate();

        return "redirect:/" ;
    }


    @RequestMapping(value="/kakao_oauth", method = RequestMethod.GET)
    public String kakaoOauth(HttpServletResponse response) {
        StringBuffer url = new StringBuffer();
        url.append("https://kauth.kakao.com/oauth/authorize?");
        url.append("client_id=fa1db4eed4a7af6be4d2ffab7b44eb87");
        url.append("&redirect_uri=http://localhost:11100/login/kakao_login");
        url.append("&response_type=code");

        System.out.println("Kakao url " + url);
        return "redirect:" + url;
    }

    @RequestMapping(value="/kakao_login", method = RequestMethod.GET)
    public String kakaoCallback(@RequestParam String code, HttpServletRequest request) {
        // 인가 코드 보내서 토큰 받기
        String access_Token = logService.getAccessToken(code);
        // 토큰 보내서 사용자 정보 받기
        UserDTO userDto = logService.getUserInfo(access_Token);
        HttpSession session = request.getSession();

        session.setAttribute("userDTO", userDto);
        session.setMaxInactiveInterval(-1); // 세션 시간을 무한대로 설정

        String prevPage = (String) request.getSession().getAttribute("prevPage");

        if (prevPage != null && !prevPage.equals("")) {
            request.getSession().removeAttribute("prevPage");
            // 회원가입 - 로그인으로 넘어온 경우 "/"로 redirect
            if (prevPage.contains("/signup/userSignUp")) {
                return  "redirect:/";
            } else {
                return "redirect:" + prevPage;
            }
        } else return  "redirect:/";
    }

@PostMapping("/login/userFindId")
public ResponseEntity<Map<String, Object>> findUserId(@RequestBody Map<String, String> params) {
    String userName = params.get("userName");
    String userPhoneNum = params.get("userPhoneNum");

    String userId = logService.findUserIdByNameAndPhone(userName, userPhoneNum);

    Map<String, Object> response = new HashMap<>();
    if (userId != null) {
        response.put("userId", userId);
        return ResponseEntity.ok(response);
    } else {
        return ResponseEntity.ok(response);  // 일치하는 정보 없음
    }
}

    @PostMapping("/login/userFindPw")
    @ResponseBody
    public Map<String, Object> findPw(@RequestBody Map<String, String> requestData, HttpSession session) {
        String userId = requestData.get("userId");
        String userName = requestData.get("userName");
        String userPhoneNum = requestData.get("userPhoneNum");

        UserDTO userDto = logService.findUserByIdNamePhone(userId, userName, userPhoneNum);

        Map<String, Object> response = new HashMap<>();
        if (userDto != null) {
            session.setAttribute("findPwUser", userDto);
            response.put("success", true);
        } else {
            response.put("success", false);
        }

        return response; // JSON 응답 반환
    }

    @GetMapping("/login/changePassword")
    public String changePasswordPage(HttpSession session, Model model) {
        UserDTO userDto = (UserDTO) session.getAttribute("findPwUser");
        if (userDto == null) {
            return "redirect:/login/userFind"; // 유효하지 않은 접근
        }
        model.addAttribute("user", userDto);
        return "login/changePassword"; // 비밀번호 변경 JSP 페이지로 이동
    }

    @PostMapping("/login/changePassword")
    @ResponseBody
    public Map<String, Object> changePassword(@RequestBody Map<String, String> requestData) {
        String userId = requestData.get("userId");
        String userPwd = requestData.get("userPwd");

        // 비밀번호 암호화
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String encryptedPassword = encoder.encode(userPwd); // 암호화된 비밀번호

        // 로그로 확인
        System.out.println("userId: " + userId);
        System.out.println("암호화된 비밀번호: " + encryptedPassword);

        // 서비스 호출 (DB 업데이트)
        logService.updatePassword(userId, encryptedPassword);

        // 응답
        Map<String, Object> response = new HashMap<>();
        response.put("success", true); // 성공 시 응답
        return response;
    }
}
