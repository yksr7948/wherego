<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색페이지</title>
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=r0j6vqaf5j"></script>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<style>
main {
    padding: 10px;
    width: 80%;
    margin: auto;
    margin-top: 2%;
}
.card-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: left;
    padding: 20px;
}
.card {
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    overflow: hidden;
    width: 300px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    transition: transform 0.2s;
    flex: 0 0 calc(25% - 20px);
    box-sizing: border-box;
}

.card:hover {
    transform: scale(1.05);
    cursor: pointer;
}

.card>img {
    width: 100%;
    height: 200px;
    object-fit: cover;
}

.card-content {
    padding: 15px;
}

.card-content h2 {
    margin: 0 0 10px;
    font-size: 18px;
}

.card-content p {
    margin: 0;
    color: #555;
    font-size: 11px;
}
/* 지도 */
#map-container{
	position:relative;
	width:90%;
	display: flex;
	margin:auto;
	justify-content: left;
}
#map{
	width: 65%;
	height: 400px;
}
#map-marker-info{
	width:35%;
	height:400px;
	background-color:azure;
	overflow:auto;
	padding-top: 15px;
}
.markertitle{
	padding:5px;
	display:block;
	width:100%;
}
.markerdetail{
	display:none;
	transition:0.3s;
}
.locationDetail {
    margin-top: 5px;
    margin-left: 5px;
    text-align: center;
    font-weight:900;
    background-color: #333;
    color: #fff;
    text-decoration: none;
    border-radius: 5px;
}
.locationDetail:hover{
    background-color: #fff;
    color: #333;
}
.hr{
	border:1px solid lightgrey;
	margin-top:5px;
	margin-bottom:5px;
}
/* 게시판 */
.review-search{
	width:60%;
	align:left;
	padding:10px;
	margin-left:10px;
	margin-bottom:10px;
	cursor:pointer;
	background-color:azure;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}
