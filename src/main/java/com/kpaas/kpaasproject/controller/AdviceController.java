package com.kpaas.kpaasproject.controller;

import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.service.AdviceService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class AdviceController {

    @Autowired
    private AdviceService adviceService;

    @GetMapping("/advice/legalAdvice")
    public String legalAdvice(HttpSession session) {
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            // 로그인이 되어 있지 않으면 로그인 페이지로 리다이렉트
            return "redirect:/login";
        }
        return "advice/legalAdvice";
    }

    // POST 요청으로 GPT-3.5의 답변 또는 판례를 가져옴
    @PostMapping("/advice/getLegalAdvice")
    @ResponseBody
    public Map<String, String> getLegalAdvice(@RequestBody Map<String, String> request) throws Exception {
        String userMessage = request.get("userMessage"); // 사용자의 입력된 메시지
        if (userMessage == null || userMessage.trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid input data.");
        }

        // 서비스로부터 법적 조언을 가져옴
        String advice = adviceService.getLegalAdvice(userMessage);

        Map<String, String> response = new HashMap<>();
        response.put("response", advice); // 사용자에게 응답 반환

        return response;
    }
}
