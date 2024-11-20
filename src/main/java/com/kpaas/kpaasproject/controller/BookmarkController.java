package com.kpaas.kpaasproject.controller;

import com.kpaas.kpaasproject.dto.CaseDTO;
import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.service.BookmarkService;
import com.kpaas.kpaasproject.service.LogService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
public class BookmarkController {

    @Autowired
    private BookmarkService bookmarkService;
    @Autowired
    private LogService logService;

    @PostMapping("/bookmark/toggle")
    @ResponseBody
    public Map<String, Object> toggleBookmark(int id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        log.info("@@@@@@@@@@@@id:" + id);

        if (loggedInUser == null) {
            response.put("success", false);
            return response;
        }

        int userNo = loggedInUser.getUserNo();
        boolean isBookmarked = bookmarkService.isBookmarked(userNo, id);

        try {
            if (isBookmarked) {
                bookmarkService.removeBookmark(userNo, id);
            } else {
                bookmarkService.addBookmark(userNo, id);
            }
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
        }

        return response;
    }

    @GetMapping("/user/myPage")
    public String viewBookmarks(HttpSession session, Model model) {
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        // 로그인한 사용자의 전체 정보를 가져오기
        UserDTO userInfo = logService.getUserById(loggedInUser.getUserId());

        // 로그인한 사용자 정보 로그 출력
        log.info("Logged-in user: {}", userInfo.getUserNo());

        // 북마크된 케이스 리스트 가져오기
        List<CaseDTO> bookmarkedCases = bookmarkService.getBookmarkedCases(loggedInUser.getUserNo());

        // 북마크된 케이스가 비어있는지 확인 후 로그로 출력
        if (bookmarkedCases.isEmpty()) {
            log.info("No bookmarked cases for user {}", userInfo.getUserNo());
        } else {
            for (CaseDTO legalCase : bookmarkedCases) {
                log.info("Bookmarked case - ID: {}, Title: {}", legalCase.getId(), legalCase.getCaseTitle());
            }
        }

        // 사용자 정보와 북마크 정보를 모델에 추가
        model.addAttribute("user", userInfo);
        model.addAttribute("bookmarkedCases", bookmarkedCases);
        return "user/myPage";
    }
}
