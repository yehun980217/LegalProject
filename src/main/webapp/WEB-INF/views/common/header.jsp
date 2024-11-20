<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/css/header.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body>
<header>
    <div class="logo"><a href="/"><img src="../images/logo.png"></a></div>
    <nav>
        <ul>
            <li><a href="/case/situationForm">맞춤 판례 검색</a></li>
            <li><a href="/advice/legalAdvice">법률 상담 챗봇</a></li>
<%--            <li><a href="/legalNews">법안 관련 뉴스</a></li>--%>
            <li><a href="/post/listPost">소통 게시판</a></li>
        </ul>
    </nav>
    <ul class="right-menu">
        <c:if test="${empty sessionScope.loggedInUser}">
            <li><a href="/login/userLogin">로그인</a></li>
            <li><a href="/signup/userSignUp">회원가입</a></li>
        </c:if>
        <c:if test="${not empty sessionScope.loggedInUser}">
                    ${sessionScope.loggedInUser.userName}님 반갑습니다.
            &nbsp;
            <a class="navbar-btn d-none d-sm-inline-block" href="/user/myPage">
                마이페이지
            </a>
            &nbsp;
            <a class="ud-main-btn ud-white-btn"  href="javascript:logOutFunction();" >
                로그아웃
            </a>
            <form id="logOutForm" name="logOutForm" action="/login/logout" method="post">
                <input type="hidden" name="userId" value="${loggedInUser.userId}">
            </form>
        </c:if>
    </ul>
</header>
    <script>
        function logOutFunction(){
            if(confirm("로그아웃하시겠습니까?")){
                $("#logOutForm").submit();
            }
        }
    </script>