<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>열차 테스트</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<style>
main {
    padding: 20px;
    width: 85%;
    margin: auto;
    margin-top: 5%;
}
select{
	height:30px;
}
.detail-area{
border:1px solid black;
width: 49%;
height:250px;
margin:auto;
display:inline-block;
overflow:visible auto;
}
.detail-title{
border-top:1px solid black;
border-left:1px solid black;
border-right:1px solid black;
background-color:azure;
text-align:center;
width:49%;
height:40px;
margin:auto;
display:inline-block;
}

.station{
	border: 2px solid #333;
    padding: 10px 10px;
    border-radius: 5px;
    font-size: 12px;
    margin-right: 5px;
    margin-bottom:5px;
    width:105px;
	background-color:lightblue;
	color:black;
}
.station-select{
background-color:dodgerblue;
color:white;
}
.area{
	width:150px;
	height:30px;
}
.trainResult{
	border:1px solid black;
	padding : 10px 10px;
	margin-top : 5px;
	border-radius: 8px;
	background-color:white;
}
.train,.time,.traingrade{
	display:flex;
}
.train,.traingrade{
		border:1px solid green;
}
.train{
	width:18%;
	height:55px;
	justify-content:center;
	text-align:center;
	flex: 0 1 auto;
}
.time{
	justify-content: flex-start;
	align-items:flex-start;
}
.traingrade{
	justify-content: center;
	flex-direction: column;
	align-items:flex-end;
	background-color:beige;
	margin-top:3px;
}
.trainimg{
	margin-left:auto;
	float:right;
	align-items:flex-end;
}
.paging{
	width:50px;
	height:50px;
	margin:5px 5px;
	border-radius:5px;
}
.paging-select{
	background-color:#333;
	color:#fff;
	font-weight:800;
}
#departDate{
	width:150px;
	height:30px;
}
#depdetail,#arrdetail{
	width:100%;
	text-align:center;
	margin-left:auto;
	margin-right:auto;
	margin-top:5px;
}
#stationroute{
	font-size:28px;
	font-weight:900;
	display:none;
}
#search{
	margin:5px 5px;
	width:120px;
	height:40px;
}
#searchResult{
	width:80%;	
}
#depTime{
	background-color:skyblue;
}
#arrTime{
	background-color:sandybrown;
}
#charge{
	margin:auto;
	font-size:24px;
	font-weight:900;
	text-align:right;
}



#loadingContainer {
            display: flex;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.5s ease;
        }
        #loadingContainer.show {
            opacity: 1;
            pointer-events: auto;
        }
        #loadingAnimation {
            width: 500px;
            height: 500px;
            background-repeat: no-repeat;
            background-size: contain;
            transition: background-image 0.5s ease;
        }
