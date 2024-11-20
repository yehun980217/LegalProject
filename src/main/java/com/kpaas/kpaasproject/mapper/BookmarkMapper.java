package com.kpaas.kpaasproject.mapper;

import com.kpaas.kpaasproject.dto.CaseDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BookmarkMapper {
    boolean isBookmarked(@Param("userNo") int userNo, @Param("id") int id);

    void addBookmark(@Param("userNo") int userNo, @Param("id") int id);

    void removeBookmark(@Param("userNo") int userNo, @Param("id") int id);

    List<CaseDTO> findBookmarkedCasesByUser(@Param("userNo") int userNo);


}
