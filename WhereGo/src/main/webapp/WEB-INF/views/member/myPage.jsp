<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
 body {
        font-family: 'Arial', sans-serif;
        background-color: #F0F4F8;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        flex-direction: column;
        text-align: center;
    }
    img {
        max-width: 100%;
        height: auto;
    }
    label{
    	 color: #007bff;
    margin-bottom: 20px;
    font-size: 1.0em;
    }
        .form-group {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
    }
    .form-group .field-container {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
    }
    .form-group label {
        width: 150px; /* Adjust as needed */
        text-align: right;
        margin-right: 10px;
    }
    .form-group input {
        flex-grow: 1;
        width: 200px;
    }
    .btns {
        margin-top: 20px;
    }
    .check-result {
        font-size: 0.8em;
        margin-left: 10px;
        width: 150px; /* 고정된 너비 설정 */
    }
     .gender-container {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
        width: 400px; /* 고정된 너비 설정 */
    }
    .gender-container label {
        margin-right: 10px;
     }
 button {
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
button:hover {
    background-color: black;
    color: white;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	
	
	<div class="content">
		<br> <br>
		<div class="innerOuter">
			<h2>회원 정보 수정</h2>
			<br>
			
			<form action="mypage.me" method="post" enctype="multipart/form-data">
				
				<div class="form-group">
					<label for="enrollUserId">&nbsp; ID</label>
					<input type="text" id="enrollUserId" name="userId" class="form-control" value="${loginUser.userId}" readonly> <br>
					
					<label for="userName">&nbsp; NAME</label>
					<input type="text" id="userName" name="userName" class="form-control" value="${loginUser.userName}"> <br>
					
					<label for="email"> &nbsp; EMAIL</label>
					<input type="email" id="email" name="email" class="form-control" value="${loginUser.email}"> <br>
					
					<label for="age"> &nbsp; AGE</label>
					<input type="number" id="age" name="age" class="form-control" value="${loginUser.age}"> <br>
					
					<label for="phone"> &nbsp; PHONE</label>
					<input type="tel" id="phone" name="phone" class="form-control" placeholder="(-)없이 입력" value="${loginUser.phone}"> <br>
					
					<label for="gender"> &nbsp; GENDER</label> &nbsp;&nbsp;
					<input type="radio" id="male" value="M" name="gender">
					<label for="male">남자</label> &nbsp;&nbsp;
					<input type="radio" id="female" value="F" name="gender">
					<label for="female">여자</label> &nbsp;&nbsp;
					
					<table border="1" align="center">
						<thead>
							<tr>프로필 사진</tr>
						</thead>
						<tbody>
							<tr> 
								<input type="file" id="reprofile" name="reprofile" class="form-control" accept=".png, .jpeg, .jpg, .gif, .img, .bmg"> 
								<th>현재 나의 프로필</th> 
								<td>
								<img src="${loginUser.myProfile}" download="${loginUser.profile}" onerror="this.src='resources/uploadFiles/noprofile.jpg'" width="150" height="150">${loginUser.profile}</a>
								</td>
								<input type="hidden" name="profile" value="${loginUser.profile}">
								<input type="hidden" name="myProfile" value="${loginUser.myProfile}">	
							</tr>
						</tbody>
					</table>
					
				</div>
				<div class="btns" align="center">
					<button type="submit" class="btn btn-primary">정보수정</button>
					<button type="button" class="btn btn-danger" data-toggle="modal" data-target="#deleteModal">회원탈퇴</button>
				</div>
				
			</form>
		</div>
	</div>
	
	<script>
		$(function(){
			var gender = "${loginUser.gender}";
			if(gender != ""){
				$("input[value=${loginUser.gender}]").attr("checked",true);
			}
			
			
		});
		
		
	</script>
	
	
	<!--메소드명 :  deleteMember 
		성공시 메세지와 함께 메인페이지로 이동(재요청) - 세션로그인 정보 제거 
		실패시 에러페이지 에러메세지와 함께 보내기
	-->
	
	
	<!-- 회원탈퇴 클릭시 사용될 모달영역 -->
	<div class="modal fade" id="deleteModal">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">회원탈퇴</h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>

				<!-- 회원탈퇴 요청 처리할 form태그 -->
				<form action="delete.me" method="post">
					<!-- Modal body -->
					<div class="modal-body">
						<div align="center">
							탈퇴 후 복구가 불가능 합니다. <br>
							정말로 탈퇴하시겠습니까? <br>
						</div>
						
						<label for="userPwd">PASSWORD :</label>
						<input type="password" class="form-control mb-2 mr-sm-2" 
								placeholder="ENTER PASSWORD" id="userPwd" name="userPwd" required>
								
					</div>
					<!-- Modal footer -->
					<div class="modal-footer">
						<button type="submit" class="btn btn-danger">회원탈퇴</button>
						<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
					</div>
				</form>

			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>
</body>
</html>