</style>
</head>
<body>
	<%@ include file="../common/header.jsp" %>
	<main>
	<h1>#열차시간표</h1>

	
	
	<div>
		<div class="detail-title">
		<span style="font-size:22px; font-weight:900">출발역 목록 - </span> <select class="area" id="depselect"></select>
		</div>
		<div class="detail-title">
		<span style="font-size:22px; font-weight:900">도착역 목록 - </span> <select class="area" id="arrselect"></select>
		</div>
	<div class="detail-area">
	<table id="depdetail">
	
	</table>
	</div>
	<div class="detail-area">

	<table id="arrdetail">
	
	</table>
	</div>
	
	</div>
	날짜 : <input type="date" id="departDate">
	열차 종류 : 
		<select id="trainselect">
		<option value="0">전체</option>
		<option value="00">KTX</option>
		<option value="01">새마을호</option>
		<option value="02">무궁화호</option>
		</select>
	<br>
	<button id="search" class="btn btn-primary">조회하기</button><br>
	<div id="stationroute">
	<span id="departinfo"></span><span id="arriveinfo"></span>
	<span id="depart"></span>역 >>> <span id="arrive"></span>역
	</div>
	<div id="searchResult">
	
	</div>
	<div id="paging-bar">
	
	</div>
	</main>
	<!-- 로딩 애니메이션 -->
    <div id="loadingContainer">
        <div id="loadingAnimation"></div>
    </div>
	<script>
	$(function(){
		getArea();
		
		function getArea(){
			$.ajax({
				url : "getArea.tr",
				data : {},
				success : function(result){
					var str="<option value='0'>지역 선택</option>";
					for(var i=0;i<result.length;i++){
						str += "<option value='"+result[i].cityCode+"'>"+result[i].city+"</option>";
					}
					$(".area").html(str);
				},
				error : function(){
					console.log("정보 못가져옴");
				}
			})
		};
		$(".area").on("change", function(){
			var id=$(this).prop("id");
			var area=$(this).val();
			showLoading();
			$.ajax({
				url : "areadetail.tr",
				data : {
					area : area
				},
				success : function(result){
					var items=$(result).find('item');
					str="<tr>";
					if(id=="depselect"){
					items.each(function(index,item){
						str +="<td><button class='station' name='depstation' value='"+$(item).find('nodeid').text()+"'>"+$(item).find('nodename').text()+"</button></td>"						
						if((index+1)%5==0){
							str +="</tr><tr>";
						} 
					});
					str +="</tr>"
					$("#depdetail").html(str);
					} else if(id=="arrselect") {
					items.each(function(index,item){
						str +="<td><button class='station' name='arrstation' value='"+$(item).find('nodeid').text()+"'>"+$(item).find('nodename').text()+"</button></td>"						
						if((index+1)%5==0){
							str +="</tr><tr>";
						}
					});
					str +="</tr>"
					$("#arrdetail").html(str);
					}
					
				},
				error : function(){
					console.log("확인불가");
				},
				complete : function(){
					hideLoading();
				}
			}); 
		});
		
		function searchTrain(pageNumber){
			if(pageNumber==null){
				pageNumber=1;
			}
			var train=$("#trainselect").val();
			var depart=$("#departid").val();
			var arrive=$("#arriveid").val();
			var date=$("#departDate").val();
			if(depart==arrive || depart==null || arrive==null) {
				alert("출발지와 목적지가 제대로 선택되지 않았습니다.");
			} else if(date==""){
				alert("날짜가 선택되지 않았습니다.");
			} else {
				showLoading();
				$.ajax({
					url : "traintest.tr",
					data : {
						departDate : date,
						departNo : depart,
						arriveNo : arrive,
						trainNo : train,
						pageNo : pageNumber
					},
					success : function(result){
						var count=$(result).find('totalCount').text();
						if(count=="0"){
							alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">' ,"검색된 결과가 없습니다.");
						} else {
						$("#depart").text($("#departid").prop("name"));
						$("#arrive").text($("#arriveid").prop("name"));
						var str="";
						var items=$(result).find('item');
						items.each(function(index,item){
							var date=new Date();
							var dep=$(item).find('depplandtime').text();
							var arr=$(item).find('arrplandtime').text();
							var depDate=new Date(dep.substring(0,4),
												(parseInt(dep.substring(4,6))-1),
												 dep.substring(6,8),
												 dep.substring(8,10),
												 dep.substring(10,12));
							var arrDate=new Date(arr.substring(0,4),
												(parseInt(arr.substring(4,6))-1),
									 			arr.substring(6,8),
									 			arr.substring(8,10),
									 			arr.substring(10,12));						
							var travelMin=depDate.getInterval(arrDate);
							var travelHour=(Math.floor(travelMin/60));
							travelMin=travelMin-(travelHour*60);
							if(travelHour=="0"){
								var travelTime=travelMin+"분";
							} else {
								var travelTime=travelHour+"시간 "+travelMin+"분";
							}
							var trainname="";
							switch($(item).find('traingradename').text().substring(0,3)){
							case "KTX": trainname="KTX"; break;
							case "새마을": trainname="Newtown"; break;
							case "무궁화": trainname="muguonghwa"; break;
							default: trainname="default"; break;
							}
							
							var dTime=dep.substring(8,10)+"시 "+dep.substring(10,12)+"분";
							var aTime=arr.substring(8,10)+"시 "+arr.substring(10,12)+"분";
							str +="<li class='trainResult'>"
								+"<div class='time'>"
								+"<div class='train' id='depTime'>"+dTime+"<br>"+$(item).find('depplacename').text()+"</div>"
								+"<div class='train'> → "+travelTime+" → </div>"
								+"<div class='train' id='arrTime'>"+aTime+"<br>"+$(item).find('arrplacename').text()+"</div>"
								+"<div class='train' id='charge' style='border:0'>"+$(item).find('adultcharge').text()+"원</div>"
								+"<div class='train trainimg' style='border:0'><img src='resources/img/train/train-"+trainname+".png' width='100%' height='55' alt='기차'></div>"
								+"</div>"
								+"<div class='traingrade'>"+$(item).find('traingradename').text()+" "+$(item).find('trainno').text()+"호</div>"
								+"</li>";
						});
						$("#searchResult").html(str);
						
						$("#stationroute").show();
						
						//페이징 처리
 						updatePagingBar(count, pageNumber);
					}},
					error : function(){
						console.log("실행실패");
					},
					complete : function(){
						hideLoading();
					}
				});
			}
		}
		
		//페이징 바 처리
        function updatePagingBar(totalPages, currentPage) {
		    
        	var pagingBarHtml = '';
		    var startPage =1;

		    var endPage = Math.floor((totalPages/50)+1);

		    for (var i = startPage; i <= endPage; i++) {
		        if (i == currentPage) {
		            pagingBarHtml += '<button class="paging paging-select" disabled>' + i + '</button>';
		        } else {
		            pagingBarHtml += '<button class="paging">' + i + '</button>';
		        }
		    }

			$('#paging-bar').html(pagingBarHtml);   // 페이징 바를 업데이트합니다
		}

		
		$("#search").click(function(){
			searchTrain(1);
		});
		
		$(document).on("click","button[class=paging]",function(){
			searchTrain($(this).text());
			window.scrollTo({ top: 0 }); 
		});
		
		$(document).on("click","button[class=station]",function(){
			var station=$(this).prop("name");
			var id=$(this).val();
			var name=$(this).text();
			var str="";
			if(station=="depstation"){
				str +="<input type='hidden' id='departid' name='"+name+"' value='"+id+"'>";
				$("#departinfo").html(str);
				$("#depdetail button").removeClass("station-select");
				$(this).addClass("station-select");
			} else {
				str +="<input type='hidden' id='arriveid' name='"+name+"' value='"+id+"'>";
				$("#arriveinfo").html(str);
				$("#arrdetail button").removeClass("station-select");
				$(this).addClass("station-select");
			}
			
		});
		
		Date.prototype.getInterval = function (otherDate) {
			    var interval;
			 
			    if(this > otherDate)
			        interval = this.getTime() - otherDate.getTime();
			    else
			        interval = otherDate.getTime() - this.getTime();
			 
			    return Math.floor(interval / (1000*60));
			}
		
		function formatDate(date) {
		    let d = new Date(date),
		        month = '' + (d.getMonth() + 1),
		        day = '' + d.getDate(),
		        year = d.getFullYear();

		    if (month.length < 2) month = '0' + month;
		    if (day.length < 2) day = '0' + day;

		    return [year, month, day].join('-');
		}

		const today = new Date();
		const maxDate = new Date();
		maxDate.setDate(today.getDate() + 6);
		
		$("#departDate").attr("value",formatDate(today));
		$("#departDate").attr("min",formatDate(today));
		$("#departDate").attr("max",formatDate(maxDate));
		
		//로딩창 구현 메소드
		var loadingInterval;
        var loadingVisible = false;

        function showLoading() {
            var loadingContainer = document.getElementById('loadingContainer');
            loadingContainer.classList.add('show');
            var loadingAnimation = document.getElementById('loadingAnimation');
            var imageIndex = 1;

            loadingInterval = setInterval(function() {
                imageIndex = (imageIndex % 5) + 1;
                loadingAnimation.style.backgroundImage = 'url("<c:url value="/resources/image/loading/load' + imageIndex + '.png" />")';
            }, 250);
            loadingVisible = true;
        }

        function hideLoading() {
            var loadingContainer = document.getElementById('loadingContainer');
            loadingContainer.classList.remove('show');
            clearInterval(loadingInterval);
            loadingVisible = false;
        }

	});
	</script>
	<%@ include file="../common/footer.jsp" %>
</body>
</html>