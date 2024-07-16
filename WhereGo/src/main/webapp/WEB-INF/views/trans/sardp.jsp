<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    .hidden {
        display: none;
    }
#searchDp {
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
#searchDp:hover {
    background-color: black;
    color: white;
}
#searchAr {
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
#searchAr:hover {
    background-color: black;
    color: white;
}
#searchBtn {
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
#searchBtn:hover {
    background-color: black;
    color: white;
}
table.custom-table ,#maindep{
        background-color: white;
        color: black;
        border: none; /* Hide all borders */
        border-radius: 5px;
        font-size: 16px;
        font-weight: 900;
        text-align: center;
        width: 80%; /* Adjust this value to change the width */
        margin: 20px auto; /* Center the table */
    }

    table.custom-table thead {
    height: 50px; /* Set your desired height */
	}

/* Style the horizontal lines in the table */
	table.custom-table th,
table.custom-table td {
    border-bottom: 1px dotted black; /* Add dotted lines */
    padding: 10px 20px;
    border: none; /* Hide default borders */
}
    #maindep th,#maindep td,table.custom-table thead {
    height: 50px; /* Set your desired height */
}

    #maindep tbody td:hover, table.custom-table tbody tr:hover {
        background-color: gray;
        color: white;
        cursor: pointer;
    }
   #dp,#arv {
        width: 250px; /* 테이블 너비를 100px로 설정 */
        table-layout: fixed; /* 고정된 레이아웃 설정하여 너비가 적용되도록 함 */
    }
    
 #departure,#arrival{
	
 }

</style>
</head>
<body>
<%@include file="/WEB-INF/views/common/header.jsp" %>
<h1>시외버스</h1>
<label for="selectDate">Select Date</label>

<input type="date" id="selectDate" name="selectDate" value="" min="" max="" />

출발지 : <input type="text" id="departure" name="departure"/><button id="searchDp">출발지 검색</button>
도착지 : <input type="text" id="arrival" name="arrival"/><button id="searchAr">도착지 검색</button>

<button id="searchBtn">조회</button>

