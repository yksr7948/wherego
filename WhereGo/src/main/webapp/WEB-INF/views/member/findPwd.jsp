<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<style>
body {
    font-family: 'Arial', sans-serif;
    background-color: #f0f4f8;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
    flex-direction: column;
    text-align: center;
}

.container {
    background-color: #fff;
    padding: 40px;
    border-radius: 10px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    width: 300px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

img {
    max-width: 100%;
    height: auto;
}

h3 {
    color: #007bff;
    margin-bottom: 20px;
    font-size: 1.2em;
}

input[type="email"] {
    width: calc(100% - 20px);
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

input[type="text"], input[type="password"] {
    width: calc(100% - 20px);
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.certify, .password-change {
    width: 100%;
    display: flex;
    justify-content: space-between;
    margin-top: 2.4rem;
    padding: 0 1.6rem;
}
.certify {
    width: 100%;
    display: flex;
    justify-content: space-between;
    margin-top: 2.4rem; /* 상단 여백 조정 */
    padding: 0 1.6rem; /* 좌우 패딩 조정 */
}

.certify input {
    width: 3rem; /* 각 인풋의 너비를 줄이고 */
    height: 4rem;
    line-height: 4rem;
    font-size: 1.8rem;
    font-weight: 700;
    text-align: center;
    background-color: #f0f1f4;
    border-radius: .6rem;
     margin-right: 5px; /* 오른쪽 마진을 추가하여 각 입력란 사이에 공간을 만듭니다 */
}

.certify button {
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
     margin-left: 10px; /* 왼쪽 마진을 추가하여 버튼 앞에 공간을 만듭니다 */
}
.certify button:hover {
	background-color: black;
    color: white;
}
button{
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

button:hover{
	background-color: black;
    color: white;
}

.hidden {
    display: none;
}
.btn-hidden{
	display:none;
}
</style>
<!-- Include jQuery library -->
<script src="https://cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/alertify.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/alertify.min.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
function checkEmail() {
    var code1 = $("#code1").val();
    var code2 = $("#code2").val();
    var code3 = $("#code3").val();
    var code4 = $("#code4").val();
    
    var fullCode = code1 + code2 + code3 + code4;
    console.log(fullCode);
    
    $.ajax({
        url: "checkEmail.me",
        data: {
            fullCode: fullCode
        },
        success: function(result) {
            if (result > 0) {
            	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,"이메일 인증에 성공하셨습니다. 비밀번호를 변경해주세요!");
                $("#mailOn").hide();
                $("#btn").hide();
                $("#passwordChange").show();
            } else {
            	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,"이메일 인증 실패!! 이메일 인증을 재시도 해주세요.");
            }
        },
        error: function() {
            console.log("통신 오류");
        }
    });
} 

function sendEmail() {
    var userId = $("input[name=byUserId]").val();
    $.ajax({
        url: "sendEmail.me",
        data: {
            userId: userId
        },
        success: function(res) {
            if (res.status) {
            	
                $("#mailOn").show();
                $("#btn").show();
           
                alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,userId + " 회원님의 이메일로 인증번호를 전송했습니다.");
            } else {
            	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,"이메일로 인증번호 전송 실패했습니다.");
            }
        },
        error: function() {
            console.log("통신 오류");
        }
    });
}

function changePassword() {
    var newPassword = $("#newPassword").val();
    var userId = $("input[name=byUserId]").val();
    var confirmPassword = $("#confirmPassword").val();

    if (newPassword !== confirmPassword) {
    	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,"비밀번호가 일치하지 않습니다.");
    }else{
    	$.ajax({
			url : "changePwd.me",
			data : {
				newPassword: newPassword,
				userId : userId
			},
			success : function(result) {
				//console.log(result);
				if (result=="NNNNY") {
					alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,"비밀번호 변경완료!!");
					setTimeout(function() {
				        location.href = "nlogin.me";
				    }, 2000); 
				} else if(result=="NNNNN"){
					alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,"비밀번호 가 같지 않습니다!!");
				}else {
					alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,"비밀번호 변경실패!!");
				}
			},
			error : function() {
				console.log("통신 오류");
			}
		});
    }
}
</script>
</head>
<body>
    <div class="container">
        <a href="index.jsp"><img src="resources/img/removebg-preview.png" alt="Logo"></a>
        <h3>비밀번호를 찾고자하는 아이디를 입력해주세요.</h3>
        <input type="text" name="byUserId" id="byUserId" required />
        <button onclick="sendEmail()">이메일 보내기</button>

        <div class="certify hidden" id="mailOn">
            <input type="tel" maxlength="1" min="0" max="9" onlyNumber id="code1">
            <input type="tel" maxlength="1" min="0" max="9" onlyNumber id="code2">
            <input type="tel" maxlength="1" min="0" max="9" onlyNumber id="code3">
            <input type="tel" maxlength="1" min="0" max="9" onlyNumber id="code4">
        </div>
        <br>
           <button onclick="checkEmail()" id="btn" class="btn-hidden">확인</button>

        <div class="password-change hidden" id="passwordChange">
            <input type="password" placeholder="새 비밀번호" id="newPassword" />
            <input type="password" placeholder="새 비밀번호 확인" id="confirmPassword" />
            <br>
            <button onclick="changePassword()">비밀번호 변경</button>
        </div>
    </div>
    <script>
    $(function(){
        $(document).on("keypress keyup keydown", "input[onlyNumber]", function(e){
            if(/[a-z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g.test(this.value)){ // 한글 막기
                e.preventDefault();
                this.value = "";
            } else if (e.which != 8 && e.which != 0 // 영문 e 막기
                && (e.which < 48 || e.which > 57)    // 숫자키만 받기
                && (e.which < 96 || e.which > 105)){ // 텐키 받기
                e.preventDefault();
                this.value = "";
            } else if (this.value.length >= this.maxLength){ // 1자리 이상 입력되면 다음 input으로 이동시키기
                this.value = this.value.slice(0, this.maxLength);
                if($(this).next("input").length > 0){
                    $(this).next().focus();
                } else {
                    $(this).blur();
                }
            }
        });    
    });
    </script>
</body>
</html>
