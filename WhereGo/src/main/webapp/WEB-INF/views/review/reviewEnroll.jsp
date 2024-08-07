<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
	<style>
        .content {
            background-color:rgb(247, 245, 245);
            width:80%;
            margin:auto;
        }
        .innerOuter {
            border:1px solid lightgray;
            width:80%;
            margin:auto;
            padding:5% 10%;
            background-color:white;
        }

        #enrollForm>table {width:100%;}
        #enrollForm>table * {margin:5px;}
    </style>
</head>
<body>
  <jsp:include page="../common/header.jsp" />

    <div class="content">
        <br><br>
        <div class="innerOuter">
            <h2>게시글 작성하기</h2>
            <br>

            <form id="enrollForm" method="post" action="insert.bo" enctype="multipart/form-data">
                <table align="center">
                    <tr>
                        <th><label for="title">제목</label></th>
                        <td><input type="text" id="title" class="form-control" name="boardTitle" required></td>
                    </tr>
                    <tr>
                        <th><label for="writer">작성자</label></th>
                        <td><input type="text" id="writer" class="form-control" value="${loginUser.userName}" name="boardWriter" readonly></td>
                    </tr>
                    <tr>
                        <th><label for="country">지역</label></th>
                        <td>
                        	<select class="mycountry" name="country">
                        		<option value="서울">서울</option>
								<option value="인천">인천</option>
								<option value="대전">대전</option>
								<option value="대구">대구</option>
								<option value="광주">광주</option>
								<option value="부산">부산</option>
								<option value="울산">울산</option>
								<option value="경기">경기</option>
								<option value="강원">강원</option>
								<option value="제주">제주</option>
                        	</select>
                        </td>
                    </tr>
                    <tr>
                        <th><label for="content">내용</label></th>
                        <td><textarea id="content" name="boardContent"></textarea></div></td>
                    </tr>
                </table>
                <br>

                <div align="center">
                    <button type="submit" class="btn btn-primary">작성</button>
                    <button type="reset" class="btn btn-danger">취소</button>
                </div>
            </form>
        </div>
        <br><br>
</div>
<jsp:include page="../common/footer.jsp" />
	
<script>
	$(document).ready(function() {
	    $('#content').summernote({
	        height: 300,
	        minHeight: null, 
	        maxHeight: null, 
	        focus: true 
	    });
	});
</script>  
</body>
</html>