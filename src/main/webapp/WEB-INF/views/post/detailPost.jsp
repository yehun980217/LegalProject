<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="../css/post.css">

<div class="post-detail-container">
    <span class="category-label ${post.category}">
        ${post.category}
    </span>
    <h2 class="post-title">${post.title}</h2>

    <div class="post-info">
        <span class="post-author">작성자: ${post.userId}</span>
        <span class="post-date">작성일: <fmt:formatDate value="${post.createdDate}" pattern="yyyy-MM-dd" /></span>
    </div>

    <!-- 본인의 게시글이거나 관리자인 경우 수정/삭제 버튼 표시 -->
    <c:if test="${isOwner || sessionScope.loggedInUser.userGrade == 'admin'}">
        <div class="post-actions">
            <!-- 관리자는 수정 버튼이 보이지 않도록 수정 -->
            <c:if test="${isOwner}">
                <a href="/post/editPost?postNo=${post.postNo}" class="btn-edit">수정</a>
            </c:if>
            <form action="/post/deletePost" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');" class="form-delete">
                <input type="hidden" name="postNo" value="${post.postNo}" />
                <button type="submit" class="form-delete-btn">삭제</button>
            </form>
        </div>
    </c:if>

    <div class="post-content">
        ${post.content}
    </div>

    <!-- 댓글 섹션 -->
    <div class="post-comments">
        <h3>댓글</h3>
        <c:forEach var="comment" items="${post.comments}">
            <div class="comment">
                <p style="font-weight: bold;">${comment.userId}</p>
                <p>${comment.content}</p>
                <p class="comment-date">작성일: <fmt:formatDate value="${comment.createdDate}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
                <!-- 본인 또는 관리자인 경우에만 삭제 버튼 표시 -->
                <c:if test="${sessionScope.loggedInUser.userNo == comment.userNo || sessionScope.loggedInUser.userGrade == 'admin'}">
                    <form action="/post/deleteComment" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                        <input type="hidden" name="commentNo" value="${comment.commentNo}" />
                        <input type="hidden" name="postNo" value="${post.postNo}" />
                        <button type="submit" class="btn-delete">삭제</button>
                    </form>
                </c:if>
            </div>
        </c:forEach>

    </div>

    <!-- 댓글 작성 -->
    <c:if test="${!empty sessionScope.loggedInUser}">
        <form action="/post/addComment" method="post" class="comment-form">
            <textarea name="content" rows="3" required></textarea>
            <input type="hidden" name="postNo" value="${post.postNo}" />
            <button type="submit" class="btn-submit">댓글 작성</button>
        </form>
    </c:if>
</div>

<jsp:include page="../common/footer.jsp" />