.review-title{
	font-weight:900;
	font-size:24px;
}
.review-title:hover{
	text-decoration:underline;
}
.review-content{
	display:block;
	font-size:16px;
	height:45px;
	display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
	overflow:hidden;
	text-overflow:ellipsis;
}
</style>
</head>
<body>
	<%@ include file="header.jsp" %>
	<main>
	<div>
	<h1>${keyword }에 대한 검색 결과입니다.</h1>
	<div class="search-area">
		<div id="trip-search">
		<h3 class="">#여행지</h3>
		<c:if test="${empty tList }">
			${keyword }와 관련된 여행지를 찾지 못했습니다.
		</c:if>
		<div class="card-container">
			<c:forEach items="${tList }" var="t" end="3">		
			<div class="card">
				<input type="hidden" value="${t.contentId }">
				<img src="${t.firstImage2 }" alt="">
				<div class="card-content">
					<h2>${t.title }</h2>
					<p>${t.addr1 }</p>
					<br>
					<p><img src="resources/img/trip-board/eye-icon.png"> ${t.count} &nbsp;
					   <img src="resources/img/trip-board/heart-icon.png"> ${t.likeCount}</p>
				</div>
			</div>
			
			</c:forEach>
			
		</div>
		<c:if test="${!empty tList }">
		<a href="searchDetail.wherego?keyword=${keyword }" class="btn btn-info">${keyword }(으)로 검색된 여행지 모두 보기</a>
		</c:if>	
		<span></span>
		</div>
		<hr>
		<div id="map-search">
		<h3>#지도</h3>
		 <!-- 지도 API -->  
    	<div id="map-container">
	    	<div id="map"></div>
	    	<div id="map-marker-info">
	    	<h4 style="text-align:center;">여행지 목록</h4>
	    	<div class='hr'></div>
	    	</div>
    	</div>
    	
    	<!-- 지도 API -->
    	<script>
    	 var mapX = ${mapX};
         var mapY = ${mapY};
         var keyword = '${keyword}';

         var mapOptions = {
             center: new naver.maps.LatLng(mapY, mapX),
             zoom: 14  
         };

         var map = new naver.maps.Map('map', mapOptions);


         var touristData = '${touristData}';
         var markers = [];
         
         var markerInfo="";

         if (touristData) {
             try {
                 var parsedData = JSON.parse(touristData);
                 var items = parsedData.response.body.items.item;

                 if (items && items.length) {
                 	//검색어와 정확히 일치하는 관광지가 딱 하나
                     var matchedItem = items.find(function(location) {
                         return location.title === keyword;
                     });
                     if (matchedItem) {
                    	 markerInfo +="<span class='markertitle' style='font-size:18px;font-weight:900'>"
                    			+matchedItem.title
                    			+"</span>"
                    			+"<span>"
                    			+"<strong>주소</strong> : "+matchedItem.addr1+" "+matchedItem.addr2
                    			+"</span>"
                    			+"<img id='firstimage' src='"+matchedItem.firstimage+"' alt='대표 이미지' style='width:75%; height:auto;'>"
                    			+"<button class='locationDetail btn btn-secondary' id='"+matchedItem.contentid+"'> 관광지 정보 상세보기 >> </button>";
                   		$("#map-marker-info").append(markerInfo);
                         markers = [];

                         // 일치하는 관광지의 마커 추가
                         var marker = new naver.maps.Marker({
                             position: new naver.maps.LatLng(parseFloat(matchedItem.mapy), parseFloat(matchedItem.mapx)),
                             map: map,
                             title: matchedItem.title,
                             icon: {
                                 url: 'https://navermaps.github.io/maps.js/docs/img/example/pin_default.png',
                                 size: new naver.maps.Size(70, 70),
                                 scaledSize: new naver.maps.Size(70, 70),
                                 origin: new naver.maps.Point(0, 0),
                                 anchor: new naver.maps.Point(35, 70)
                             }
                         });

                         var infowindow = new naver.maps.InfoWindow({
                             content: '<div style="width:150px;text-align:center;padding:10px;">' + matchedItem.title + '</div>'
                         });

                         naver.maps.Event.addListener(marker, "mouseover", function(e) {
                             infowindow.open(map, marker);
                         });

                         naver.maps.Event.addListener(marker, "mouseout", function(e) {
                             infowindow.close();
                         });


                         markers.push(marker);

                         map.setCenter(new naver.maps.LatLng(parseFloat(matchedItem.mapy), parseFloat(matchedItem.mapx)));
                         
                     } else {
                         //일치하는 관광지가 여러개인 경우, 모든 관광지 마커 추가
                         var bounds = new naver.maps.LatLngBounds();
                         
                         items.forEach(function(location,index) {
                        	 
                        	 var id="detail"+(index+1);
                        	 markerInfo +="<span class='markertitle' id="+(index+1)+">"
                   			+(index+1)+". "
                   			+location.title
                   			+"</span>"
                   			+"<div class='markerdetail' id="+id+">"
                   			+"<span>"
                    			+"<strong>주소</strong> : "+location.addr1+" "+location.addr2
                    			+"</span><br>"
                    			+"<button class='locationDetail btn btn-secondary' id='"+location.contentid+"'> 관광지 정보 상세보기 >> </button>"
                    			+"</div>"
                   			+"<div class='hr'></div>";
                             var marker = new naver.maps.Marker({
                                 position: new naver.maps.LatLng(parseFloat(location.mapy), parseFloat(location.mapx)),
                                 map: map,
                                 title: location.title,
                                 icon: {
                                     url: 'https://navermaps.github.io/maps.js/docs/img/example/pin_default.png',
                                     size: new naver.maps.Size(70, 70), // 마커 크기를 70x70으로 변경
                                     scaledSize: new naver.maps.Size(70, 70),
                                     origin: new naver.maps.Point(0, 0),
                                     anchor: new naver.maps.Point(35, 70) // 앵커 포인트 조정
                                 }
                             });

                             var infowindow = new naver.maps.InfoWindow({
                                 content: '<div style="width:150px;text-align:center;padding:10px;">' + location.title + '</div>'
                             });

                             naver.maps.Event.addListener(marker, "mouseover", function(e) {
                                 infowindow.open(map, marker);
                             });

                             naver.maps.Event.addListener(marker, "mouseout", function(e) {
                                 infowindow.close();
                             });


                             markers.push(marker);
                             bounds.extend(new naver.maps.LatLng(parseFloat(location.mapy), parseFloat(location.mapx)));
                         	
                             

                         });
                         //모든 마커를 포함하도록 지도 중심 조정 및 줌 레벨 조정
                         map.panToBounds(bounds);
                         $("#map-marker-info").append(markerInfo);
                         
	
                     }
                 } else {
                     document.write("${keyword}와 일치하는 장소를 찾지 못했습니다.");
                     $("#map-container").hide();
                 }
             } catch (e) {
                 document.write("JSON 데이터를 불러오는 중 오류가 발생했습니다: " + e);
                 $("#map-container").hide();
             }
         } else {
             document.write("해당 검색어와 관련된 여행 데이터가 존재하지 않습니다.");
             $("#map-container").hide();
         }
         
    	</script>
		</div>
		<hr>
		<div id="board-search">
		<h3>#게시글</h3>
		<c:choose>
		<c:when test="${empty rList}">
		${keyword }(으)로 검색된 게시글이 없습니다.
		</c:when>
		<c:otherwise>
		<c:forEach items="${rList}" var="r" end="3">
			<div class="review-search">
				<input type="hidden" class="boardNo" value="${r.boardNo}">
				<div class="review-title">${r.boardTitle} by ${r.boardWriter}</div>
				<div class="review-content">${r.boardContent}</div>
			</div>
		</c:forEach>
		</c:otherwise>
		</c:choose>
		</div>
	</div>
	</div>
	</main>
	<%@ include file="footer.jsp" %>
	<script>
	$(function(){
		$("#search-keyword").attr("value","${keyword}");
		
		$(".markertitle").click(function(){
			//번호를 제외한 지역이름만 추출
			var title=$(this).html().substring(3);
			var id="#detail"+$(this).prop("id");
			$(".markerdetail").hide();
			$(id).show();
			var infowindow = new naver.maps.InfoWindow({
                content: '<div style="width:150px;text-align:center;padding:10px;">' + title + '</div>'
            });
			markers.forEach(function(marker,index){
				/* 10번부터는 글자수가 1개 더 늘어나서 하나 더 자르기 */
				if(index>=9) {
					title=title.substring(1);
				}
				if(marker.title==title){
					infowindow.open(map, marker);
				} else {
				}
			});
		});
		
		$(".locationDetail").click(function(){
			var id=$(this).prop("id");
			location.href ='tripDetail.tl?contentId=' + id;
		});
		
		$(".card").click(function(){
			var contentId = $(this).children().first().val();
			location.href = "tripDetail.tl?contentId="+contentId;
		});
		
		$(".review-search").click(function(){
			var boardNo=$(this).children().first().val();
			location.href="detail.bo?boardNo="+boardNo;
		});
	})
	</script>
</body>
</html>