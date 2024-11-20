package com.kpaas.kpaasproject.controller;

import com.kpaas.kpaasproject.dto.CaseDTO;
import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.service.BookmarkService;
import com.kpaas.kpaasproject.service.CaseService;
import jakarta.servlet.http.HttpSession;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class CaseController {

    @Autowired
    private CaseService caseService;

    @Autowired
    private BookmarkService bookmarkService;

    // 사용자가 상황을 입력할 수 있는 폼을 보여주는 메서드
    @GetMapping("/case/situationForm")
    public String showSituationForm(HttpSession session) {
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            // 로그인이 되어 있지 않으면 로그인 페이지로 리다이렉트
            return "redirect:/login";
        }
        return "case/situationForm";  // JSP 경로: views/case/situationForm.jsp
    }



// 사용자의 텍스트를 기반으로 판례를 검색하는 메서드
@GetMapping("/case/searchCases")
public String searchCases(@RequestParam(value = "situation", required = false, defaultValue = "") String situation,
                          @RequestParam(value = "page", defaultValue = "1") int page,
                          HttpSession session, // 세션 객체 주입
                          Model model) throws Exception {

    int size = 10;  // 한 번에 가져올 데이터 수
    int offset = (page - 1) * size;

    // Service 호출하여 판례 데이터와 GPT 키워드 가져오기
    List<CaseDTO> cases = caseService.getAllCasesBySituation(situation, size, offset);

    // 첫 번째 CaseDTO에서 GPT 키워드를 세션에 저장 (필요한 경우)
    if (!cases.isEmpty()) {
        CaseDTO firstCase = cases.get(0);
        session.setAttribute("gptKeywords", firstCase.getGptKeywords());
    }

    // JSP로 전달할 데이터 추가
    model.addAttribute("cases", cases); // 가져온 판례 데이터
    model.addAttribute("situation", situation); // 사용자가 입력한 상황 정보
    model.addAttribute("page", page); // 현재 페이지 정보

    return "case/caseResults"; // 데이터를 보여줄 JSP 페이지
}



    @GetMapping("/case/searchCasesByKeyword")
    public String searchCasesByKeyword(
            @RequestParam("keyword") String keyword,
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model) {

        int size = 10; // 페이지당 데이터 수
        int offset = (page - 1) * size; // offset 계산

        List<CaseDTO> cases = caseService.findCasesByKeyword(keyword, size, offset);
        model.addAttribute("cases", cases);
        return "case/caseResults"; // JSP 파일 이름으로 반환
    }


    // 판례 상세 정보를 가져오는 메서드
    @SneakyThrows
    @GetMapping("/case/detail")
    public String caseDetail(@RequestParam("id") int id,
                             @RequestParam(value = "situation", required = false) String situation,
                             @RequestParam(value = "page", defaultValue = "1") int page,
                             @RequestParam(value = "size", defaultValue = "10") int size,
                             @RequestParam(value = "from", required = false) String from,
                             Model model, HttpSession session) {

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            // 로그인이 되어 있지 않으면 로그인 페이지로 리다이렉트
            return "redirect:/login";
        }

        // loggedInUser에서 userNo를 가져옴
        int userNo = loggedInUser.getUserNo();

        // 상세정보 가져오기
        CaseDTO caseDTO = caseService.getCaseById((long) id);

        // 원문 및 요약본 추가
        String caseSummary = caseDTO.getCaseSummary();  // 원문
        String summarizedCase = caseService.summarizeCase(caseSummary);  // 요약본 생성

        model.addAttribute("caseDetail", caseDTO);
        model.addAttribute("caseSummary", caseSummary);   // 원문
        model.addAttribute("summarizedCase", summarizedCase); // 요약본

        // 검색 조건도 모델에 추가
        model.addAttribute("situation", situation);
        model.addAttribute("page", page);
        model.addAttribute("size", size);

        boolean isBookmarked = bookmarkService.isBookmarked(userNo, id);
        model.addAttribute("bookmarked", isBookmarked);

        model.addAttribute("from", from);  // JSP로 from 값을 전달 (필요시)

        return "case/caseDetail";  // 상세보기 JSP 경로
    }

}
