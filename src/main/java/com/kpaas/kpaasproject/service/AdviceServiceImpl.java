package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.CaseDTO;
import com.kpaas.kpaasproject.mapper.AdviceMapper;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@Service
public class AdviceServiceImpl implements AdviceService {

    @Autowired
    private AdviceMapper adviceMapper;

    private static final String API_URL = "https://api.openai.com/v1/chat/completions";
    private static final String API_KEY = "sk-xxx"; // OpenAI API 키

    @Override
    public String getLegalAdvice(String situation) throws Exception {
        // 키워드를 기반으로 판례 검색
        List<String> keywords = extractKeywords(situation);
        List<CaseDTO> caseList = adviceMapper.findCasesByKeywords(keywords);

        if (caseList != null && !caseList.isEmpty()) {
            // 판례가 있으면 해당 판례를 GPT로 전달하여 답변 생성
            String caseContent = formatCaseResults(caseList);
            return getGptResponse(situation, caseContent);
        } else {
            // 판례가 없으면 GPT-3.5를 통해 일반적인 답변 제공
            return getGptResponse(situation, null);
        }
    }

    // 키워드 추출 로직 (간단한 예시)
    private List<String> extractKeywords(String situation) {
        // 간단한 키워드 추출 로직을 구현 (NLP 또는 GPT 사용 가능)
        return List.of("소송", "재산", "이혼"); // 예시 키워드
    }

    // 판례 결과 포맷팅
    private String formatCaseResults(List<CaseDTO> caseList) {
        StringBuilder result = new StringBuilder();
        for (CaseDTO caseDTO : caseList) {
            result.append("판례 제목: ").append(caseDTO.getCaseTitle())
                    .append("\n법원명: ").append(caseDTO.getCourtName())
                    .append("\n판결 날짜: ").append(caseDTO.getJudgmentDate())
                    .append("\n판례 요약: ").append(caseDTO.getCaseSummary())
                    .append("\n\n");
        }
        return result.toString();
    }

    // GPT-3.5 API 호출
    private String getGptResponse(String situation, String caseContent) throws Exception {
        RestTemplate restTemplate = new RestTemplate();

        // 요청 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(API_KEY);

        // GPT에게 전달할 메시지 생성
        JSONArray messages = new JSONArray()
                .put(new JSONObject().put("role", "system").put("content", "당신은 법률 비서입니다. 사용자의 질문에 법적 조언을 제공하세요."));

        if (caseContent != null && !caseContent.isEmpty()) {
            // 판례를 포함하여 GPT가 답변 생성하도록 요청
            messages.put(new JSONObject().put("role", "assistant")
                    .put("content", "다음은 사용자의 질문에 맞는 판례입니다: " + caseContent));
        }

        // 사용자의 질문 추가
        messages.put(new JSONObject().put("role", "user").put("content", situation));

        // 요청 본문 생성
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-3.5-turbo");
        requestBody.put("messages", messages);
        requestBody.put("max_tokens", 1000);
        requestBody.put("temperature", 0.7);

        // HTTP 요청 생성
        HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(), headers);

        // API 호출 및 응답 처리
        String response = restTemplate.postForObject(API_URL, entity, String.class);
        JSONObject jsonResponse = new JSONObject(response);
        return jsonResponse.getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content");
    }
}
