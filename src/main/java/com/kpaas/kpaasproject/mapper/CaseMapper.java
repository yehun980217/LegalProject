package com.kpaas.kpaasproject.mapper;

import com.kpaas.kpaasproject.dto.CaseDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CaseMapper {

    // case_summary로 판례를 검색하는 메서드
    List<CaseDTO> findCaseBySummary(@Param("keywords") List<String> keywords, int size, int offset);

    // 판례 ID로 특정 판례를 가져오는 메서드
    CaseDTO getCaseById(@Param("id") Long id);

    // 키워드를 사용하여 판례를 검색하는 메서드
    List<CaseDTO> findCasesByKeyword(String keyword, int size, int offset);
}
