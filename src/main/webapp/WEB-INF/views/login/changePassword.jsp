<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="/css/changePassword.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<jsp:include page="../common/header.jsp" />
<title>비밀번호 변경</title>
<section id="changePasswordSection">
    <div id="changePasswordContainer">
        <form method="post" action="/login/changePassword" id="changePasswordForm">
            <!-- 새 비밀번호 -->
            <input type="hidden" id="userId" name="userId" value="${sessionScope.findPwUser.userId}">
            <div class="form-group">
                <label for="newPassword">새 비밀번호</label>
                <input type="password" id="newPassword" name="newPassword" placeholder="새 비밀번호">
            </div>
            <div id="pwdMatch" class="error-message"></div>
            <hr>

            <!-- 새 비밀번호 확인 -->
            <div class="form-group">
                <label for="chkNewPassword">새 비밀번호 확인</label>
                <input type="password" id="chkNewPassword" name="chkNewPassword" placeholder="새 비밀번호 확인">
            </div>
            <div id="chkPwdMatch" class="error-message"></div>
            <hr>

            <!-- 비밀번호 변경 버튼 -->
            <button type="button" id="changePasswordBtn">비밀번호 변경</button>
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
        var passwordChecked = false;

        $("#newPassword, #chkNewPassword").on('keyup', function () {
            var newPassword = $("#newPassword").val(); // 새 비밀번호 입력값 가져오기
            var chkNewPassword = $("#chkNewPassword").val(); // 새 비밀번호 확인 입력값 가져오기

            // 정규식: 영문자, 숫자, 특수문자를 모두 포함하며, 8자 이상
            var exptext = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[`~!@#$%^&*()+|=-_ ])[A-Za-z\d~`!@#$%^&*()+|=-_ ]{8,}$/;

            // 비밀번호 형식이 맞지 않는 경우
            if (!exptext.test(newPassword)) {
                $("#pwdMatch").text("비밀번호는 영문자, 숫자, 특수문자를 포함하여 8글자 이상이어야 합니다.");
                passwordChecked = false;
            } else {
                $("#pwdMatch").text(""); // 형식이 맞으면 오류 메시지 제거
            }

            // 비밀번호와 확인 비밀번호가 일치하고, 형식이 올바른 경우
            if (newPassword === chkNewPassword && exptext.test(newPassword)) {
                $("#chkPwdMatch").text("비밀번호가 일치합니다.").css("color", "blue");
                passwordChecked = true;
            } else if (newPassword !== chkNewPassword) {
                $("#chkPwdMatch").text("비밀번호가 일치하지 않습니다. 다시 입력해주세요.").css("color", "red");
                passwordChecked = false;
            }

            // 비밀번호 확인란이 비어 있을 경우 메시지 제거
            if (chkNewPassword == "" || chkNewPassword == null) {
                $("#chkPwdMatch").text("");
                passwordChecked = false;
            }
        });

        // 비밀번호 변경 버튼 클릭 시
        $("#changePasswordBtn").click(function () {
            var newPassword = $("#newPassword").val();
            var confirmPassword = $("#chkNewPassword").val();
            var userId = $("#userId").val(); // 사용자 ID 가져오기

            if (newPassword !== confirmPassword) {
                showCustomAlert("비밀번호가 일치하지 않습니다.");
                return;
            }

            $.ajax({
                type: "POST",
                url: "/login/changePassword",
                contentType: "application/json",
                data: JSON.stringify({ "userId": userId, "userPwd": newPassword }),
                success: function (res) {
                    if (res.success) {
                        showCustomAlert("비밀번호가 변경되었습니다.");
                        $("#closeAlertBtn").click(function () {
                            window.location.href = "/login/userLogin"; // 로그인 페이지로 이동
                        });
                    }
                },
                error: function () {
                    showCustomAlert("비밀번호 변경 중 오류 발생.");
                }
            });
        });

        function showCustomAlert(message) {
            const alertBox = document.getElementById("customAlert");
            document.getElementById("alertMessage").innerText = message;
            alertBox.classList.remove("hidden");
        }

        document.getElementById("closeAlertBtn").addEventListener("click", function () {
            const alertBox = document.getElementById("customAlert");
            alertBox.classList.add("hidden");
        });
    });

</script>

<jsp:include page="../common/footer.jsp" />
