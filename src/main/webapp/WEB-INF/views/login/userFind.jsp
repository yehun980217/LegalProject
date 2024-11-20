<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="/css/userFind.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<jsp:include page="../common/header.jsp" />
<title>아이디/비밀번호 찾기</title>
<section id="findUserSection">
    <div id="findUserContainer">
        <h1>법문해<strong style="color:red;">.</strong></h1>
        <!-- 탭 버튼 -->
        <div id="tabMenu">
            <button type="button" id="findIdTab" class="active-tab">아이디 찾기</button>
            <button type="button" id="findPwTab">비밀번호 찾기</button>
        </div>

        <!-- 아이디 찾기 폼 -->
        <form id="findIdForm" class="tab-content">
            <div class="form-group">
                <label for="userNameId">이름</label>
                <input type="text" id="userNameId" name="userName" class="input-field" placeholder="이름">
            </div>
<%--            <hr>--%>
            <div class="form-group">
                <label for="userPhoneNumId">핸드폰 번호</label>
                <div class="input-group">
                    <input type="text" id="userPhoneNumId" name="userPhoneNum" class="input-field" placeholder="핸드폰 번호">
                    <button type="button" id="sendVerificationCodeId" class="send-btn">인증번호 전송</button>
                </div>
            </div>
            <div id="phoneErrorId" class="error-message"></div>
<%--            <hr>--%>
            <div id="verificationFieldsId" style="display: none;">
                <div class="form-group">
                    <label for="verificationCodeId">인증번호</label>
                    <div class="input-group">
                        <input type="text" id="verificationCodeId" name="verificationCode" class="input-field" placeholder="인증번호 입력">
                        <button type="button" id="verifyCodeBtnId" class="send-btn">인증하기</button>
                    </div>
                </div>
                <div id="verificationResultId" class="error-message"></div>
            </div>
<%--            <hr>--%>
            <div id="findIdResult" class="hidden">
                <p>회원님의 아이디는 <span id="userIdResult"></span> 입니다.</p>
            </div>
            <button type="button" id="findIdBtn" class="find-btn">아이디 조회</button>
        </form>

        <!-- 비밀번호 찾기 폼 -->
        <form id="findPwForm" class="tab-content hidden">
            <div class="form-group">
                <label for="userIdPw">아이디</label>
                <input type="text" id="userIdPw" name="userId" class="input-field" placeholder="아이디">
            </div>
<%--            <hr>--%>
            <div class="form-group">
                <label for="userNamePw">이름</label>
                <input type="text" id="userNamePw" name="userName" class="input-field" placeholder="이름">
            </div>
<%--            <hr>--%>
            <div class="form-group">
                <label for="userPhoneNumPw">핸드폰 번호</label>
                <div class="input-group">
                    <input type="text" id="userPhoneNumPw" name="userPhoneNum" class="input-field" placeholder="핸드폰 번호">
                    <button type="button" id="sendVerificationCodePw" class="send-btn">인증번호 전송</button>
                </div>
            </div>
            <div id="phoneErrorPw" class="error-message"></div>
<%--            <hr>--%>
            <div id="verificationFieldsPw" style="display: none;">
                <div class="form-group">
                    <label for="verificationCodePw">인증번호</label>
                    <div class="input-group">
                        <input type="text" id="verificationCodePw" name="verificationCode" class="input-field" placeholder="인증번호 입력">
                        <button type="button" id="verifyCodeBtnPw" class="send-btn">인증하기</button>
                    </div>
                </div>
                <div id="verificationResultPw" class="error-message"></div>
            </div>
<%--            <hr>--%>
            <button type="button" id="findPwBtn" class="find-btn">비밀번호 변경</button>
        </form>
    </div>
</section>

<!-- 커스텀 알림창 -->
<div id="customAlert" class="custom-alert hidden">
    <p id="alertMessage"></p>
    <button id="closeAlertBtn">닫기</button>
</div>


