package com.kpaas.kpaasproject.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.client.RestTemplate;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@Controller
public class NewsController {

    private final String CLIENT_ID = "J4wziIcpqpqstZNyKsEF";
    private final String CLIENT_SECRET = "1aB2n0iE2L";
    private final String API_URL = "https://openapi.naver.com/v1/search/news.json";

    @GetMapping("/legalNews")
    public String getLegalNews(Model model) throws JsonProcessingException {
        String query = "법안";
        int display = 10;
        int start = 1;
        String sort = "date";

        String requestUrl = API_URL + "?query=" + query + "&display=" + display + "&start=" + start + "&sort=" + sort;

        log.info("Request URL: {}", requestUrl);

        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", CLIENT_ID);
        headers.set("X-Naver-Client-Secret", CLIENT_SECRET);

        HttpEntity<String> entity = new HttpEntity<>(headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response;

        try {
            response = restTemplate.exchange(requestUrl, HttpMethod.GET, entity, String.class);
            log.info("Response status code: {}", response.getStatusCode());
            log.debug("Response body: {}", response.getBody());
        } catch (Exception e) {
            log.error("Error during API request: ", e);
            return "error";
        }

        // JSON 데이터를 파싱하여 모델에 추가
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode root;
        List<Map<String, String>> newsList = new ArrayList<>();
        SimpleDateFormat inputFormat = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss Z", Locale.ENGLISH); // 입력 포맷
        SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm"); // 원하는 출력 포맷

        try {
            root = objectMapper.readTree(response.getBody());
            JsonNode newsItems = root.get("items");
            log.info("Parsed items: {}", newsItems);

            for (JsonNode item : newsItems) {
                Map<String, String> newsMap = new HashMap<>();
                newsMap.put("title", item.get("title").asText());
                newsMap.put("link", item.get("link").asText());
                newsMap.put("description", item.get("description").asText());

                // 날짜 포맷 변환
                String pubDate = item.get("pubDate").asText();
                Date date = inputFormat.parse(pubDate); // 입력된 날짜 포맷으로 파싱
                String formattedDate = outputFormat.format(date); // 출력 포맷으로 변환
                newsMap.put("pubDate", formattedDate); // 변환된 날짜 추가

                newsList.add(newsMap);
            }

            model.addAttribute("newsItems", newsList);
            log.info("Parsed news items: {}", newsList);

        } catch (JsonProcessingException e) {
            log.error("Error parsing JSON response: ", e);
            throw e;
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }

        return "news/legalNews";
    }
}
