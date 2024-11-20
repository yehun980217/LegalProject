<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="../css/post.css">
<c:if test="${empty sessionScope.loggedInUser}">
    <script>
        alert("로그인한 사용자만 글을 작성할 수 있습니다.");
        window.location.href = "/login"; // 로그인 페이지로 리다이렉트
    </script>
</c:if>

<h2 class="form-title">글 작성하기</h2>

<form action="/post/createPost" method="post" enctype="multipart/form-data" class="post-form">
    <label for="category" class="form-label">카테고리:</label>
    <select name="category" id="category" class="form-select">
        <option value="자유" selected>자유</option>
        <option value="질문">질문</option>
        <option value="정보">정보</option>
    </select>
    <br><br>

    <label for="title" class="form-label">제목:</label>
    <input type="text" id="title" name="title" class="form-input" required>
    <br><br>

    <label for="content" class="form-label">내용:</label>
    <textarea id="content" name="content" rows="10" class="form-textarea" required></textarea>
    <br><br>

    <button type="submit" class="form-submit-btn">글 작성</button>
</form>

<jsp:include page="../common/footer.jsp" />
