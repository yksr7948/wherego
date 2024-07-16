<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Document</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<style>
.content {
	background-color: rgb(247, 245, 245);
	width: 80%;
	margin: auto;
}

.innerOuter {
	border: 1px solid lightgray;
	width: 80%;
	margin: auto;
	padding: 5% 10%;
	background-color: white;
}

table * {
	margin: 5px;
}

table {
	width: 100%;
}
</style>
</head>
<body>

	<%@include file="../common/header.jsp"%>
	<div class="content">
		<br> <br>
		<div class="innerOuter">
			<h2>리뷰</h2><h4>지역 - ${rv.country}</h4>
			<br> <a class="btn btn-secondary" style="float: right;" onclick="history.back()">목록으로</a>
			<br> <br>
			<table id="contentArea" align="center" class="table">
				<tr>
					<th width="100">제목</th>
					<td colspan="3">${rv.boardTitle }</td>
				</tr>
				<tr>
					<th>작성자</th>
					<td>${rv.boardWriter}</td>
					<th>작성일</th>
					<td><fmt:formatDate value="${rv.boardDate}" pattern="yyyy년 MM월 dd일 HH시 mm분" /></td>
				</tr>
				
				<tr>
					<th>내용</th>
					<td colspan="3"></td>
				</tr>
				<tr>
					<td colspan="4"><p style="height: 150px;">${rv.boardContent}</p></td>
				</tr>
			</table>
			<br>

			<div align="center">
				<!-- 수정하기, 삭제하기 버튼은 이 글이 본인이 작성한 글일 경우에만 보여져야 함 -->
				<c:if test="${loginUser.userName eq rv.boardWriter}">
					<a class="btn btn-primary" href="update.bo?boardNo=${rv.boardNo}">수정하기</a>
					<button type="button" class="btn btn-danger" id="deleteBtn">삭제하기</button>
				</c:if>
			</div>
			<br> <br>

			<script>
				function formatDate(datetime) {
		            const dateObj = new Date(datetime);
		 
		            let month = dateObj.getMonth() + 1;
		            let day = dateObj.getDate();
		            (month < 10) ? month = '0' + month: month;
		            (day < 10) ? day = '0' + day: day;
		            return month + "/" + day;
		        }
            	$(function(){
            		$("#deleteBtn").click(function(){
            			//form,input 태그 생성
            			if(confirm("정말로 삭제하시겠습니까? 삭제할 경우 복구되지 않습니다.")==true){
            			var formObj = $("<form>");
            			var inputObj = $("<input>"); 
            			var filePath = $("<input>");
            			formObj.prop("action","delete.bo").prop("method","post");
            			inputObj.prop("type","hidden").prop("name","boardNo").prop("value","${rv.boardNo}");
            			filePath.prop("type","hidden").prop("name","filePath").prop("value","${rv.boardImg}");
            			var obj = formObj.append(inputObj).append(filePath);
            			$("body").append(obj);
            			obj.submit();
            			}else{return false;}
            		});
            	});
            	$(function(){
            		replyList();
                	$("#replyArea button").click(function(){
                		$.ajax({
                			url : "insertReply.bo",
                			type : "post",
                			data : {
                				replyBno : ${rv.boardNo},
                				replyWriter : "${loginUser.userName}",
                				replyContent : $("#content").val(),
                			},
                			success : function(result){
                				//dml구문 실행 후 처리된 행 수
                				
                				if(result>0){//성공
                					alert("댓글작성 성공!");
                					replyList(); //추가된 댓글정보까지 다시 조회
                					$("#content").val("");
                				}else{
                					alert("댓글작성 실패!");
                				}
                			},
                			error : function(){
                				console.log("통신오류");
                			}
                		});
                	});
            	});
            	function replyList(){
            		$.ajax({
            			url : "replyList.bo",
            			data : {
            				boardNo : ${rv.boardNo}
            			},
            			success : function(result){
            				var str = "";
            				for(var i in result){
            					str += "<tr>"
            						+"<th>"+result[i].replyWriter+"</th>"
            						+"<td>"+result[i].replyContent+"</td>"
            						+"<td>"+formatDate(result[i].replyDate)+"</td>"
            						+"</tr>";
            				}
            				//만들어준 댓글목록 문자열 넣어주기 
            				$("#replyArea tbody").html(str);
            				//댓글 개수 넣기
            				$("#rcount").text(result.length);
            				
            			},
            			error : function(){
            				console.log("통신오류");
            			}
            		});
            	}
            </script>
			<table id="replyArea" class="table" align="center">
				<thead>
					<c:choose>
						<c:when test="${empty loginUser }">
								<th colspan="2"><textarea class="form-control" cols="55"
										rows="2" style="resize: none; width: 100%;" readonly>로그인 후 이용해주세요.</textarea>
								</th>
							</tr>
						</c:when>
						<c:otherwise>
							<tr>
								<th colspan="2"><textarea class="form-control" id="content"
										cols="55" rows="2" style="resize: none; width: 100%;"></textarea>
								</th>
								<th style="vertical-align: middle"><button
										class="btn btn-secondary">등록하기</button></th>
							</tr>
						</c:otherwise>
					</c:choose>
					<tr>
						<td colspan="3">댓글(<span id="rcount"></span>)
						</td>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
		<br> <br>
	</div>
	<jsp:include page="../common/footer.jsp" />

</body>
</html>