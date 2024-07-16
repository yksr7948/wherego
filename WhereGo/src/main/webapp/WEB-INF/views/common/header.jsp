 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>문서</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<!-- Popper JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/alertify.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/alertify.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
 <style>
/* 전체설정 */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: Arial, sans-serif;
	background-color: #f4f4f9;
	color: #333;
}

a {
	text-decoration: none;
}

li {
	list-style-type: none;
}

/* 헤더 */
.hbody {
	background-color: #fff;
	width: 100%;
	height: 150px;
	box-shadow: 0 2px 4px rgba
}

.nav {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 20px 50px;
	color: #333;
}

/* 제목 */
.title {
	display: flex;
	align-items: center;
}

.title img {
	width: 100px;
	height: auto;
	margin-left: 10px;
}

/* 메뉴 */
#menu {
	font: bold 20px "malgun gothic";
	width: 900px;
	height: 50px;
	color: #333;
	line-height: 50px;
	text-align: center;
	position: relative;
	z-index: 2;
}

#menu>ul>li {
	float: left;
	width: 140px;
	position: relative;
}

#menu>ul>li>a {
	color: #333;
	transition: color 0.3s;
}

#menu>ul>li>a:hover {
	color: #8B4513;
}

/* 슬라이드 위치를 아래로 이동 */
#menu>ul>li:hover .submenu {
	opacity: 1;
	visibility: visible;
	transform: translateY(0);
}

/* 서브메뉴 */
.submenu {
	width: 140px;
	opacity: 0;
	visibility: hidden;
	transform: translateY(-20px);
	transition: opacity 1s ease, visibility 1s ease, transform 1s ease;
	position: absolute;
	top: 50px;
	left: 0;
	background-color: white;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.submenu li {
	margin-top: 10px;
	margin-bottom: 10px;
}

.submenu li a {
	color: #333;
	padding: 10px;
	display: block;
	transition: background-color 0.3s, color 0.3s;
}

.submenu li a:hover {
	background-color: #f4f4f9;
	color: #8B4513;
}

/* 검색바 */
.search-bar {
	flex-grow: 0.3;
	display: flex;
	justify-content: center;
	align-items: center;
}

.search-bar input {
	width: 250px;
	max-width: 400px;
	padding: 10px;
	border: none;
	border-bottom: 1px solid black;
	font-size: 16px;
	outline: none;
}

#serach-icon {
	width: 32px;
	height: auto;
	cursor: pointer;
}

/* 로그인 버튼 */
.login-button {
	background-color: white;
	text-align: center;
	color: black;
	padding: 10px 20px;
	margin-left: 20px;
	border: 2px solid black;
	border-radius: 5px;
	font-size: 16px;
	font-weight: 900;
	cursor: pointer;
	transition: background-color 0.3s, color 0.3s;
}

.login-button:hover {
	background-color: black;
	color: white;
}

/* 사이드바 */
.sidebar {
	height: 100%;
	width: 0;
	position: fixed;
	top: 0;
	right: 0;
	background-color: #2C3E50;
	overflow-x: hidden;
	transition: 0.5s;
	padding-top: 60px;
	color: white;
	z-index: 99999;
}
.sidebar a {
	padding: 8px 8px 8px 32px;
	text-decoration: none;
	font-size: 25px;
	font-weight: 900;
	color: white;
	display: block;
	transition: 0.3s;
}
.sidebar a:hover {
	color: #818181;
}
.sidebar:hover {
	width: 250px;
}
.open-sidebar {
	position: fixed;
	top: 50%;
	right: 0;
	transform: translateY(-50%);
	width: 0;
	height: 0;
	border-top: 20px solid transparent;
	border-bottom: 20px solid transparent;
	border-left: 20px solid #2C3E50;
	cursor: pointer;
	z-index: 99998;
}
.open-sidebar:hover {
	border-left: 20px solid #555;
}
.side-submenu {
	background-color: #34495E;
	padding-left: 30px;
}
.sidebar a.side-submenu-item {
	font-size: 20px;
}

/*화면 크기 1300이상*/
@media screen and (min-width: 1300px) {
	#menu {
		display: flex;
	}
	#menu>li {
		padding: 20px 30px;
		font-size: 20px;
	}
}

