<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="../css/advice.css">
<link rel="stylesheet" href="../css/serviceGuide.css">
<jsp:include page="../common/header.jsp" />

<div class="chat-container">
    <!-- 채팅창 상단 헤더 -->
    <div class="chat-header">
<%--        <img src="../images/logo.png" alt="Profile Image">--%>
        <div class="chat-title">AI 법률 조언 서비스</div>
    </div>

    <!-- 채팅창 날짜 라인 -->
    <div class="date-line"></div>

    <!-- 채팅 메시지 영역 -->
    <div class="chat-box" id="chat-box">
        <!-- 메시지들이 이곳에 추가됨 -->
    </div>

    <!-- 메시지 입력 영역 -->
    <form id="chat-form" action="/advice/getLegalAdvice" method="post" onsubmit="return sendMessage();">
        <div class="chat-input">
            <textarea id="userMessage" name="userMessage" class="chat-input" required></textarea>
            <button type="submit" class="send-button" id="sendButton">전송</button>
        </div>
    </form>
<%--    <div class="image-container">--%>
<%--        <img src="../images/legalAdviceGuide.png">--%>
<%--        <img src="../images/legalAdviceWarring.png">--%>
<%--    </div>--%>



    <div class="guide-container">
        <div class="guide-header">
            <h1>AI 법률 조언 서비스 TIP</h1>
        </div>

        <div class="guide-step">
            <div class="step-number">01</div>
            <div class="step-description">
                <h3>구체적이고 명확한 질문을 하세요.</h3>
                <p>AI는 구체적인 정보를 기반으로 답변을 제공합니다.<br>
                예를 들어, "계약서 작성 시 주의할 점은?" 보다는 <br>
                "아파트 임대 계약서에서 임차인이 주의할 점은?"과 같은 구체적인 질문이 더 도움이 됩니다.</p>
            </div>
        </div>

        <div class="guide-step">
            <div class="step-number">02</div>
            <div class="step-description">
                <h3>간결하게 작성하세요.</h3>
                <p>질문이 너무 길거나 복잡하면 AI가 본질을 파악하기 힘듭니다.<br>
                중요한 정보를 간결하게 전달하는 것이 중요합니다.</p>
            </div>
        </div>
    </div>

    <div class="guide-container">
        <div class="guide-header">
            <h1>AI 법률 조언 서비스 주의사항</h1>
        </div>

        <div class="guide-step">
            <div class="step-number">01</div>
            <div class="step-description">
                <h3>법률 전문가의 검토가 필요해요.</h3>
                <p>AI가 제공하는 정보는 법률 전문가의 조언을 대체할 수 없습니다.<br>
                AI의 답변은 참고용으로만 사용하시며 실제 법적 결정은 반드시 변호사와 상의해야합니다.</p>
            </div>
        </div>

        <div class="guide-step">
            <div class="step-number">02</div>
            <div class="step-description">
                <h3>정확한 법적 해석의 한계가 있어요.</h3>
                <p>법률은 매우 복잡하며, 각 사건의 세부사항에 따라 다르게 적용될 수 있습니다.<br>
                AI는 상황의 모든 변수를 고려하지 못할 수 있습니다.</p>
            </div>
        </div>

        <div class="guide-step">
            <div class="step-number">03</div>
            <div class="step-description">
                <h3>법적 책임의 한계가 있어요.</h3>
                <p>AI의 조언은 법적 구속력이 없습니다.<br>
                이 존어에 기반하여 행동할 경우 발생하는 문제에 대해 법문해는 책임을 지지 않습니다.</p>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // 오늘 날짜를 표시
        var today = new Date();
        var formattedDate = today.getFullYear() + '년 ' + (today.getMonth() + 1) + '월 ' + today.getDate() + '일';
        $(".date-line").text(formattedDate);
    });

    $("#sendButton").click(function(event) {
        event.preventDefault(); // 폼 제출을 막음

        var userMessage = $("#userMessage").val(); // 사용자가 입력한 메시지
        var currentTime = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true }); // 현재 시간 12시간제 형식

        if (userMessage == null || userMessage.trim() === "") {
            alert("메시지를 입력하세요.");
        } else {
            // 사용자 메시지 추가 (시간과 함께)
            $("#chat-box").append(
                '<div class="chat-message user-message">' +
                '<span class="time">' + currentTime + '</span>' +
                '<p>' + userMessage + '</p>' +
                '</div>'
            );

            // 서버로 전송할 데이터 준비
            var requestData = {
                userMessage: userMessage // JSON 데이터로 전송
            };

            // Ajax 요청
            $.ajax({
                type: "POST",
                url: "/advice/getLegalAdvice", // 요청할 URL
                contentType: "application/json", // Content-Type 설정
                data: JSON.stringify(requestData), // JSON 데이터로 변환하여 전송
                success: function(response) {
                    // GPT 응답 추가 (시간과 함께)
                    $("#chat-box").append(
                        '<div class="chat-message gpt-message">' +
                        '<span class="time">' + currentTime + '</span>' +
                        '<p>' + response.response + '</p>' +
                        '</div>'
                    );

                    // 입력 필드 비우기
                    $("#userMessage").val('');

                    // 스크롤을 맨 아래로 이동
                    $("#chat-box").scrollTop($("#chat-box")[0].scrollHeight);
                },
                error: function(xhr, status, error) {
                    // 에러 처리
                    console.log("오류 발생: " + error);
                }
            });
        }
    });
</script>


<jsp:include page="../common/footer.jsp" />
