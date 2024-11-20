<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="/css/loding.css">
<link rel="stylesheet" href="/css/case.css">

<div id="loading-screen" style="display: none;">
    <div class="spinner"></div>
    <p>검색 중...</p>
</div>

<div class="results-container">
    <div class="situation-banner">
        <h3>AI 추출 키워드 목록</h3>
        <hr>
    </div>

    <!-- 세션에 저장된 GPT 키워드 출력 -->
    <c:if test="${not empty sessionScope.gptKeywords}">
        <div class="keywords-section">
            <c:forEach var="keyword" items="${sessionScope.gptKeywords}">
                <a class="keyword" href="javascript:void(0);" onclick="searchByKeyword('${keyword}');">${keyword}</a>
            </c:forEach>
        </div>
    </c:if>
</div>


    <div class="situation-banner">
        <h3>판례 조회 결과</h3>
        <hr>
    </div>

    <!-- 판례 목록 출력 -->
    <c:if test="${not empty cases}">
        <div id="case-list">
            <c:forEach var="legalCase" items="${cases}">
                <div class="case-item">
                    <span class="case-type ${legalCase.className}">${legalCase.className}</span>
                    <h3 class="generated-case-title">${legalCase.generatedTitle != null ? legalCase.generatedTitle : '제목 없음'}</h3>
                    <h2>
                        <a href="/case/detail?id=${legalCase.id}">
                            대법원 <fmt:formatDate value="${legalCase.judgmentDate}" pattern="yyyy년 MM월 dd일" /> 선고 ${legalCase.caseTitle}
                        </a>
                    </h2>
                    <p class="case-summary">${fn:substring(legalCase.caseSummary, 0, 100)}...</p>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${empty cases}">
        <p class="no-results">검색 결과가 없습니다.</p>
    </c:if>
</div>


<script>
    function searchByKeyword(keyword) {
        // 로딩 화면을 먼저 표시
        showLoading();

        // 500ms의 지연을 준 후 페이지를 새로 고침하며 키워드를 쿼리 파라미터로 추가
        setTimeout(function() {
            window.location.href = "/case/searchCasesByKeyword?keyword=" + encodeURIComponent(keyword) + "&page=1";
        }, 500); // 0.5초 동안 로딩 화면을 잠시 보여줌
    }

    function showLoading() {
        document.getElementById('loading-screen').style.display = 'flex'; // 로딩 화면을 보이게 설정
    }

    function hideLoading() {
        document.getElementById('loading-screen').style.display = 'none'; // 로딩 화면을 숨기기
    }
</script>

<jsp:include page="../common/footer.jsp" />
