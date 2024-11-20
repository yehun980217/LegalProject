<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="/css/case.css">

<jsp:include page="../common/header.jsp" />
<div class="situation-banner">
    <h3>상세보기</h3>
    <hr>
</div>
<div class="case-detail-container">
    <div class="case-detail">
        <h2 class="case-item-title">${caseDetail.caseTitle}</h2>
        <p><strong>법원:</strong> ${caseDetail.courtName}</p>
        <p><strong>선고 날짜:</strong> <fmt:formatDate value="${caseDetail.judgmentDate}" pattern="yyyy-MM-dd" /></p>

        <!-- 북마크 기능 -->
        <div>
            <span id="bookmark-icon" class="${bookmarked ? 'bookmarked' : 'unbookmarked'}"
                  onclick="toggleBookmark(${caseDetail.id})">
                ★
            </span>
        </div>

        <!-- 버튼으로 원문과 요약본 전환 -->
        <div>
            <button class="view-toggle-button" onclick="showOriginal()">원문보기</button>
            <button class="view-toggle-button" onclick="showSummary()">요약보기</button>
        </div>

        <!-- 판례 내용 (원문과 요약본) -->
        <div id="case-summary">
            <p><strong>내용 (원문):</strong></p>
            <p id="original-text" class="case-summary-text" style="display: block;">${caseSummary}</p>
            <p id="summary-text" class="case-summary-text" style="display: none;">${summarizedCase}</p>
        </div>
    </div>

    <!-- 검색 조건을 URL에 포함하여 '검색으로 돌아가기' -->
    <c:if test="${param.from != 'mypage'}">
    <a class="back-button" href="/case/searchCases?situation=${situation}&page=${page}&size=${size}">검색으로 돌아가기</a>
    </c:if>
</div>

<jsp:include page="../common/footer.jsp" />
<script>
    // caseDetail.id 값을 JSP에서 JavaScript로 전달
    const id = ${caseDetail.id};

    function showOriginal() {
        document.getElementById('original-text').style.display = 'block';
        document.getElementById('summary-text').style.display = 'none';
    }

    function showSummary() {
        document.getElementById('original-text').style.display = 'none';
        document.getElementById('summary-text').style.display = 'block';
    }

    function toggleBookmark() {
        const icon = document.getElementById('bookmark-icon');
        const bookmarked = icon.classList.contains('bookmarked');
        console.log("Bookmark toggle for case id:", id);
        // 북마크 토글 요청 보내기
        // URL이 올바르게 구성되었는지 로그로 확인
        const url = `/bookmark/toggle?id=` + id;
        console.log("Request URL:", url);

        fetch(`/bookmark/toggle?id=`+ id, { method: 'POST' })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    if (bookmarked) {
                        icon.classList.remove('bookmarked');
                        icon.classList.add('unbookmarked');
                    } else {
                        icon.classList.remove('unbookmarked');
                        icon.classList.add('bookmarked');
                    }
                } else {
                    alert('북마크 처리에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 오류로 인해 북마크 처리에 실패했습니다.');
            });
    }
</script>
