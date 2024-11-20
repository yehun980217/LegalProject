<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="/css/situation.css">
<link rel="stylesheet" href="/css/loding.css">
<link rel="stylesheet" href="/css/serviceGuide.css">
<jsp:include page="../common/header.jsp" />

<!-- 로딩 화면 -->
<div id="loading-screen" style="display: none;">
    <div class="spinner"></div>
    <p>분석 중...</p>
</div>

<!-- 배너 -->
<div class="situation-banner">
    <h3>AI 기반 상황 맞춤 판례 검색</h3>
    <hr>
</div>

<!-- 입력 폼과 가이드 이미지 배치 -->
<div class="situation-layout">
    <form action="/case/searchCases" method="get" onsubmit="return submitForm();" class="situation-form">
        <!-- 텍스트 영역과 버튼 중앙 배치 -->
        <div class="textarea-and-button">
            <textarea id="situation" name="situation" class="situation-textarea" placeholder="[예]음주운전 중 음주단속에 적발되어 혈중알콜농도 0.141로 면허취소 수준이 나왔다." required></textarea>

            <!-- 검색 버튼을 텍스트 영역 중앙 아래에 배치 -->
            <div class="submit-button-container">
                <button type="submit" class="submit-button">검색</button>
            </div>
        </div>
        <!-- 가이드 이미지 -->
<%--        <div class="situation-info-image">--%>
<%--            <img src="../images/situationGuideImage.png">--%>
<%--        </div>--%>




        <div class="guide-container">
            <div class="guide-header">
                <h1>AI 기반 상황 맞춤 판례 검색 TIP</h1>
            </div>

            <div class="guide-step">
                <div class="step-number">01</div>
                <div class="step-description">
                    <h3>상황을 자세하게 설명해주세요.</h3>
                    <p>구체적인 사실과 사건 경위를 최대한 자세히 입력해주시면 더 정확한 판례문을 찾을 수 있습니다.</p>
                </div>
            </div>

            <div class="guide-step">
                <div class="step-number">02</div>
                <div class="step-description">
                    <h3>최대한 많은 단어로 설명해주세요.</h3>
                    <p>많은 단어로 상황을 길게 서술할수록 AI가 더 유사한 판례를 찾아줄 확률이 높아집니다.</p>
                </div>
            </div>
        </div>
    </form>
</div>

<jsp:include page="../common/footer.jsp" />

<!-- JavaScript 로딩 화면 제어 -->
<script>
    // 로딩 화면을 보여주는 함수
    function showLoading() {
        document.getElementById('loading-screen').style.display = 'flex';
    }

    // 로딩 화면을 숨기는 함수
    function hideLoading() {
        document.getElementById('loading-screen').style.display = 'none';
    }

    // 폼 제출 시 로딩 화면을 표시하는 함수
    function submitForm() {
        showLoading(); // 로딩 화면 표시
        return true;   // 폼이 정상적으로 제출되도록 반환
    }
</script>
