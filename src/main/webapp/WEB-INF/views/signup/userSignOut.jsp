<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="/css/signout.css">
<jsp:include page="../common/header.jsp" />
<title>회원 탈퇴</title>
<h1>회원 탈퇴</h1>
<h3>회원 탈퇴 시 서비스 이용이 불가능합니다.</h3>
<p>회원 정보는 삭제됩니다.</p>
<form method="post" action="/signup/userSignOut" id="userSignOut">
    <input type="hidden" id="userId" name="userId" value="${loggedInUser.userId}">

    <label for="userPhoneNum">핸드폰 번호</label>
    <input type="text" id="userPhoneNum" name="userPhoneNum" placeholder="핸드폰 번호">
    <button type="button" id="sendVerificationCode">인증번호 전송</button>

    <div id="verificationFields" style="display: none;">
        <div class="form-group">
            <label for="verificationCode">인증번호</label>
            <div class="input-group">
                <input type="text" id="verificationCode" name="verificationCode" class="input-field" placeholder="인증번호 입력">
                <button type="button" id="verifyCodeBtn" class="send-btn">인증하기</button>
            </div>
        </div>
        <div id="verificationResult" class="error-message"></div>
    </div>

    <!-- 회원 탈퇴 버튼 -->
    <div id="signOutSection" style="display: none;">
        <button type="button" id="userSignOutBtn">회원 탈퇴</button>
    </div>
</form>

<!-- 커스텀 알림창 -->
<div id="customAlert" class="custom-alert hidden">
    <p id="alertMessage"></p>
    <button id="closeAlertBtn">닫기</button>
</div>

<script>
    // 커스텀 알림창 표시 함수
    function showCustomAlert(message) {
        $("#alertMessage").text(message);
        $("#customAlert").removeClass("hidden");
    }

    // 알림창 닫기 이벤트
    $("#closeAlertBtn").click(function () {
        $("#customAlert").addClass("hidden");
    });

    var userPhoneChecked = false;


    // 인증번호 전송
    $("#sendVerificationCode").click(function () {
        var userPhoneNum = $("#userPhoneNum").val();
        if (!userPhoneNum) {
            showCustomAlert("핸드폰 번호를 입력해주세요.");
            return;
        }

        $.ajax({
            type: "POST",
            url: "/signUp/sendSMS",
            contentType: "application/json",
            data: JSON.stringify({ "userPhoneNum": userPhoneNum }),
            success: function () {
                showCustomAlert("인증번호가 발송되었습니다.");
                $("#verificationFields").show();  // 인증번호 입력 칸 보이기
            },
            error: function () {
                showCustomAlert("인증번호 발송 실패. 다시 시도해주세요.");
                $("#verificationFields").show();
            }
        });
    });

    // 인증번호 확인
    $("#verifyCodeBtn").click(function () {
        var userPhoneNum = $("#userPhoneNum").val();
        var verificationCode = $("#verificationCode").val();

        if (!verificationCode) {
            showCustomAlert("인증번호를 입력해주세요.");
            return;
        }

        $.ajax({
            type: "POST",
            url: "/signUp/verifyCode",
            contentType: "application/json",
            data: JSON.stringify({ "userPhoneNum": userPhoneNum, "verificationCode": verificationCode }),
            success: function (res) {
                if (res === "success") {
                    showCustomAlert("인증이 완료되었습니다.");
                    userPhoneChecked = true;
                    $("#signOutSection").show();  // 탈퇴 버튼 보이기
                } else {
                    showCustomAlert("잘못된 인증번호입니다.");
                    userPhoneChecked = false;
                }
            },
            error: function () {
                showCustomAlert("인증 처리 중 오류 발생.");
            }
        });
    });

    // 회원 탈퇴 버튼 클릭 시
    $("#userSignOutBtn").click(function () {
        if (!userPhoneChecked) {
            showCustomAlert("먼저 인증을 완료해주세요.");
            return;
        }

        // 탈퇴 처리
        $("#userSignOut").submit();
    });
</script>

<jsp:include page="../common/footer.jsp" />