<script>
    $(document).ready(function () {
        // 기본적으로 아이디 찾기 폼을 먼저 보여줌
        $("#findIdForm").show();
        $("#findPwForm").hide();

        // 탭 클릭 이벤트
        $("#findIdTab").click(function () {
            $(this).addClass("active-tab");
            $("#findPwTab").removeClass("active-tab");
            $("#findIdForm").show();
            $("#findPwForm").hide();
        });

        $("#findPwTab").click(function () {
            $(this).addClass("active-tab");
            $("#findIdTab").removeClass("active-tab");
            $("#findIdForm").hide();
            $("#findPwForm").show();
        });

        var userPhoneCheckedId = false;  // 아이디 찾기용 핸드폰 인증 확인 변수
        var userPhoneCheckedPw = false;  // 비밀번호 찾기용 핸드폰 인증 확인 변수

        // 아이디 찾기 - 인증번호 전송 버튼 클릭 시
        $("#sendVerificationCodeId").click(function () {
            var userPhoneNum = $("#userPhoneNumId").val();
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
                    $("#verificationFieldsId").show();
                },
                error: function () {
                    showCustomAlert("인증번호 발송 실패. 다시 시도해주세요.");
                    $("#verificationFields").show();
                }
            });
        });

        // 인증하기 버튼 클릭 시 (아이디 찾기)
        $("#verifyCodeBtnId").click(function () {
            var userPhoneNum = $("#userPhoneNumId").val();
            var verificationCode = $("#verificationCodeId").val();

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
                        userPhoneCheckedId = true;  // 아이디 찾기 인증 완료 상태로 변경
                    } else {
                        showCustomAlert("잘못된 인증번호입니다.");
                        userPhoneCheckedId = false;
                    }
                },
                error: function () {
                    showCustomAlert("인증 처리 중 오류 발생.");
                }
            });
        });

        // 아이디 찾기 버튼 클릭 시
        $("#findIdBtn").click(function () {
            var userName = $("#userNameId").val();
            var userPhoneNum = $("#userPhoneNumId").val();

            if (!userName || !userPhoneNum) {
                showCustomAlert("이름과 핸드폰 번호를 입력해주세요.");
                return;
            }

            if (!userPhoneCheckedId) {
                showCustomAlert("핸드폰 인증을 완료해주세요.");
                return;
            }

            $.ajax({
                type: "POST",
                url: "/login/userFindId",
                contentType: "application/json",
                data: JSON.stringify({ "userName": userName, "userPhoneNum": userPhoneNum }),
                success: function (res) {
                    if (res.userId) {
                        $("#userIdResult").text(res.userId);
                        $("#findIdResult").removeClass("hidden");
                    } else {
                        showCustomAlert("일치하는 회원 정보가 없습니다.");
                    }
                },
                error: function () {
                    showCustomAlert("아이디 찾기 중 오류 발생.");
                }
            });
        });

        // 비밀번호 찾기 - 인증번호 전송 버튼 클릭 시
        $("#sendVerificationCodePw").click(function () {
            var userPhoneNum = $("#userPhoneNumPw").val();
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
                    $("#verificationFieldsPw").show();
                },
                error: function () {
                    showCustomAlert("인증번호 발송 실패. 다시 시도해주세요.");
                    $("#verificationFields").show();
                }
            });
        });

        // 비밀번호 찾기 인증하기 버튼 클릭 시
        $("#verifyCodeBtnPw").click(function () {
            var userPhoneNum = $("#userPhoneNumPw").val();
            var verificationCode = $("#verificationCodePw").val();

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
                        userPhoneCheckedPw = true;
                    } else {
                        showCustomAlert("잘못된 인증번호입니다.");
                        userPhoneCheckedPw = false;
                    }
                },
                error: function () {
                    showCustomAlert("인증 처리 중 오류 발생.");
                }
            });
        });

        // 비밀번호 찾기 버튼 클릭 시
        // 비밀번호 찾기 버튼 클릭 시
        $("#findPwBtn").click(function () {
            var userId = $("#userIdPw").val();
            var userName = $("#userNamePw").val();
            var userPhoneNum = $("#userPhoneNumPw").val();

            if (!userId || !userName || !userPhoneNum) {
                showCustomAlert("아이디, 이름, 핸드폰 번호를 입력해주세요.");
                return;
            }

            if (!userPhoneCheckedPw) {
                showCustomAlert("핸드폰 인증을 완료해주세요.");
                return;
            }

            $.ajax({
                type: "POST",
                url: "/login/userFindPw", // 비밀번호 찾기 로직
                contentType: "application/json",
                data: JSON.stringify({ "userId": userId, "userName": userName, "userPhoneNum": userPhoneNum }),
                success: function (res) {
                    if (res.success) {
                        // 인증 완료 시 비밀번호 변경 페이지로 이동
                        window.location.href = "/login/changePassword?userId=" + userId;
                    } else {
                        showCustomAlert("일치하는 회원 정보가 없습니다.");
                    }
                },
                error: function () {
                    showCustomAlert("비밀번호 찾기 중 오류 발생.");
                }
            });
        });


        // 커스텀 알림창 기능
        function showCustomAlert(message) {
            const alertBox = $("#customAlert");
            $("#alertMessage").text(message);
            alertBox.removeClass("hidden");
        }

        $("#closeAlertBtn").click(function () {
            $("#customAlert").addClass("hidden");
        });
    });
</script>



<jsp:include page="../common/footer.jsp" />