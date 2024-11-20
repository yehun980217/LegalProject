<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="../css/case.css">
<link rel="stylesheet" href="../css/myPage.css">

<div class="my-page-container">
    <!-- 좌측: 사용자 정보 및 버튼들 -->
    <div class="user-info-menu">
        <h3>회원 정보</h3>
        <ul class="user-info-list">
            <li><strong>아이디:</strong> ${user.userId}</li>
            <li><strong>이름:</strong> ${user.userName}</li>
            <li><strong>가입일:</strong> <fmt:formatDate value="${user.userRegDate}" pattern="yyyy-MM-dd" /></li>
        </ul>
        <div class="button-section">
            <a href="/user/myPosts" class="btn">작성 글 관리</a>
            <a href="/user/myComments" class="btn">작성 댓글 관리</a>
            <a href="/signup/userSignOut" class="btn">회원탈퇴</a>
        </div>
    </div>

    <!-- 중앙: 북마크한 판례 리스트 슬라이더 -->
    <div class="bookmark-list-section">
        <h3>내 북마크</h3>
        <c:if test="${not empty bookmarkedCases}">
            <!-- 슬라이드 컨테이너 -->
            <div class="slider-container">
                <!-- 슬라이드 항목들 -->
                <div class="slider-wrapper">
                    <c:forEach var="legalCase" items="${bookmarkedCases}">
                        <div class="slider-item">
                            <span class="case-type ${legalCase.className}">${legalCase.className}</span>
                            <h2>
                                <a href="/case/detail?id=${legalCase.id}&from=mypage">
                                    대법원 <fmt:formatDate value="${legalCase.judgmentDate}" pattern="yyyy년 MM월 dd일" /> 선고 ${fn:escapeXml(legalCase.caseTitle)}
                                </a>
                            </h2>
                            <p class="case-summary">
                                    ${fn:substring(legalCase.caseSummary, 0, 100) != null ? fn:substring(legalCase.caseSummary, 0, 100) : '...'}
                            </p>
                        </div>
                    </c:forEach>
                </div>

                <!-- 슬라이드 네비게이션 버튼들 -->
                <div class="slide-navigation">
                    <button class="prev-slide" onclick="changeSlide(-1)">&#10094; 이전</button>
                    <button class="next-slide" onclick="changeSlide(1)">다음 &#10095;</button>
                </div>
            </div>
        </c:if>
        <c:if test="${empty bookmarkedCases}">
            <p class="no-results">북마크한 판례가 없습니다.</p>
        </c:if>
    </div>

</div>

<jsp:include page="../common/footer.jsp" />

<!-- 슬라이드 기능 자바스크립트 -->
<script>
    let slideIndex = 0;
    showSlides(slideIndex);

    function changeSlide(n) {
        showSlides(slideIndex += n);
    }

    function showSlides(n) {
        const slides = document.getElementsByClassName("slider-item");
        if (n >= slides.length) {
            slideIndex = 0;
        }
        if (n < 0) {
            slideIndex = slides.length - 1;
        }
        for (let i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
        }
        slides[slideIndex].style.display = "block";
    }
</script>
