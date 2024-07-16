<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<!-- Popper JS -->
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/alertify.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/alertify.min.css"
	rel="stylesheet">
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
	<a href="index.jsp"><img src="resources/img/removebg-preview.png" alt="Logo"></a>
		<br> <br>
		<div class="innerOuter">
			<h2>회원가입</h2>
			<br>
			 <form action="insert.me" method="post">
            <div class="form-group">
                <div class="field-container">
                    <label for="enrollUserId">ID</label>
                    <input type="text" id="enrollUserId" name="userId" class="form-control">
                       <div id="checkResult" class="check-result"></div>
                </div>
                <div class="field-container">
                    <label for="enrollUserPwd">PASSWORD</label>
                    <input type="password" id="enrollUserPwd" name="userPwd" class="form-control">
                </div>
                <div class="field-container">
                    <label for="pwdCheck">PASSWORD CHECK</label>
                    <input type="password" id="pwdCheck" class="form-control">
                </div>
                <div class="field-container">
                    <label for="userName">NAME</label>
                    <input type="text" id="userName" name="userName" class="form-control">
                </div>
                <div class="field-container">
                    <label for="email">&nbsp; EMAIL</label>
                    <input type="email" id="email" name="email" class="form-control">
                    <div id="checkEmailResult" class="check-result"></div>
                </div>
                <div class="field-container">
                    <label for="age">&nbsp; AGE</label>
                    <input type="number" id="age" name="age" class="form-control">
                </div>
                <div class="field-container">
                    <label for="phone">&nbsp; PHONE</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="(-)없이 입력">
                </div>
                
                
               <div class="gender-container field-container">
                    <label for="">GENDER</label>
                    <label for="male">남자</label>
                    <input type="radio" id="male" value="M" name="gender" checked>
                    <label for="female">여자</label>
                    <input type="radio" id="female" value="F" name="gender">
                </div>
                
                
            </div>
            <div class="btns" align="center">
                <button type="submit" disabled>회원가입</button>
                <button type="reset">초기화</button>
            </div>
        </form>
			<script>
				$(function() {
					//사용자가 입력한 아이디가 중복인지 확인하는 작업 (비동기처리)
					//사용자가 키를 입력하면 이벤트 발생
					//중복인지 아닌지 확인하여 네이버에서 처럼 NNNNN 또는 NNNNY 로 응답데이터 돌려받기
					//돌려받은 응답데이터를 이용하여 result div에 사용 가능한 아이디입니다.
					//또는 사용불가능한 아이디입니다. 라는 텍스트를 담아 보여주기
					//이때 사용 가능하다면 회원가입 버튼이 활성화 되도록 작업하기
					//checkId() 메소드명 사용
					//아이디 입력 인풋상자 요소
					var inputId = $("#enrollUserId");
					var inputEmail = $("#email");
					inputId.keyup(function() {
						$.ajax({
							url : "checkId.me",
							data : {
								checkId : $(inputId).val()
							},
							success : function(result) {
								if (result == 'NNNNN') {//중복
									$("#checkResult").show();
									$("#checkResult").css("color", "red").text(
											"사용불가능한 아이디입니다.");
									//중복시 회원가입 버튼 비활성화
									$("button[type=submit]").attr("disabled",
											true);
								} else { //사용가능
									$("#checkResult").show();
									$("#checkResult").css("color", "green")
											.text("사용가능한 아이디입니다.");
									//사용가능시 회원가입 버튼 활성화
									$("button[type=submit]").attr("disabled",
											false);
								}
							},
							error : function() {
								console.log("통신 오류");
							}
						});
					});
					inputEmail.keyup(function() {
						$.ajax({
							url : "checkEmailExist.me",
							data : {
								checkEmail : $(inputEmail).val()
							},
							success : function(result) {
								if (result == 'NNNNN') {//중복
									$("#checkEmailResult").show();
									$("#checkEmailResult").css("color", "red")
											.text("사용불가능한 이메일입니다.");
									//중복시 회원가입 버튼 비활성화
									$("button[type=submit]").attr("disabled",
											true);
								} else { //사용가능
									$("#checkEmailResult").show();
									$("#checkEmailResult")
											.css("color", "green").text(
													"사용가능한 이메일입니다.");
									//사용가능시 회원가입 버튼 활성화
									$("button[type=submit]").attr("disabled",
											false);
								}
							},
							error : function() {
								console.log("통신 오류");
							}
						});
					});
				});
			</script>
		</div>
	
</body>
</html>