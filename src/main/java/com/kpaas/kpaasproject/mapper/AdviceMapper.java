package com.kpaas.kpaasproject.mapper;

import com.kpaas.kpaasproject.dto.CaseDTO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface AdviceMapper {
    List<CaseDTO> findCasesByKeywords(List<String> keywords);
}
