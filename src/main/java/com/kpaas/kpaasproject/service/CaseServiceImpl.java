package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.CaseDTO;
import com.kpaas.kpaasproject.mapper.CaseMapper;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
public class CaseServiceImpl implements CaseService {

    private static final Logger logger = LoggerFactory.getLogger(CaseServiceImpl.class);

    @Autowired
    private CaseMapper caseMapper;

    private final String API_URL = "https://api.openai.com/v1/chat/completions";
    private final String API_KEY = "sk-x";  // 여기에 자신의 API 키 입력

    @Override
    public List<CaseDTO> getAllCasesBySituation(String situation, int size, int offset) throws Exception {
        logger.info("getAllCasesBySituation 시작 - 입력 상황: {}", situation);

        // GPT를 사용해 상황 분석
        String analyzedKeywords = analyzeSituationWithChatGPT(situation);
        logger.info("ChatGPT 분석 완료: {}", analyzedKeywords);

        // 분석된 키워드를 공백 기준으로 나누고 중복 제거
        List<String> keywords = Arrays.asList(analyzedKeywords.split(" "));
        Set<String> uniqueKeywords = new LinkedHashSet<>(keywords);  // 순서 보장하는 중복 제거

        // DB에서 유사한 판례 검색 (페이징 처리 - 최대 size개의 데이터를 가져오고, offset부터 시작)
        logger.info("DB 기반 판례 검색 시작...");
        List<CaseDTO> relatedCases = caseMapper.findCaseBySummary(new ArrayList<>(uniqueKeywords), size, offset);
        logger.info("DB 기반 판례 검색 완료.");

        // 각 판례에 대해 추가적인 처리를 수행 (제목 생성 및 GPT 키워드 설정)
        for (CaseDTO caseDTO : relatedCases) {
            String caseSummary = caseDTO.getCaseSummary();
            String generatedTitle = generateCaseTitle(caseSummary);  // 판례 제목 생성
            caseDTO.setGeneratedTitle(generatedTitle);  // 생성된 제목을 DTO에 저장
            caseDTO.setGptKeywords(new ArrayList<>(uniqueKeywords));  // 중복 제거된 키워드 설정
        }

        return relatedCases;  // 최대 size개의 판례 반환
    }

    @Override
    public List<CaseDTO> findCasesByKeyword(String keyword, int size, int offset) {
        // 키워드를 기반으로 10개의 판례를 가져오는 메서드
        List<CaseDTO> cases = caseMapper.findCasesByKeyword(keyword, size, offset);

        // 각 판례에 대해 제목 생성 및 설정
        for (CaseDTO caseDTO : cases) {
            String caseSummary = caseDTO.getCaseSummary();
            String generatedTitle = generateCaseTitle(caseSummary);  // 판례 제목 생성
            caseDTO.setGeneratedTitle(generatedTitle);  // 생성된 제목을 DTO에 저장
        }

        return cases;  // 가져온 판례 리스트 반환
    }



    @Override
    public CaseDTO getCaseById(Long id) {
        logger.info("getCaseById 시작 - 케이스 ID: {}", id);
        return caseMapper.getCaseById(id);
    }

    // ChatGPT로 상황을 분석하여 키워드 추출
    private String analyzeSituationWithChatGPT(String situation) throws Exception {
        RestTemplate restTemplate = new RestTemplate();

        // 요청 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(API_KEY); // OpenAI API 키 설정

        // 요청 본문 생성
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-3.5-turbo");
        requestBody.put("messages", new JSONArray()
                .put(new JSONObject()
                        .put("role", "system")
                        .put("content", "당신은 법률 비서입니다. 사용자가 입력한 문장에서 법률과 관련된 중요한 명사나 핵심 키워드만 추출하세요. 예를 들어, '양육', '이혼', '재산 분할' 같은 주요 법률 용어만 골라내세요.")
                )
                .put(new JSONObject()
                        .put("role", "user")
                        .put("content", situation) // 사용자가 입력한 상황
                )
        );
        requestBody.put("max_tokens", 100);
        requestBody.put("temperature", 0.7); // 다양성 제어

        // HTTP 요청 생성
        HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(), headers);

        logger.info("ChatGPT API 호출 중...");
        long startTime = System.currentTimeMillis();
        // API 호출 및 응답 처리
        String response = restTemplate.postForObject(API_URL, entity, String.class);
        long endTime = System.currentTimeMillis();
        logger.info("ChatGPT API 호출 완료 - 실행 시간: {} ms", (endTime - startTime));

        // 응답에서 분석된 텍스트 추출
        JSONObject jsonResponse = new JSONObject(response);
        String analyzedText = jsonResponse.getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content")
                .trim();

        // 쉼표 제거 및 공백으로 나누기
        String cleanedText = analyzedText.replaceAll(",", "").trim();
        List<String> keywords = Arrays.asList(cleanedText.split("\\s+"));

        // 빈 키워드 제거
        keywords.removeIf(String::isEmpty);

        // 키워드 로그
        logger.info("검색 키워드 리스트: {}", keywords);

        return String.join(" ", keywords); // 분석된 키워드 반환
    }


    @Override
    public String summarizeCase(String caseSummary) {
        RestTemplate restTemplate = new RestTemplate();

        // 요청 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(API_KEY); // OpenAI API 키 설정

        // 요청 본문 생성
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-3.5-turbo");
        requestBody.put("messages", new JSONArray()
                .put(new JSONObject()
                        .put("role", "system")
                        .put("content", "주어진 법률 텍스트를 간결하게 요약하세요.")
                )
                .put(new JSONObject()
                        .put("role", "user")
                        .put("content", caseSummary) // 요약할 판례 내용
                )
        );
        requestBody.put("max_tokens", 200);
        requestBody.put("temperature", 0.5);

        // HTTP 요청 생성
        HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(), headers);

        // API 호출 및 응답 처리
        String response = restTemplate.postForObject(API_URL, entity, String.class);

        // 응답에서 요약된 텍스트 추출
        JSONObject jsonResponse = new JSONObject(response);
        String summarizedText = jsonResponse.getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content")
                .trim();

        return summarizedText; // 요약된 텍스트 반환
    }

    @Override
    public String generateCaseTitle(String caseSummary) {
        RestTemplate restTemplate = new RestTemplate();

        // 요청 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(API_KEY); // OpenAI API 키 설정

        // 요청 본문 생성
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-3.5-turbo");
        requestBody.put("messages", new JSONArray()
                .put(new JSONObject()
                        .put("role", "system")
                        .put("content", "당신은 법률 전문가입니다. 주어진 판례 요약을 바탕으로 적절한 판례 제목을 작성하세요.")
                )
                .put(new JSONObject()
                        .put("role", "user")
                        .put("content", caseSummary) // 판례 내용을 보내서 적절한 제목 생성 요청
                )
        );
        requestBody.put("max_tokens", 100);
        requestBody.put("temperature", 0.7); // 다양성 제어

        // HTTP 요청 생성
        HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(), headers);

        // API 호출 및 응답 처리
        String response = restTemplate.postForObject(API_URL, entity, String.class);

        // 응답에서 생성된 제목 추출
        JSONObject jsonResponse = new JSONObject(response);
        String generatedTitle = jsonResponse.getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content")
                .trim();

        return generatedTitle; // 생성된 제목 반환
    }



}
