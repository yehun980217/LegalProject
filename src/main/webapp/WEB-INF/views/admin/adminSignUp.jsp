<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="/css/signup.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<jsp:include page="../common/header.jsp" />
<title>회원가입</title>

<section id="signupSection">
    <div id="signupContainer">
        <!-- 새로 추가한 div 태그 -->
        <div class="signup-form-container">
            <h1>일반 회원가입</h1>
            <form method="post" action="/admin/adminSignUp" id="signForm">
                <!-- 아이디 -->
                <div class="form-group">
                    <label for="userID">아이디</label>
                    <input type="text" id="userId" name="userId">
                    <button type="button" id="chkId">중복확인</button>
                </div>
                <div id="iDMatch" class="error-message"></div>
                <input type="hidden" id="userChkId">


                <!-- 비밀번호 -->
                <div class="form-group">
                    <label for="userPwd">비밀번호</label>
                    <input type="password" id="userPwd" name="userPwd">
                </div>
                <div id="pwdMatch" class="error-message"></div>


                <!-- 비밀번호 확인 -->
                <div class="form-group">
                    <label for="chkPwd">비밀번호 확인</label>
                    <input type="password" id="chkPwd" name="chkPwd">
                </div>
                <div id="chkPwdMatch" class="error-message"></div>
                <hr>
                <!-- 회원가입 버튼 -->
                <button type="button" id="signUpBtn">회원가입</button>
            </form>
        </div> <!-- signup-form-container 종료 -->
    </div>
</section>

<!-- 커스텀 알림창 -->
<div id="customAlert" class="custom-alert hidden">
    <p id="alertMessage"></p>
    <button id="closeAlertBtn">닫기</button>
</div>

<script>

    var userIdChecked = false;
    var userPwdChecked = false;

    $("#chkId").click(function() { // 아이디 중복 검사
        var userId = $("#userId").val();
        if (userId == "" || userId == null) {
            $("#iDMatch").text("아이디를 입력하세요.");
        } else {
            userIdChecked = false; // 사용자가 새로운 아이디를 입력할 때마다 초기화
            userIdCheck(userId, function(result) {
                if(result == "success") {
                    var continueSignUp = confirm("사용가능한 아이디 입니다. 사용하시겠습니까?");
                    if (continueSignUp) {
                        userIdChecked = true; // 아이디 중복 확인 완료
                    }
                } else if(result == "fail") {
                    alert("중복된 아이디입니다. 다른 아이디를 입력해주세요.");
                    userIdChecked = false; // 아이디 중복 확인 실패
                }
            });
        }
    });

    $("#signUpBtn").click(function() {

        // 간단한 유효성 검사
        if (!userIdChecked) {
            showCustomAlert("아이디 중복을 확인해주세요.");
        } else if (!userPwdChecked) {
            showCustomAlert("비밀번호가 일치하는 지 확인해주세요.");
        } else {
            alert("회원가입이 완료되었습니다.");
            $("#signForm").submit();
        }
    });

    function showCustomAlert(message) {
        const alertBox = document.getElementById("customAlert");
        document.getElementById("alertMessage").innerText = message;
        alertBox.classList.remove("hidden");
    }

    document.getElementById("closeAlertBtn").addEventListener("click", function() {
        const alertBox = document.getElementById("customAlert");
        alertBox.classList.add("hidden");
    });

    function userIdCheck(userId, callback) {
        $.ajax({
            type: 'post',
            url: '/signUp/chkId',
            data: {"userId": userId},
            success: function(result) {
                callback(result);
            },
            error: function() {
                console.log("중복검사 오류");
            }
        });
    }

    $("#userId").on('keyup', function () {
        userIdChecked = false;
        if (userId == "" || userId == null) {
            $("#iDMatch").text("아이디를 입력하세요.");
        } else {
            $("#iDMatch").text("");
        }
    });




    $("#userPwd, #chkPwd").on('keyup', function () {
        var userPwd = $("#userPwd").val(); // 비밀번호 입력값 가져오기
        var chkPwd = $("#chkPwd").val();   // 비밀번호 확인 입력값 가져오기

        // 정규식: 영문자, 숫자, 특수문자를 모두 포함하며, 8자 이상
        var exptext = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[`~!@#$%^&*()+|=-_ ])[A-Za-z\d~`!@#$%^&*()+|=-_ ]{8,}$/;

        // 비밀번호 확인란이 비어 있을 경우
        if (chkPwd == "" || chkPwd == null) {
            $("#chkPwdMatch").text("");
            userPwdChecked = false;
        }

        // 비밀번호 형식이 맞지 않는 경우
        if (exptext.test(userPwd) == false) {
            $("#pwdMatch").text("비밀번호는 영문자, 숫자, 특수문자를 모두 포함하여 8글자 이상으로 만들어야 합니다.");
            userPwdChecked = false;
        } else {
            $("#pwdMatch").text(""); // 형식이 맞으면 오류 메시지 제거
        }

        // 비밀번호와 확인 비밀번호가 일치하고, 형식이 올바른 경우
        if (userPwd === chkPwd && exptext.test(userPwd) == true) {
            $("#chkPwdMatch").text("비밀번호가 일치합니다.")
                .css("color", "blue"); // 일치할 경우 파란색 메시지
            userPwdChecked = true;
        }

        // 비밀번호가 일치하지 않는 경우
        if (userPwd !== chkPwd) {
            $("#chkPwdMatch").text("비밀번호가 일치하지 않습니다. 다시 입력해주세요.")
                .css("color", "red"); // 불일치할 경우 빨간색 메시지
            userPwdChecked = false;
        }

        // 비밀번호 확인란이 비어 있을 경우 메시지 제거
        if (chkPwd == "" || chkPwd == null) {
            $("#chkPwdMatch").text("");
            userPwdChecked = false;
        }
    });
</script>

<jsp:include page="../common/footer.jsp" />
