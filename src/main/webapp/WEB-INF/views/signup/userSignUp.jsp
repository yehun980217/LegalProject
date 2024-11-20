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
            <form method="post" action="/signUp/userSignUp" id="signForm">
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

                <!-- 전화번호 -->
                <div class="form-group">
                    <label for="userPhoneNum">전화번호</label>
                    <input type="text" id="userPhoneNum" name="userPhoneNum">
                    <button type="button" id="userPhoneChk">인증</button>
                </div>
                <div id="chkUserPhoneNum" class="error-message"></div>

                <!-- 인증 번호 -->
                <div id="verificationFields" style="display: none;">
                    <div class="form-group">
                        <label for="verificationCode">인증번호</label>
                        <input type="text" id="verificationCode" name="verificationCode">
                        <button type="button" id="verifyCode">인증하기</button>
                    </div>
                    <div id="verificationResult" class="error-message"></div>
                </div>

                <!-- 이름 -->
                <div class="form-group">
                    <label for="userName">이름</label>
                    <input type="text" id="userName" name="userName">
                </div>
                <hr>

                <!-- 생년월일 -->
                <div class="birth-group">
                    <select id="birth-year" name="birthYear" onchange="checkSelection()">
                        <option disabled selected>출생 연도</option>
                    </select>
                    <select id="birth-month" name="birthMonth" onchange="checkSelection()">
                        <option disabled selected>월</option>
                    </select>
                    <select id="birth-day" name="birthDay" onchange="checkSelection()">
                        <option disabled selected>일</option>
                    </select>
                </div>
                <div id="birthMatch" class="error-message"></div>
                <hr>

                <!-- 우편번호와 버튼 -->
                <div class="postcode-group">
                    <input type="text" id="sample4_postcode" placeholder="우편번호">
                    <input type="button" id="postcodeButton" onclick="sample4_execDaumPostcode()" value="우편번호 찾기">
                </div>
                <input type="text" id="sample4_roadAddress" name="sample4_roadAddress" placeholder="도로명주소">
                <input type="text" id="sample4_detailAddress" name="sample4_detailAddress" placeholder="상세주소">
                <input type="hidden" id="sample4_jibunAddress">
                <input type="hidden" id="sample4_extraAddress">
                <input type="hidden" id="sample4_engAddress">
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

<%--<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>--%>
<script>

    var userIdChecked = false;
    var userPwdChecked = false;
    var userPhoneChecked = false;
    var userNameChecked = false;
    var userBirthChecked = false;
    var userAdressChcked = false;

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
        var userName = $("#userName").val();
        var sample4_postcode = $("#sample4_postcode").val();
        var sample4_roadAddress = $("#sample4_roadAddress").val();

        // 간단한 유효성 검사
        if (!userIdChecked) {
            showCustomAlert("아이디 중복을 확인해주세요.");
        } else if (!userPwdChecked) {
            showCustomAlert("비밀번호가 일치하는 지 확인해주세요.");
        } else if (!userPhoneChecked) {
            showCustomAlert("전화번호 인증을 완료해주세요.");
        } else if (!userName) {
            showCustomAlert("이름을 입력해주세요.");
        } else if (!sample4_postcode || !sample4_roadAddress) {
            showCustomAlert("주소를 입력해주세요.");
        } else if (!userBirthChecked) {
            showCustomAlert("생년월일을 입력해주세요.");
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


    $("#userPhoneChk").click(function() {
        var userPhoneNum = $("#userPhoneNum").val();

        if (userPhoneNum == null || userPhoneNum.trim() === "") {
            $("#chkUserPhoneNum").text("전화번호를 입력해주세요.");
        } else {
            $("#chkUserPhoneNum").text("");

            // JSON 형식의 데이터로 전송
            $.ajax({
                type : "post",
                url : "/signUp/sendSMS",
                contentType: "application/json", // Content-Type 설정
                data : JSON.stringify({"userPhoneNum" : userPhoneNum}), // 데이터를 JSON 문자열로 변환하여 전송
                success: function(res) {
                    alert("인증번호 발송 완료!");
                    $("#verificationFields").show();
                },
                error : function() {
                    console.log("전화번호 인증 오류");
                    $("#verificationFields").show();
                }
            })
        }
    });

    $("#verifyCode").click(function() {
        var userPhoneNum = $("#userPhoneNum").val();
        var verificationCode = $("#verificationCode").val();
        var requestData = {
            "userPhoneNum": userPhoneNum,
            "verificationCode": verificationCode
        };

        $.ajax({
            type: "POST",
            url: "/signUp/verifyCode",
            contentType: "application/json", // Content-Type 설정
            data: JSON.stringify(requestData), // JSON 형식으로 데이터 전송
            success: function(res) {
                if (res == "success") {
                    $("#verificationResult").text("인증되었습니다.").css("color", "blue");
                    userPhoneChecked = true;
                } else {
                    $("#verificationResult").text("올바르지 않은 인증번호입니다.");
                    userPhoneChecked = false;
                }
            },
            error: function() {
                console.log("인증 오류");
            }
        });
    });


    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample4_postcode').value = data.zonecode;
                document.getElementById("sample4_roadAddress").value = roadAddr;
                document.getElementById("sample4_jibunAddress").value = data.jibunAddress;

                document.getElementById("sample4_engAddress").value = data.addressEnglish;

                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                if(roadAddr !== ''){
                    document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("sample4_extraAddress").value = '';
                }

                var guideTextBox = document.getElementById("guide");
                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                    guideTextBox.style.display = 'block';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                    guideTextBox.style.display = 'block';
                } else {
                    guideTextBox.innerHTML = '';
                    guideTextBox.style.display = 'none';
                }
            }
        }).open();
    }

    const birthYearEl = document.querySelector('#birth-year')
    isYearOptionExisted = false;
    birthYearEl.addEventListener('focus', function () {
        if(!isYearOptionExisted) {
            isYearOptionExisted = true
            for(var i = 1940; i <= 2024; i++) {
                const YearOption = document.createElement('option')
                YearOption.setAttribute('value', i)
                YearOption.innerText = i
                this.appendChild(YearOption);
            }
        }
    });
    // Month, Day도 동일한 방식으로 구현
    const birthMonthEl = document.querySelector('#birth-month')
    isMonthOptionExisted = false;
    birthMonthEl.addEventListener('focus', function () {
        if(!isMonthOptionExisted) {
            isMonthOptionExisted = true;
            for (var i = 1; i <= 12; i++) {
                const MonthOption = document.createElement('option')
                MonthOption.setAttribute('value', i)
                MonthOption.innerText = i
                this.appendChild(MonthOption);
            }
        }
    });

    const birthDayEl = document.querySelector('#birth-day')
    isDayOptionExisted = false;
    birthDayEl.addEventListener('focus', function () {
        if(!isDayOptionExisted) {
            isDayOptionExisted = true;
            for (var i = 1; i <= 31; i++) {
                const DayOption = document.createElement('option')
                DayOption.setAttribute('value', i)
                DayOption.innerText = i
                this.appendChild(DayOption);
            }
        }
    });

    function checkSelection() {
        const year = document.getElementById('birth-year').value;
        const month = document.getElementById('birth-month').value;
        const day = document.getElementById('birth-day').value;

        if (year !== '출생 연도' && month !== '월' && day !== '일') {
            userBirthChecked = true;
            document.getElementById('birthMatch').textContent = '';
        } else {
            userBirthChecked = false;
            document.getElementById('birthMatch').textContent = '생년월일을 선택해주세요.';
        }
    }
</script>

<jsp:include page="../common/footer.jsp" />
