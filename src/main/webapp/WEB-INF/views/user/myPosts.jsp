<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="../css/userPostComm.css">
<div class="user-content-section">
    <!-- 작성 글 목록 -->
    <div class="my-posts">
        <h3>내가 작성한 글</h3>
        <c:if test="${not empty myPosts}">
            <ul class="post-list">
                <c:forEach var="post" items="${myPosts}">
                    <li>
                        <a href="/post/detailPost?postNo=${post.postNo}">${post.title}</a>
                        <span class="post-date">
                            <fmt:formatDate value="${post.createdDate}" pattern="yyyy-MM-dd" />
                        </span>
                    </li>
                </c:forEach>
            </ul>
        </c:if>
        <c:if test="${empty myPosts}">
            <p>작성한 글이 없습니다.</p>
        </c:if>
    </div>
</div>
<div class="pagination">
    <c:if test="${pageDto.currentPage > 1}">
        <a href="?page=${pageDto.currentPage - 1}">이전</a>
    </c:if>

    <c:forEach var="i" begin="${pageDto.startPage}" end="${pageDto.endPage}">
        <a href="?page=${i}" class="${i == pageDto.currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>

    <c:if test="${pageDto.currentPage < pageDto.totalPages}">
        <a href="?page=${pageDto.currentPage + 1}">다음</a>
    </c:if>
</div>

<jsp:include page="../common/footer.jsp" />

