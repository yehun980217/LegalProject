<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<title>법문해</title>
<link rel="stylesheet" href="/css/index.css">  <!-- 인덱스 전용 CSS만 불러옴 -->
<jsp:include page="common/header.jsp" />

<div class="main-box">
	<div class="background">
			<!-- 슬라이더 추가 -->
			<div class="slider-container">
				<!-- 슬라이드 1: 조회 서비스 -->
				<div class="slide fade">
					<div class="content-container">
						<div class="intro-text">
							<h2>법문해<strong style="color:red;">.</strong></h2>
							<h1>간편한 판례문 조회 서비스</h1>
							<p>AI 분석을 통해 자신의 상황을 입력하여<br>간편하게 자신의 상황과 유사한 판례문을 조회하세요.</p>
						</div>
						<a href="/situationForm" class="service-button">입력하러가기</a>
					</div>
				</div>

				<!-- 슬라이드 2: 챗봇 상담 서비스 -->
				<div class="slide fade">
					<div class="content-container">
					<div class="intro-text">
						<h2>법문해<strong style="color:red;">.</strong></h2>
						<h1>AI 챗봇 법률 상담 서비스</h1>
						<p>AI 챗봇과의 대화를 통해 법률 관련 질문에 신속하게 답변을 받아보세요.<br>언제 어디서든 간편하게 상담 서비스를 이용하세요.</p>
					</div>
					<a href="/legalAdvice" class="service-button">챗봇 상담하기</a>
					</div>
				</div>

				<!-- 슬라이더 네비게이션 버튼 -->
				<a class="prev" onclick="plusSlides(-1)">&#10094;</a>
				<a class="next" onclick="plusSlides(1)">&#10095;</a>
			</div>
		</div>
	</div>





<%--	<!-- About 섹션 -->--%>
<%--	<div class="about-section">--%>
<%--		<h1>About<strong style="color:red;">.</strong></h1>--%>
<%--		<div class="section-row">--%>
<%--			<div class="text-left">--%>
<%--				<h3>AI 기반 법률 정보 검색</h3>--%>
<%--				<p>AI 기술을 활용하여 사용자 맞춤형 법률 정보를 제공합니다.<br>간단한 입력만으로 필요한 법률 자료와 판례를 빠르게 확인하세요.</p>--%>
<%--			</div>--%>
<%--			<div class="text-right">--%>
<%--				<h3>언제 어디서나 법률 정보에 접근</h3>--%>
<%--				<p>이제 법률 자료를 찾기 위해 복잡한 절차를 거칠 필요가 없습니다.<br>AI 기반의 검색 서비스를 통해 언제든지 필요한 법률 정보를 간편하게 찾아보세요.</p>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--		<div class="section-row">--%>
<%--			<div class="text-left">--%>
<%--				<h3>복잡한 판례, 한눈에 요약</h3>--%>
<%--				<p>복잡하고 긴 판례문도 한눈에 이해할 수 있도록 간결하게 요약해 드립니다<br>핵심만 빠르게 파악하세요.</p>--%>
<%--			</div>--%>
<%--			<div class="text-right">--%>
<%--				<h3>더 나은 법률 접근성의 시작</h3>--%>
<%--				<p>법률 정보는 더 이상 복잡하지 않습니다.<br>누구나 쉽게 접근할 수 있는 법률 서비스를 통해 새로운 시대를 맞이하세요.</p>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--	</div>--%>
<%--</div>--%>

<!-- JavaScript for Slider -->
<script>
	let slideIndex = 0;
	showSlides();

	function plusSlides(n) {
		showSlides(slideIndex += n);
	}

	function showSlides() {
		let i;
		let slides = document.getElementsByClassName("slide");
		if (slideIndex >= slides.length) {slideIndex = 0}
		if (slideIndex < 0) {slideIndex = slides.length - 1}
		for (i = 0; i < slides.length; i++) {
			slides[i].style.display = "none";
		}
		slides[slideIndex].style.display = "block";
	}

	document.addEventListener("DOMContentLoaded", function() {
		// 모든 섹션 컨테이너 요소 선택
		const sections = document.querySelectorAll('.section-container');

		// Intersection Observer 설정
		const observerOptions = {
			threshold: 0.2 // 섹션이 20% 이상 화면에 나타나면 애니메이션 시작
		};

		const observer = new IntersectionObserver((entries, observer) => {
			entries.forEach(entry => {
				if (entry.isIntersecting) {
					entry.target.classList.add('show');
					observer.unobserve(entry.target); // 이미 애니메이션이 실행된 섹션은 다시 감지하지 않음
				}
			});
		}, observerOptions);

		// 각 섹션에 대해 관찰 시작
		sections.forEach(section => {
			observer.observe(section);
		});
	});
</script>

<jsp:include page="common/footer.jsp" />