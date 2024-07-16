<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<div>
	
	<form action="profile.me" method="post" enctype="multipart/form-data">
		<div>
			
			<table border="1px solid #ddd">
				<thead>
					<tr><input type="text" id="userId" name="userId" value="${userId}" readonly></tr>
				</thead>
				<tbody>
				<tr>			
					<th>프로필 미리보기</th>
					<td>
					<input type="file" id="profile" name="profile" class="form-control" accept=".png, .jpeg, .jpg, .gif, .img, .bmg">
					</td>
				</tr>
				
				</tbody>	
			</table>
			
		</div>
		<script>
			$(function(){
				var userId="${userId}";
				console.log("유저 아이디 : "+userId);
			});
		</script>
		<div>
			<button type="submit">확인</button>
		</div>
	</form>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>