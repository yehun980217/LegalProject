package com.kpaas.kpaasproject.dto;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class CaseDTO {
    private Long id;
    private String caseNumber;
    private String caseTitle;
    private String courtName;
    private String courtType;
    private Date judgmentDate;
    private String caseSummary;
    private String judgment;
    private String keywords;
    private String referenceRules;
    private String className;
    private float score;
    private int matchCount;
    // 생성된 제목 필드 추가
    private String generatedTitle;

    private List<String> gptKeywords;
}
