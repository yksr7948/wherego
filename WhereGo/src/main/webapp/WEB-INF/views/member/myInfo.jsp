<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보</title>
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: Arial, sans-serif;
	background-color: #f2f2f2;
	line-height: 1.6;
	margin: 0;
	padding: 0;
}

.main-content {
	padding: 20px;
}

.profile {
	background-color: #ffffff;
	border: 1px solid #ddd;
	margin-bottom: 20px;
	padding: 20px;
	border-radius: 5px;
}

.profile h2 {
	color: #12c93a;
	font-size: 24px;
	margin-bottom: 15px;
}

.profile img {
	width: 150px;
	border-radius: 50%;
	margin-bottom: 10px;
}

.profile p {
	color: #666666;
	font-size: 14px;
	margin-bottom: 10px;
}

.activity {
	background-color: #ffffff;
	border: 1px solid #ddd;
	margin-bottom: 20px;
	padding: 20px;
	border-radius: 5px;
}

.activity h2 {
	color: #003580;
	font-size: 24px;
	margin-bottom: 15px;
}

.activity-item {
	margin-bottom: 20px;
}

.activity-item h3 {
	color: #003580;
	font-size: 18px;
	margin-bottom: 10px;
}

.activity-item ul {
	list-style-type: none;
	padding: 0;
}

.activity-item li {
	margin-bottom: 5px;
}

.image-post {
	background-color: #ffffff;
	border: 1px solid #ddd;
	margin-bottom: 20px;
	padding: 20px;
	border-radius: 5px;
	display: flex;
	flex-wrap: wrap;
}

.image-post>div {
	flex: 1;
	max-width: 300px;
	margin-right: 20px;
}

.image-post h2 {
	color: #003580;
	font-size: 24px;
	margin-bottom: 15px;
	width: 100%;
}

.image-post img {
	width: 100%;
	border-radius: 5px;
	margin-bottom: 10px;
}

.image-post p {
	color: #666666;
	font-size: 14px;
	margin-bottom: 10px;
}

.image-post .favorite {
	color: #ffcc00;
	font-size: 14px;
}
.image-post div:hover {
	color: #000000;
}

</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>
	<div class="main-content">
		<div class="profile">
			<h2>프로필</h2>
			<img src="${loginUser.myProfile}" alt="${loginUser.userName}님의 프로필"
				onerror="this.src='resources/uploadFiles/noprofile.jpg'">
			<div>
				<p>사용자 정보</p>
				<input type="hidden"name="userId" class="form-control" value="${loginUser.userId}" readonly>
				<span><b>${loginUser.userName}</b></span>님&emsp; &emsp;<span style="color: #9f9f9f"> ${loginUser.email}</span>
				<p>회원 가입일: ${loginUser.enrollDate}</p>
			</div>
			<div>
				<button type="button" onclick="location.href='mypage.me'">회원정보수정</button>
			</div>
		</div>
		<script>
			$(function(){
				var userId="${loginUser.userId}";
				$.ajax({
					url:"mypage.me",
					data:{userId:userId},
					success:function(data){
						
					},
					error:function(){
						console.log("데이터 전송 실패");
					}
				});
			});
		</script>

		<div class="activity">
			<h2>나의 활동</h2>
			<div class="activity-item">
				<h3>작성한 게시물</h3>
				<ul id="posted">
					<li></li>
				</ul>
			</div>

			<script>
				$(function() {
					var name = "${loginUser.userName}";
					$.ajax({
						url : "myreview.me",
						data : {
							name : name
						},
						success : function(name) {
							var str = "";
							
								if (name.length != 0) {
									for ( var i in name) {
									str += "<li>"
											+ "<a href='detail.bo?boardNo="
											+ name[i].boardNo + "'>"
											+ name[i].boardTitle + "</a>"
											+ "</li>";
									}
								} else {
									str += "<li>" + "<a>"
											+ "지금까지 작성한 게시글이 없습니다." + "</a>"
											+ "</li>";
								}
							
							$("#posted").html(str);
						},
						error : function() {
							console.log("게시글 입력값 불러오기 오류")
						}
					});
				});
			</script>
			<div class="activity-item">
				<h3>작성한 댓글</h3>
				<ul id="myrp">
					<li></li>
				</ul>
			</div>
			<script>
				$(function() {
					var rpy = "${loginUser.userName}";
					$.ajax({
						url : "myreply.me",
						data : {
							rpy : rpy
						},
						success : function(rpy) {
							var str = "";
							if (rpy.length != 0) {
								for ( var i in rpy) {
									str += "<li>"
											+ "<a href='detail.bo?boardNo="
											+ rpy[i].boardNo + "'>"
											+ rpy[i].boardTitle + "</a>"
											+ "</li>";
								}
							} else {
								str += "<li>" + "<a>" + "지금까지 작성한 댓글이 없습니다."
										+ "</a>" + "</li>";

							}
							$("#myrp").html(str);
						},
						error : function() {
							console.log("댓글 입력값 받아오기 오류")
						}
					});
				});
			</script>

		</div>

		<h2 style="color: firebrick">이런 여행지는 어떠세요?</h2>

		<div class="image-post">
			<c:forEach items="${myList}" var="myList">
				<div id="mybesttrip" class="card-content" onclick="location.href='tripDetail.tl?contentId='+${myList.contentId}">
					<input type="hidden" value="${myList.contentId}"> 
					<img src="${myList.firstImage2}" alt="${myList.title}" onerror="this.src='resources/uploadFiles/notrip.png'">
					<h2>${myList.title}</h2>
					<p>${myList.addr1}</p>
				</div>
			</c:forEach>
		</div>

		<h2 style="color: orange">좋아하는 여행지</h2>
		<div class="image-post">
			<c:forEach items="${myFavor}" var="myFavor">
				<div id="myfavortrip" class="card-content" onclick="location.href='tripDetail.tl?contentId='+${myFavor.contentId}">
					<input type="hidden" value="${myFavor.contentId}">
					<span>${myFavor.title}</span>
					<img src="${myFavor.firstImage2}" onerror="this.src='resources/uploadFiles/notrip.png'"> 		
					<span>${myFavor.addr1}</span>
				</div>
			</c:forEach>
		</div>
	</div>


	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>