<table border="1"  id="result" >
			<thead>
				<tr>
					<th>출발지</th>
					<th>출발시간</th>
					<th>도착지</th>
					<th>도착시간</th>
					<th>비용</th>
					<th>등급</th>
				</tr>
			</thead>
			<tbody>
	
			</tbody>
		</table>
		
		<table border="1"  id="dp" class="hidden">
			<thead>
				<tr>
					<th>출발지</th>
					
				</tr>
			</thead>
			<tbody>
	
			</tbody>
		</table>
		<table border="1"  id="arv" class="hidden">
			<thead>
				<tr>
					<th>도착지</th>
					 
				</tr>
			</thead>
			<tbody>
	
			</tbody>
		</table>
		
		
		
		<table border="1" id="maindep">
			<thead>
				<tr>
					<th colspan="4">주요 출발지</th>

				</tr>
			</thead>
			<tbody>
				<tr>
					<td>동서울</td>
					<td>원주</td>
					<td>인천공항1터미널</td>
					<td>인천공항2터미널</td>
				</tr>
				<tr>
					<td>서울남부</td>
					<td>인천</td>
					<td>광주(유·스퀘어)</td>
					<td>대전복합</td>
				</tr>
				<tr>
					<td>성남</td>
					<td>대구서부</td>
					<td>천안</td>
					<td>청주</td>
				</tr>
			</tbody>
		</table>
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
<script>
$(function() {

	  $("#result").addClass("hidden");
	  $("#dp").addClass("hidden");
	  $("#arv").addClass("hidden");

		
		
	$("#searchBtn").click(
			function() {
				$("#maindep").addClass("hidden");
				$.ajax({
					url : "getSArdp.tr",
					data : {
						date : $("#selectDate").val().replace(/-/g, ""),
						departure : $("#departure").val(),
						arrival : $("#arrival").val()
					},
					success : function(data) {
						var check=data.response.body.totalCount;
						if(check==0){
							alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"해당 노선 없습니다.");
						}else{
						
						
						var items = data.response.body.items.item;
						
						console.log("확인성공");
					
						var str = "";
						for (var i = 0; i < items.length; i++) {
						
							var item = items[i];
							var depPlandTime = item.depPlandTime.toString();;
							var arrPlandTime = item.arrPlandTime.toString();;
							var dtime = depPlandTime.slice(-4); // "0325"
							var atime = arrPlandTime.slice(-4);
							// 시간과 분으로 나누기
							var dhour = dtime.slice(0, 2); // "03"
							var dminute = dtime.slice(2); // "25"

							var ahour = atime.slice(0, 2); // "03"
							var aminute = atime.slice(2);
							// 시간과 분을 원하는 형식으로 조합
							var formattedDepartureTime = dhour + ":" + dminute; // "03:25"
							var formattedArrivalTime = ahour + ":" + aminute; // "03:25"
	
							str += "<tr>" 
								+ "<td>"+item.depPlaceNm+"</td>" 
								+ "<td>"+formattedDepartureTime+"</td>" 
								+ "<td>"+item.arrPlaceNm+"</td>" 
								+ "<td>"+formattedArrivalTime+"</td>"
								+ "<td>"+item.charge+"</td>" 
								+ "<td>"+item.gradeNm+"</td>" 
								+ "</tr>";
						}

						$("#result tbody").html(str);
						 $("#arv").addClass("hidden");
						 $("#dp").addClass("hidden");
						 $("#result").removeClass("hidden").addClass("custom-table");
						}
						
					},
					error : function() {
						alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"출발지, 도착지를 확인하세요");
					}
				});

			});
	
	$("#searchDp").click(
			function() {
				$("#maindep").addClass("hidden");
				$.ajax({
					url : "searchSDp.tr",
					data : {
						date : $("#selectDate").val().replace(/-/g, ""),
						searchDp : $("#departure").val()
					},
					success : function(data) {
						var items = data;
						console.log("확인성공");
						var str = "";
						for (var i = 0; i < items.length; i++) {

							var item = items[i];

							str += "<tr>" 
								+ "<td>"+item+"</td>"  
								
								+ "</tr>";
						}
						$("#dp tbody").html(str);
						$("#dp").removeClass("hidden").addClass("custom-table");
		                $("#arv").addClass("hidden");
						
						},

					error : function() {
					}
				});

			}); 
	$("#searchAr").click(
			function() {
				$("#maindep").addClass("hidden");
				$.ajax({
					url : "searchSAr.tr",
					data : {
						date : $("#selectDate").val().replace(/-/g, ""),
						searchDp : $("#departure").val(),
						searchAr : $("#arrival").val()
					},
					success : function(data) {
						var items = data;
						console.log("확인성공");
						if (data.length === 0) {
			                // If data is empty, show alert
			                alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">', '해당 노선이 없습니다');
			            }
						var str = "";
						for (var i = 0; i < items.length; i++) {

							var item = items[i];

							str += "<tr>" 
								+ "<td>"+item+"</td>"  
								
								+ "</tr>";
						}
						$("#arv tbody").html(str);
						$("#arv").removeClass("hidden").addClass("custom-table");	
		                $("#dp").addClass("hidden");
						
						},

					error : function() {
						alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"출발지를 선택하세요");
					}
				});

			}); 
	$("#dp").on('click', 'tbody tr', function() {
        // Get the text content of the clicked row
        var selectedDeparture = $(this).find('td').text().trim();
        
        // Store the selected departure in the global variable
        departure = selectedDeparture;

        // Optionally, you can update the input field or do other actions
        $("#departure").val(departure); // Update the input field with selected departure
        
        // Example of alerting the selected departure
        alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"Selected departure: " + departure);
    });
	
	$("#arv").on('click', 'tbody tr', function() {
        // Get the text content of the clicked row
        var selectedArrival = $(this).find('td').text().trim();
        
        // Store the selected departure in the global variable
        arrival = selectedArrival;

        // Optionally, you can update the input field or do other actions
        $("#arrival").val(arrival); // Update the input field with selected departure
        
        // Example of alerting the selected departure
        alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"Selected arrival: " + arrival);
    });
	 $("#maindep").on('click', 'tbody td', function() {
	        // 클릭된 출발지의 텍스트를 가져옵니다.
	        var selectedMainDep = $(this).text().trim();
	        
	        // 그 값을 #departure 입력 필드에 설정합니다.
	        $("#departure").val(selectedMainDep);
	        
	        // 그 값을 alert 창에 띄웁니다.
	        alertify.alert('<img src="resources/img/removebg-preview.png" style="width: 30px;">',"선택된 출발지: " + selectedMainDep);
	    });
	
	});
	
var departure ="";

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
maxDate.setDate(today.getDate() + 30);

document.getElementById('selectDate').value = formatDate(today);
document.getElementById('selectDate').min = formatDate(today);
document.getElementById('selectDate').max = formatDate(maxDate);
</script>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
    