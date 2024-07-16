<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=7whhnl24e7"></script>
<style>
.plan-container {
	width: 100%;
	margin: 0px auto;
	display: flex;
	min-height: 1080px;
	height: auto;
}

/* 일정(days) */
.days-box {
	width: 8%;
	box-sizing: border-box;
	background-color: #2C3E50;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}
.days-box-content {
	display: flex;
	flex-direction: column;
}
.days-box-title {
	height: 80px;
	color: white;
	text-align: center;
	font-size: 36px;
	font-weight: 900;
	border-bottom: 2px solid lightgray;
	display: flex;
	align-items: center;
	justify-content: center;
}
.day-box {
	height: 100px;
	color: white;
	text-align: center;
	font-size: 24px;
	font-weight: 900;
	border-bottom: 2px solid lightgray;
	cursor: pointer;
}
.day-box span {
	display: block;
	margin: 15px 0;
}
.fomat-date {
	font-size: 16px;
}

/* plan-box(플랜 목록) */
.day-plan-box {
	width: 15%;
	background-color: #f4f4f9;
	border: 2px solid lightgray;
}
.plans-box-title {
	height: 80px;
	color: white;
	text-align: center;
	font-size: 24px;
	font-weight: 900;
	display: flex;
	align-items: center;
	justify-content: center;
	background-color: rgba(0, 0, 0, 0.5);
}
.plan-box {
    position: relative; /* 상대 위치 설정 */
    text-align: center;
    justify-content: center;
    align-items: center;
    height: 200px;
    border-bottom: 2px solid lightgray;
    display: flex;
    flex-direction: column; /* 세로로 정렬 */
    padding-right: 30px; /* 삭제 버튼과 제목 사이의 간격을 주기 위해 오른쪽 패딩 추가 */
}
.plan-delete {
    position: absolute; /* 절대 위치 설정 */
    top: 10px; /* 상단에서 10px 떨어져 위치 */
    right: 10px; /* 우측에서 10px 떨어져 위치 */
    background-color: white;
    text-align: center;
    color: black;
    border: 2px solid black;
    border-radius: 50%; /* 원 모양으로 만들기 위해 반지름 지정 */
    font-size: 12px;
    font-weight: 900;
    cursor: pointer;
    transition: background-color 0.3s, color 0.3s;
    width: 15px; /* 버튼 크기 조정 */
    height: 15px; /* 버튼 크기 조정 */
    display: flex;
    justify-content: center;
    align-items: center;
}
.plan-delete:hover {
    background-color: black;
    color: white;
}
.plan-title {
	font-size: 24px;
	font-weight: 900;
}
.plan-box span {
	display: block;
	margin-bottom: 15px;
}
.plan-box input{
	width: 170px;
}

/* search-box(검색) */
.search-box {
	width: 22%;
	background-color: #f4f4f9;
	border: 2px solid lightgray;
}
.search-box input {
	width: 60%;
	height: 30px;
	border-radius: 5px;
	font-size: 16px;
}
.search-box button {
	margin-left: 10px;
	width: 80px;
	height: 30px;
	background-color: white;
	text-align: center;
	color: black;
	border: 2px solid black;
	border-radius: 5px;
	font-size: 16px;
	font-weight: 900;
	cursor: pointer;
	transition: background-color 0.3s, color 0.3s;
}
.search-box-list {
	border-bottom: 2px solid lightgray;
	min-height: 100px;
	display: flex;
	align-items: center;
	padding: 10px;
}
.search-box-list img {
	width: 12%;
}
.list-content {
	width: 80%;
	display: flex;
	flex-direction: column;
	text-align: center;
}
.list-title {
	font-size: 21px;
	font-weight: 900;
}
.list-addr {
	color: grey;
}
.search-box-list button {
	width: 8%;
	margin-left: auto;
	display: flex;
	justify-content: center;
	align-items: center;
}
.search-box-list button:hover {
	background-color: black;
	color: white;
}
/* search-box-pagingbar */
#pagingbar-area {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 20px 0;
}
#pagingbar-area a, #pagingbar-area span {
    margin: 0 5px;
    padding: 8px 12px;
    border: 2px solid black;  
    border-radius: 5px;
    color: black;
    transition: background-color 0.3s, color 0.3s;
}
#pagingbar-area span {
    background-color: black;
    color: white;
}
#pagingbar-area a:hover {
    background-color: white;
    color: black;
}

/* map(맵) */
.map-box {
	width: 55%;
	background-color: #f4f4f9;
}

