package com.kpaas.kpaasproject.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PageDTO {
    private int currentPage;  // 현재 페이지 번호
    private int totalPages;    // 전체 페이지 수
    private int startPage;     // 현재 페이지 그룹의 시작 페이지 번호
    private int endPage;       // 현재 페이지 그룹의 끝 페이지 번호
    private boolean firstPage; // 첫 페이지 여부
    private boolean lastPage;  // 마지막 페이지 여부

    // 생성자 추가
    public PageDTO(int currentPage, int totalItems, int pageSize) {
        this.currentPage = currentPage;
        this.totalPages = (int) Math.ceil((double) totalItems / pageSize);

        int pageGroupSize = 5;  // 페이지 그룹의 크기 설정 예시 (한번에 5개 페이지씩 표시)
        this.startPage = ((currentPage - 1) / pageGroupSize) * pageGroupSize + 1;
        this.endPage = Math.min(startPage + pageGroupSize - 1, totalPages);

        this.firstPage = (currentPage == 1);
        this.lastPage = (currentPage == totalPages);
    }

    // 기존 접근 방식과 호환성을 위해 "isFirstPage" 메서드 추가
    public boolean isFirstPage() {
        return firstPage;
    }

    public boolean isLastPage() {
        return lastPage;
    }
}
