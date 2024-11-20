package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.CaseDTO;
import org.apache.lucene.queryparser.classic.ParseException;

import java.io.IOException;
import java.util.List;

public interface CaseService {
    // 특정 판례 ID로 판례를 가져오는 메서드
    CaseDTO getCaseById(Long id);

    // 판례 요약을 생성하는 메서드 (필요 시 구현)
    String summarizeCase(String caseSummary) throws IOException, ParseException;

    // GPT를 사용해 판례 요약을 기반으로 제목을 생성하는 메서드
    String generateCaseTitle(String caseSummary) throws IOException, ParseException;

    List<CaseDTO> getAllCasesBySituation(String situation, int size, int offset) throws Exception;

    List<CaseDTO> findCasesByKeyword(String keyword, int size, int offset);

}
