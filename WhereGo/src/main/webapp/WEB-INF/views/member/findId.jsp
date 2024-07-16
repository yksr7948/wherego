<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
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
    
    #checkId{
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
    #checkId:hover{
    	 background-color: black;
    color: white;
    }
    
</style>
<!-- Include jQuery library -->
<script src="https://cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/alertify.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/alertify.min.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
    function findIdByEmail() {
        var byEmail = $("#byEmail").val(); // Correctly fetch the value of email input
        
        $.ajax({
            url: "findId.me",
            type: "post", // Use colon ':' instead of equals '='
            data: {
                byEmail: byEmail
            },
            success: function(findId) {
                if (findId == null || findId.trim() === "") { // Check if findId is null or empty string
                	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"등록된 아이디가 없습니다.");
                } else if(findId.length>40){
                	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"소셜 로그인 회원입니다");
                }else{
                	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"회원님의 아이디는"+findId+"입니다");
                }
            },
            error: function() {
                console.log("통신 오류");
            }
        });
    }
</script>
</head>
<body>
    <div class="container">
        <a href="index.jsp"><img src="resources/img/removebg-preview.png" alt="Logo"></a>
        <h3>찾으시려는 아이디의 이메일 주소를 입력해주세요</h3>
        <input type="email" name="byEmail" id="byEmail" placeholder="abcd@example.com" required/>
        <button onclick="findIdByEmail()" id="checkId">확인</button>
    </div>
</body>
</html>
