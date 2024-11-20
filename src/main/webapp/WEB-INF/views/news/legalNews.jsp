<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="../css/news.css">

<jsp:include page="../common/header.jsp" />
<div class="news-container">
    <h1>법안 관련 최신 뉴스</h1>

    <c:if test="${not empty newsItems}">
        <table class="news-table">
            <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>등록일자</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="news" items="${newsItems}" varStatus="status">
                <tr>
                    <td>${status.count}</td> <!-- 순번 표시 -->
                    <td><a href="${news.link}" target="_blank" class="news-title">${news.title}</a></td>
                    <td>${news.pubDate}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty newsItems}">
        <p>법률 관련 뉴스를 불러올 수 없습니다.</p>
    </c:if>
</div>
<a href="/legalNews">새로고침</a>
<jsp:include page="../common/footer.jsp" />