/*화면 크기 1300이하*/
@media screen and (max-width: 1300px) {
	.nav {
		padding: 30px 40px;
	}
	#menu {
		display: none;
	}
}
</style>
</head>
<body>
  <header>
    <section class="hbody">
      <article class="nav">
        <div class="title">
          <a href="index.jsp"><img src="resources/img/removebg-preview.png" alt="Logo"></a>
        </div>
        <div id="menu">
          <ul>
            <li><a href="">여행지</a>
              <div class="submenu">
                <ul>
                  <li><a href="tripList.tl?contentTypeId=12">관광지</a></li>
                  <li><a href="tripList.tl?contentTypeId=14">문화시설</a></li>
                  <li><a href="tripList.tl?contentTypeId=15">축제공연행사</a></li>
                  <li><a href="tripList.tl?contentTypeId=32">숙박</a></li>
                  <li><a href="tripList.tl?contentTypeId=39">음식점</a></li>
                </ul>
              </div>
            </li>
            <li><a href="weather.we">날씨</a></li>
            <li><a href="${pageContext.request.contextPath}/travelMap">지도</a></li>
            <li><a href="review.bo">게시판</a></li>
            <li><a href="planner.pl?userId=${loginUser.userId }">플래너</a>
          </ul>
        </div>
        <div class="search-bar">
            <form action="">
                <input type="text" id="search-keyword" placeholder="검색어를 입력하세요...">
                <img id="serach-icon" src="resources/img/search-icon.png" alt="">
            </form>
        </div>
         
         		<c:choose>
					<%--로그인 전 --%>
					<c:when test="${empty loginUser }">
						<a href="loginPage.me" class="login-button">로그인</a> <a href="insertEnrollForm.me" class="login-button">회원가입</a>
					</c:when>
					<%-- 로그인 후 --%>				
					<c:otherwise>
						<label>${loginUser.userName}님 환영합니다</label> &nbsp;&nbsp; 
						<a href="myinfo.me?userId=${loginUser.userId}" class="login-button">마이페이지</a> <a href="logout.me" class="login-button">로그아웃</a>
					</c:otherwise>
				</c:choose>
        <script>
    	$(function(){
    		$("#serach-icon").click(function(){
    			var keyword=$("#search-keyword").val();
    			if(keyword==""){
    				alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,"검색어가 입력되지 않았습니다.");
    			} else {
    				location.href="search.wherego?keyword="+keyword;
    			}	
    		})
				var msg="${alertMsg}";
        			if(msg!=""){
        				alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',msg);
        				<c:remove var="alertMsg"/>
        			}
    	});
    	var input= document.getElementById("search-keyword");
    	input.addEventListener("keypress",function(event){
    		if(event.keyCode==13){ /*검색창 포커스 상태에서 엔터키 클릭시 검색실행 */
    			event.preventDefault();
    			document.getElementById("serach-icon").click();
    		}
    	});
        </script>
      </article>
    </section>
  </header>
  
  	<!-- 사이드바 -->
	<div class="open-sidebar" onmouseover="openNav()"></div>

	<div id="mySidebar" class="sidebar">
		<a href="${pageContext.request.contextPath}">● 홈</a>
  		<a href="#">● 놀이</a>
  		<div class="side-submenu">
    		<a href="worldcup.en" class="side-submenu-item">- 여행지월드컵</a>
    		<a href="rullet.en" class="side-submenu-item">- 롤렛</a>
  		</div>
  			<a href="#">● 교통</a>
  		<div class="side-submenu">
    		<a href="Gardp.tr" class="side-submenu-item">- 고속버스</a>
    		<a href="Sardp.tr" class="side-submenu-item">- 시외버스</a>
    		<a href="Train.tr" class="side-submenu-item">- 고속철도</a>
  		</div>
	</div>

	<!-- 사이드바 js -->
	<script>
			
		function openNav() {
			document.getElementById("mySidebar").style.width = "250px";
		}
		
		document.querySelector('.sidebar').addEventListener('mouseleave', function () {
			this.style.width = '0';
		});
	</script>
</body>
</html>

