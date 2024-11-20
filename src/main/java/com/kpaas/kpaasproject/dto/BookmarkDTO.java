package com.kpaas.kpaasproject.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class BookmarkDTO {
    private int bookmarkId;  // 북마크 고유 ID
    private int userNo;      // 사용자 번호
    private int id;      // 판례 번호
    private String caseTitle; // 북마크한 판례의 제목 (필요한 경우)
    private String courtName; // 법원명 (필요한 경우)
    private Date bookmarkedDate; // 북마크된 날짜
}
