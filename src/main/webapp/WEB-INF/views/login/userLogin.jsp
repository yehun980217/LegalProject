<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/css/login.css">
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<jsp:include page="../common/header.jsp" />
<title>로그인</title>
<!-- ====== Login Start ====== -->
<div class="login-parent">
    <div class="login-container">
        <div class="logoBox"><img src="../images/logo.png"></div>
        <form class="ud-login-form" method="post" action="/login/userLogin">
            <input type="hidden" id="result" value="${result}">
            <label for="userId">아이디</label>
            <input type="text" name="userId" id="userId" placeholder="아이디"/>

            <label for="userPwd">비밀번호</label>
            <input type="password" name="userPwd" id="userPwd" placeholder="비밀번호" />

            <button type="button" class="login-btn" id="loginButton">로그인 하기</button>
        </form>

        <!-- 커스텀 알림창 -->
        <div id="customAlert" class="custom-alert hidden">
            <p id="alertMessage"></p>
            <button id="closeAlertBtn">닫기</button>
        </div>

<%--        <a href="/login/kakao_oauth"><img src="../images/kakao_login_medium_wide.png" alt="카카오톡 로그인"></a>--%>
<%--        <div id="naver_id_login" ></div>--%>
        <div class="divider"></div>
        <a href="/signup/userSignUp">회원이 아니신가요? 회원가입하러 가기</a>
        <a href="/login/userFind">아이디 또는 비밀번호 찾기</a>
    </div>
</div>

<!-- JavaScript for custom alert -->
<script>
    // 로그인 버튼 클릭 시 유효성 검사
    document.getElementById("loginButton").addEventListener("click", function () {
        const userId = document.getElementById("userId").value;
        const userPwd = document.getElementById("userPwd").value;

        if (!userId || !userPwd) {
            showCustomAlert("아이디 또는 비밀번호를 입력해주세요.");
        } else {
            document.querySelector(".ud-login-form").submit();
        }
    });

    // 서버에서 전달된 result 값 확인
    const result = document.getElementById("result").value;
    if (result === "fail") {
        showCustomAlert("비밀번호가 잘못되었습니다. 다시 입력해주세요.");
    } else if (result === "noSignUser") {
        showCustomAlert("회원가입이 되어 있지 않거나 탈퇴한 사용자입니다.");
    }

    // 커스텀 알림창 표시
    function showCustomAlert(message) {
        const alertBox = document.getElementById("customAlert");
        document.getElementById("alertMessage").innerText = message;
        alertBox.classList.remove("hidden");
    }

    // 알림창 닫기
    document.getElementById("closeAlertBtn").addEventListener("click", function () {
        const alertBox = document.getElementById("customAlert");
        alertBox.classList.add("hidden");
    });






        // var naver_id_login = new naver_id_login("J4wziIcpqpqstZNyKsEF", "http://localhost:11100/login/userLogin");
        // var state = naver_id_login.getUniqState();
        // naver_id_login.setButton("green", 3, 50);
        // naver_id_login.setDomain("http://localhost:11100/login/callback");
        // naver_id_login.setState(state);
        // naver_id_login.setPopup();
        // naver_id_login.init_naver_id_login();
</script>

<jsp:include page="../common/footer.jsp"/>
