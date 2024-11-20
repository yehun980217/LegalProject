<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="../css/post.css">
<link rel="stylesheet" href="../css/page.css">

<div class="category-links">
    <a href="/post/listPost">전체</a>
    <a href="/post/listPostByCategory?category=정보" class="${param.category == '정보' ? 'active' : ''}">정보</a>
    <a href="/post/listPostByCategory?category=질문" class="${param.category == '질문' ? 'active' : ''}">질문</a>
    <a href="/post/listPostByCategory?category=자유" class="${param.category == '자유' ? 'active' : ''}">자유</a>
</div>

<table class="post-table">
    <tr>
        <th class="post-th post-th-small">번호</th>
        <th class="post-th post-th-title">제목</th>
        <th class="post-th post-th-small">작성자</th>
        <th class="post-th post-th-small">작성일</th>
    </tr>
    <c:forEach var="post" items="${posts}" varStatus="status">
        <tr class="post-tr">
            <td class="post-td">${status.count}</td> <!-- 번호 -->
            <td class="post-td post-td-title">
                <span class="category-label ${post.category}">
                        ${post.category}
                </span>
                <a href="/post/detailPost?postNo=${post.postNo}" class="post-link" data-title="${post.title}">${post.title}</a> <!-- 제목 -->
            </td>
            <td class="post-td">${post.userId}</td> <!-- 작성자 -->
            <td class="post-td">
                <fmt:formatDate value="${post.createdDate}" pattern="yyyy-MM-dd" />
            </td> <!-- 작성일 -->
        </tr>
    </c:forEach>
</table>

<c:if test="${!empty sessionScope.loggedInUser}">
    <div class="write-post-btn-container">
        <a href="/post/writePost" class="write-post-btn">글 작성하기</a>
    </div>
</c:if>

<div class="pagination">
    <c:if test="${!pageDto.firstPage}">
        <a href="?category=${category}&page=${pageDto.currentPage - 1}">이전</a>
    </c:if>
    <c:forEach begin="1" end="${pageDto.totalPages}" var="i">
        <a href="?category=${category}&page=${i}" class="${i == pageDto.currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>
    <c:if test="${!pageDto.lastPage}">
        <a href="?category=${category}&page=${pageDto.currentPage + 1}">다음</a>
    </c:if>
</div>

<jsp:include page="../common/footer.jsp" />

<script>

    // 제목 글자가 30자가 넘으면 말줄임표로 줄이는 함수
    document.addEventListener("DOMContentLoaded", function () {
        const titleLinks = document.querySelectorAll(".post-link");

        titleLinks.forEach(function (link) {
            const title = link.getAttribute("data-title");
            if (title.length > 30) {
                const truncated = title.substring(0, 30) + "...";
                link.textContent = truncated;
            }
        });
    });
</script>
