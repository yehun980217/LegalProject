<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="../css/post.css">

<div class="post-detail-container">
    <span class="category-label ${post.category}">
        ${post.category}
    </span>
    <h2 class="post-title">게시글 수정</h2>

    <div class="post-info">
        <span class="post-author">작성자: ${post.userId}</span>
        <span class="post-date">작성일: <fmt:formatDate value="${post.createdDate}" pattern="yyyy-MM-dd" /></span>
    </div>

    <!-- 게시글 수정 폼 -->
    <form action="/post/updatePost" method="post" class="post-form">
        <input type="hidden" name="postNo" value="${post.postNo}" />

        <label for="category" class="form-label">카테고리</label>
        <select name="category" id="category" class="form-select">
            <option value="자유" ${post.category == '자유' ? 'selected' : ''}>자유</option>
            <option value="질문" ${post.category == '질문' ? 'selected' : ''}>질문</option>
            <option value="정보" ${post.category == '정보' ? 'selected' : ''}>정보</option>
        </select>

        <label for="title" class="form-label">제목</label>
        <input type="text" name="title" id="title" class="form-input" value="${post.title}" required>

        <label for="content" class="form-label">내용</label>
        <textarea name="content" id="content" rows="10" class="form-textarea" required>${post.content}</textarea>

        <button type="submit" class="form-submit-btn">수정 완료</button>
    </form>
</div>

<jsp:include page="../common/footer.jsp" />
