package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.CaseDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BookmarkService {
    boolean toggleBookmark(int userNo, int id);
    List<CaseDTO> getBookmarkedCases(int userNo);

    boolean isBookmarked(@Param("userNo") int userNo, @Param("id") int id);

    void addBookmark(int userNo, int id);

    void removeBookmark(int userNo, int id);
}
