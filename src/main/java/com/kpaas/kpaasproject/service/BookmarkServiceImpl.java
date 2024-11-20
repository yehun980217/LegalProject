package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.CaseDTO;
import com.kpaas.kpaasproject.mapper.BookmarkMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookmarkServiceImpl implements BookmarkService {
    @Autowired
    private BookmarkMapper bookmarkMapper;

    public boolean toggleBookmark(int userNo, int id) {
        if (bookmarkMapper.isBookmarked(userNo, id)) {
            bookmarkMapper.removeBookmark(userNo, id);
            return false;
        } else {
            bookmarkMapper.addBookmark(userNo, id);
            return true;
        }
    }

    public boolean isBookmarked(@Param("userNo") int userNo, @Param("id") int id) {
        return bookmarkMapper.isBookmarked(userNo, id);
    }
    public List<CaseDTO> getBookmarkedCases(int userNo) {
        return bookmarkMapper.findBookmarkedCasesByUser(userNo);
    }

    public void addBookmark(int userNo, int id) {
        bookmarkMapper.addBookmark(userNo, id);
    }

    public void removeBookmark(int userNo, int id) {
        bookmarkMapper.removeBookmark(userNo, id);
    }
}