/* 버튼 */
.save-button {
	display: flex;
	justify-content: center; padding : 10px;
	margin-left: -15px;
	margin-bottom: 50px;
	padding: 10px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	
	<!-- 플래너 작성 -->
	<div class="plan-container">
	
	<input type="hidden" name="userId" id="userId" value="${loginUser.userId}" />
	<input type="hidden" name="title" id="title" value="${planner.title}" />
	<input type="hidden" name="startDate" id="startDate" value="${planner.getStartDate()}" />
	<input type="hidden" name="endDate" id="endDate" value="${planner.getEndDate()}" />
	<input type="hidden" name="description" id="description" value="${planner.description}" />
	
        <!-- days div -->
        <div class="days-box">
            <div class="days-box-content">
                <div class="days-box-title">일정</div>
                
                <c:forEach items="${days }" var="day" varStatus="status">
	                <div class="day-box" onclick="planChange(${status.count})">
	                    <span>DAY${status.count }</span>
	                    <span class="fomat-date"><fmt:formatDate value="${day}" pattern="MM.dd (E)" /></span>
	                </div>
                </c:forEach> 
            </div>
        </div>

        <!-- days plan div -->
        <div class="day-plan-box">

	        	<c:forEach items="${days }" var="day" varStatus="status">
		            <div class="plans-box" data-date="<fmt:formatDate value="${day }" pattern="yyyy-MM-dd"/>">
		                <div class="plans-box-title">DAY${status.count } | <fmt:formatDate value="${day }" pattern="MM.dd E요일"/></div>
		            </div>
	        	</c:forEach>
        	
        </div>
        
        <!-- day-box 변경 -->        
       	<script>
      	var planslide =  document.querySelectorAll(".plans-box");

      	// 각 Day의 마커와 경로를 저장할 객체를 추가합니다.
	    var dayMarkers = {}; // 추가됨: 각 Day의 마커를 저장할 객체
	    var dayPaths = {};   // 추가됨: 각 Day의 경로를 저장할 객체
	    
	    planChange(1);
	      		
	    function planChange(n){
	        // 전환하기 전에 현재 마커와 경로를 저장합니다.
	        saveCurrentMarkersAndPaths(); // 추가됨: 현재 마커와 경로를 저장
	      	
	    	for(var i=1; i<=planslide.length; i++){
	    		planslide[i-1].style.display = "none";
	    	}
	    	planslide[n-1].style.display = "block";

	        // 선택한 Day의 마커와 경로를 불러옵니다.
	        loadMarkersAndPaths(n); // 추가됨: 선택한 Day의 마커와 경로를 불러옴
	    }

	    // 현재 마커와 경로를 저장하는 함수
	    function saveCurrentMarkersAndPaths() { // 추가됨: 현재 마커와 경로를 저장하는 함수
	        var currentDayIndex = getCurrentDayIndex();
	        if (currentDayIndex === -1) return;
	        
	        dayMarkers[currentDayIndex] = markers.slice();
	        dayPaths[currentDayIndex] = paths.slice();
	        
	        clearMarkersAndPaths();
	    }

	    // 특정 Day의 마커와 경로를 불러오는 함수
	    function loadMarkersAndPaths(dayIndex) { // 추가됨: 특정 Day의 마커와 경로를 불러오는 함수
	        if (dayMarkers[dayIndex]) {
	            markers = dayMarkers[dayIndex];
	            paths = dayPaths[dayIndex];

	            for (var i = 0; i < markers.length; i++) {
	                markers[i].setMap(map);
	            }

	            for (var i = 0; i < paths.length; i++) {
	                paths[i].setMap(map);
	            }

	            // 해당 Day의 첫 번째 마커가 있는 위치로 지도를 이동합니다.
	            if (markers.length > 0) {
	                map.setCenter(markers[0].getPosition()); // 추가됨: 첫 번째 마커 위치로 지도 중심 이동
	            }
	        }
	    }

	    // 현재 활성화된 Day 인덱스를 얻는 함수
	    function getCurrentDayIndex() { // 추가됨: 현재 활성화된 Day 인덱스를 얻는 함수
	        for (var i = 0; i < planslide.length; i++) {
	            if (planslide[i].style.display === "block") {
	                return i + 1;
	            }
	        }
	        return -1;
	    }

	    // 모든 마커와 경로를 초기화하는 함수
	    function clearMarkersAndPaths() { // 추가됨: 모든 마커와 경로를 초기화하는 함수
	        for (var i = 0; i < markers.length; i++) {
	            markers[i].setMap(null);
	        }
	        for (var i = 0; i < paths.length; i++) {
	            paths[i].setMap(null);
	        }
	        markers = [];
	        paths = [];
	    }
		</script>
		
        <!-- search-box -->
        <div class="search-box">
            <div class="days-box-title">
                <input type="text" id="plan-keyword" size="15"  value="이태원">
                <button type="button" onclick="searchPlace();">검색</button>
            </div>
            
            <!-- 검색 리스트 영역 -->
            <div id="list-area"></div>
            
            <!-- 페이징바 영역 -->
            <div id="pagingbar-area"></div>
        </div>
        
        <!-- search js --> 
        <script>
        $(document).ready(function() {
            searchPlace(1);
        });
        
	        var markers = [];
	        var paths = [];
            
	        //검색 기능
        	function searchPlace(pageNumber){
	        	if(pageNumber == null){	        		
	        		pageNumber = 1;
	        	}
        		
        		$(".search-box-list").remove();
        		
        		$.ajax({
        			url : "searchPlace.pl",
        			data : {
        				keyword : $("#plan-keyword").val(),
        				pageNo: pageNumber
        			},
        			success : function(list){
        				
	        			var items = list.response.body.items.item;	
	        			
	        			var totalCount = list.response.body.totalCount;
	        			
	        			var str = "";
	        			
        				for(var i=0;i<items.length;i++){
        					
        					var item = items[i];
        					var itemStr = JSON.stringify(item);
        					
        					str += "<div class='search-box-list'>"
        						+ "<img src='resources/img/plan/location-icon.png'>"
        						+ "<span class='list-content'>"
        						+ "<span class='list-title'>"+item.title+"</span>"
        						+ "<span class='list-addr'>"+item.addr1+item.addr2+"</span>"
        						+ "</span>"
        						+ "<button class='add-plan-button' data-item='" + itemStr + "'>+</button>"
        						+ "</div>";
        				}
 						$("#list-area").html(str);	
 						
 						//페이징 처리
 						updatePagingBar(totalCount/9, pageNumber);
 						
 			        	$(".add-plan-button").on("click",function(){
 			        		var item = $(this).data("item");
 			        		addPlan(item);
 			        	});
        			},
        			error : function(xhr, status, error){
        				console.error('Error fetching data:', error);
        			}
        		});
        	}
	        
	        //페이징 바 처리
	        function updatePagingBar(totalPages, currentPage) {
			    
	        	var pagingBarHtml = '';
			    
			    //현재 페이지 그룹
			    var currentGroup = Math.ceil(currentPage / 5);
			    
			    // 첫 번째 페이지 그룹의 첫 페이지 번호
			    var startPage = (currentGroup - 1) * 5 + 1;
			    
			 	// 마지막 페이지 그룹의 마지막 페이지 번호
			    var endPage = Math.min(startPage + 4, totalPages);
			    
			    // 이전 그룹 버튼
			    if (currentGroup > 1) {
			        pagingBarHtml += '<a href="#" onclick="searchPlace(' + ((currentGroup - 2) * 5 + 1) + ')">Prev</a>';
			    }
			    
			    // 페이지 번호 생성
			    for (var i = startPage; i <= endPage; i++) {
			        if (i === currentPage) {
			            pagingBarHtml += '<span>' + i + '</span>';
			        } else {
			            pagingBarHtml += '<a href="#" onclick="searchPlace(' + i + ')">' + i + '</a>';
			        }
			    }

			    // 다음 그룹 버튼
			    if (endPage < totalPages) {
			        pagingBarHtml += '<a href="#" onclick="searchPlace(' + (endPage + 1) + ')">Next</a>';
			    }
			    
			    $('#pagingbar-area').html(pagingBarHtml);  // 페이징 바를 업데이트합니다
			}
        	
	        // +버튼 누를시 
        	function addPlan(item){
        		
        		 var parent =  $('.plans-box[style*="display: block"]');
        	     var data_date = parent.attr('data-date');
        	     var num = parent.children().length; // 하위 엘리먼트기에 일정 - 제목 (DAY) 부분도 포함됨
        	     
        	     var latlng = new naver.maps.LatLng(item.mapy, item.mapx);
                 var marker = new naver.maps.Marker({
                     position: latlng,
                     map: map,
                     title: item.title // 타이틀 추가
                 });
                 
                 markers.push(marker);
                 map.setCenter(latlng);
                 
              // 마커 사이에 선 긋기
                 if (markers.length > 1) {
                     var path = new naver.maps.Polyline({
                         map: map,
                         path: [markers[markers.length - 2].getPosition(), marker.getPosition()],
                         strokeColor: '#5347AA',
                         strokeWeight: 2
                     });
                     paths.push(path);
                 }
		
        	    if(num<6){ // 일정은 5개까지만 추가 가능
        	        parent.append(getHtml(item.title, item.mapx, item.mapy, num, data_date, item.firstimage));
        	    }else{
        	    	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"한번에 5개의 관광지를 선택 할 수 있습니다.");
        	    }
        	}
        	
        	//일정 추가 div
        	function getHtml(title, mapx, mapy, num, data_date, img){
        	   
        		var div = '<div class="plan-box" data-date="'+data_date+'"data-y="'+mapy+'"data-x="'+mapx+'"data-place="'+title+'"data-planNo="">';
	        		div += '<button class="plan-delete" onclick="planDelete(' + (num - 1) +  ')">&times;</button>'; // 변경: num 대신 (num - 1) 사용
	        		div += '<span class="plan-title">' + num + ". "+ title + '</span>';
	        		div += '<span>시간 : <input class="plan-time" type="time"></span>';
	        		div += '<span>메모 : <input class="plan-intro" type="text"></span>';
	        		div += '<input type="hidden" name="firstimage" class="firstImage" value="'+img+'">';
	        		div += '</div>';

        	    return div;
        	}
        	
        	// x버튼 눌렀을 때 플랜 삭제 및 마커 제거
        	function planDelete(index){
        	    var parent =  $('.plans-box[style*="display: block"]');
        	    var kid = parent.children().eq(index + 1); // 일정 부분에 제목도 자식에 포함되기에 index +1
        	    var next_kids = kid.nextAll();

        	    // 마커 제거
        	    var marker = markers[index];
        	    if (marker) {
        	        marker.setMap(null);
        	        markers.splice(index, 1);
        	    }

        		// 경로 제거
        	    if (index > 0 && paths[index - 1]) {
        	        paths[index - 1].setMap(null);
        	        paths.splice(index - 1, 1);
        	    }
        	    if (index < markers.length - 1 && paths[index]) {
        	        paths[index].setMap(null);
        	        paths.splice(index, 1);
        	    }

        	    kid.detach();

        	    next_kids.each(function (idx, element){
        	        var titleSpan = $(this).find('.plan-title');
        	        var title = titleSpan.text().replace(/^\d+\./, '');
        	        titleSpan.text((index + idx + 1) + '. ' + title);
        	        
        	        var btn = "planDelete(" + (index + idx) + ")";
        	        $(this).find('button').attr("onclick", btn);
        	    });

        	    resetPaths();
        	}
        	
        	// 경로 재설정
        	function resetPaths() {
        	    paths.forEach(function (path) {
        	        path.setMap(null);
        	    });

        	    paths = [];
        	    for (var i = 1; i < markers.length; i++) {
        	        var path = new naver.maps.Polyline({
        	            map: map,
        	            path: [markers[i - 1].getPosition(), markers[i].getPosition()],
        	            strokeColor: '#5347AA',
        	            strokeWeight: 2
        	        });
        	        paths.push(path);
        	    }
        	}
        </script>
        
        

         <!-- map -->
        <div class="map-box" id="plan-map">
            
        </div>
        
	    <!-- map api -->
	    <script>
	    
		var map = new naver.maps.Map('plan-map', {
		    center: new naver.maps.LatLng(37.5536472, 126.9678003),
		    zoom: 15
		});
        
	    </script>
    </div>
    
    <br> <br> <br> 
    
    <!-- button -->
    <div class="save-button">
		<button class="login-button" id="save-btn">저장</button>
		<button class="login-button" onclick="history.back()">취소</button>
	</div>
    
    <!-- button js -->
	<script>
		$(function(){
			
			//저장 버튼 클릭 js
			$("#save-btn").click(function() {
                var isValid = true;
                
                $('.plans-box').each(function (i){
                    if($(this).children().length < 2){
                    	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"각 여행일에는 최소 1개의 일정을 추가해주세요.");
                        isValid = false;
                        return false;
                    }
                });
                
                $('.plan-box').each(function (i){
                    if($(this).find('.plan-time').val() == ""){
                    	alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"시간은 필수 입력 항목입니다.");
                        isValid = false;
                        return false;
                    }
                });
                
                var planner = {
                	userId : $("#userId").val(),
                	title : $("#title").val(),
                	startDate : $("#startDate").val(),
                	endDate : $("#endDate").val(),
                	description : $("#description").val()
                };
                
                //플랜들 담을 배열 준비
                var planList = new Array();
                
                if(isValid == true){
                	
                	$('.plan-box').each(function (i){
                        // 플랜 1개의 데이터
                        var plan = {
                            day : $(this).attr("data-date"),
                            time : $(this).find('.plan-time').val(),
                            name : $(this).attr("data-place"),
                            intro : $(this).find('.plan-intro').val(),
                            mapx : $(this).attr("data-x"),
                            mapy : $(this).attr("data-y"),
                            firstImage : $(this).find(".firstImage").val()
                        };
                        
					planList.push(plan);
               		});

                	// Plan 배열, Planner 데이터 묶기
                    var toData = {
                        planList : planList,
                        planner : planner
                    };
                	
                	$.ajax({
                		url : "savePlanner.pl",
                		contentType: "application/json",
                		data: JSON.stringify(toData),
                		type: "POST",
                		success : function(result){
                			
                			alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"저장되었습니다.",function(){
                				location.href = "planner.pl?userId="+$("#userId").val();
                			});
                		},
                		error : function(data){
                			console.log(data.responseText);
                		}
                	});
                }
			});
		});
	</script>
      
	
	
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
