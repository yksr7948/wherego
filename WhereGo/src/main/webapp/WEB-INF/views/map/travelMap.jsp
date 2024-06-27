<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/WEB-INF/views/common/header.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>여행지도</title>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=7whhnl24e7"></script>
    <style>
        body {
            display: block;
            margin: 0;
            font-family: Arial, sans-serif;
            color: #333;
            background-color: #fff;
        }
        #mapContainer {
            display: flex;
            width: 100%;
            height: calc(100vh - 60px);
            position: relative;
        }
        #map {
            width: 100%;
            height: 100%;
            transition: width 0.3s;
        }
        #currentLocationBtn {
            position: absolute;
            top: 10px;
            left: 10px;
            z-index: 10;
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            border: none;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            font-size: 16px;
        }
        #currentLocationBtn:hover {
            background-color: #555;
        }
        #sidebar {
            width: 30%;
            height: 100%;
            overflow-y: auto;
            background-color: #f9f9f9;
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            display: none;
        }
        #sidebar h2 {
            font-size: 24px;
            margin-bottom: 20px;
            border-bottom: 2px solid #333;
            padding-bottom: 10px;
        }
        #sidebar p {
            margin: 10px 0;
            line-height: 1.6;
        }
        #sidebar img {
            margin-top: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        #searchAgainBtn {
            display: none;
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 10;
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            border: none;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            font-size: 16px;
        }
        #searchAgainBtn:hover {
            background-color: #555;
        }
        #searchForm {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 20px 0;
        }
        #searchInput {
            width: 300px;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: box-shadow 0.3s;
        }
        #searchInput:focus {
            box-shadow: 0 2px 4px rgba(51, 51, 51, 0.5);
            border-color: #333;
            outline: none;
        }
        #searchBtn {
            padding: 10px 20px;
            margin-left: 10px;
            background-color: #333;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s;
        }
        #searchBtn:hover {
            background-color: #555;
        }
        #viewDetailsLink {
            display: block;
            margin-top: 20px;
            text-align: center;
            padding: 10px;
            background-color: #333;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        #viewDetailsLink:hover {
            background-color: #555;
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
    <div id="searchForm">
        <input type="text" id="searchInput" placeholder="검색어를 입력하세요">
        <button id="searchBtn">검색</button>
    </div>
    <div id="mapContainer">
        <button id="currentLocationBtn" onclick="getCurrentLocation()">내 위치로 이동하기</button>
        <div id="map"></div>
        <div id="sidebar">
            <h2 id="title"></h2>
            <p id="addr1Wrapper"><strong>주소:</strong> <span id="addr1"></span></p>
            <p id="addr2Wrapper"><strong>상세 주소:</strong> <span id="addr2"></span></p>
            <p id="firstimageWrapper"><strong>대표 이미지:</strong></p>
            <img id="firstimage" src="" alt="대표 이미지" style="width:100%; height:auto;">
            <a id="viewDetailsLink" href="#">관광지 자세히 보기</a>
        </div>
    </div>
    <button id="searchAgainBtn" onclick="searchAgain()">현위치에서 주변 관광지 검색하기</button>

    <!-- Loading Animation -->
    <div id="loadingContainer">
        <div id="loadingAnimation"></div>
    </div>

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

        if (touristData) {
            try {
                var parsedData = JSON.parse(touristData);
                var items = parsedData.response.body.items.item;

                if (items && items.length) {
                    var matchedItem = items.find(function(location) {
                        return location.title === keyword;
                    });

                    if (matchedItem) {
                        markers.forEach(function(marker) {
                            marker.setMap(null);
                        });
                        markers = [];

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

                        naver.maps.Event.addListener(marker, "click", function(e) {
                            displaySidebar(matchedItem);
                        });

                        markers.push(marker);

                        map.setCenter(new naver.maps.LatLng(parseFloat(matchedItem.mapy), parseFloat(matchedItem.mapx)));
                        displaySidebar(matchedItem);
                    } else {
                        var bounds = new naver.maps.LatLngBounds();
                        items.forEach(function(location) {
                            var marker = new naver.maps.Marker({
                                position: new naver.maps.LatLng(parseFloat(location.mapy), parseFloat(location.mapx)),
                                map: map,
                                title: location.title,
                                icon: {
                                    url: 'https://navermaps.github.io/maps.js/docs/img/example/pin_default.png',
                                    size: new naver.maps.Size(70, 70),
                                    scaledSize: new naver.maps.Size(70, 70),
                                    origin: new naver.maps.Point(0, 0),
                                    anchor: new naver.maps.Point(35, 70)
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

                            naver.maps.Event.addListener(marker, "click", function(e) {
                                displaySidebar(location);
                            });

                            markers.push(marker);
                            bounds.extend(new naver.maps.LatLng(parseFloat(location.mapy), parseFloat(location.mapx)));
                        });
                        map.panToBounds(bounds);
                        map.setZoom(map.getZoom() - 1);
                    }
                } else {
                    alert("No items found in the response");
                }
            } catch (e) {
                alert("Error parsing JSON data: " + e);
            }
        } else {
            alert("No touristData available");
        }

        naver.maps.Event.addListener(map, 'click', function(e) {
            hideSidebar();
        });

        naver.maps.Event.addListener(map, 'dragend', function() {
            document.getElementById('searchAgainBtn').style.display = 'block';
        });

        function searchAgain() {
            var center = map.getCenter();
            var mapX = center.lng();
            var mapY = center.lat();

            window.location.href = '${pageContext.request.contextPath}/travelMap?mapX=' + encodeURIComponent(mapX) + '&mapY=' + encodeURIComponent(mapY);
        }

        function displaySidebar(location) {
            var sidebar = document.getElementById('sidebar');
            var mapDiv = document.getElementById('map');

            document.getElementById('title').innerText = location.title || '정보 없음';

            if (location.addr1) {
                document.getElementById('addr1Wrapper').style.display = 'block';
                document.getElementById('addr1').innerText = location.addr1;
            } else {
                document.getElementById('addr1Wrapper').style.display = 'none';
            }

            if (location.addr2) {
                document.getElementById('addr2Wrapper').style.display = 'block';
                document.getElementById('addr2').innerText = location.addr2;
            } else {
                document.getElementById('addr2Wrapper').style.display = 'none';
            }

            var firstImageElement = document.getElementById('firstimageWrapper');
            if (location.firstimage) {
                firstImageElement.style.display = 'block';
                document.getElementById('firstimage').src = location.firstimage;
            } else {
                firstImageElement.style.display = 'none';
            }

            document.getElementById('viewDetailsLink').href = '${pageContext.request.contextPath}/tripDetail.tl?contentId=' + location.contentid;

            sidebar.style.display = 'block';
            mapDiv.style.width = '70%';
        }

        function hideSidebar() {
            var sidebar = document.getElementById('sidebar');
            var mapDiv = document.getElementById('map');

            sidebar.style.display = 'none';
            mapDiv.style.width = '100%';
        }

        document.getElementById('searchBtn').addEventListener('click', function() {
            var keyword = document.getElementById('searchInput').value;
            if (keyword) {
                window.location.href = '${pageContext.request.contextPath}/travelMap?keyword=' + encodeURIComponent(keyword);
            }
        });

        function getCurrentLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var mapX = position.coords.longitude;
                    var mapY = position.coords.latitude;

                    var userLocation = new naver.maps.LatLng(mapY, mapX);
                    map.setCenter(userLocation);

                    var marker = new naver.maps.Marker({
                        position: userLocation,
                        map: map,
                        title: "내 위치",
                        icon: {
                            url: 'https://navermaps.github.io/maps.js/docs/img/example/pin_spot.png',
                            size: new naver.maps.Size(24, 37),
                            anchor: new naver.maps.Point(12, 37)
                        }
                    });

                    var infowindow = new naver.maps.InfoWindow({
                        content: '<div style="width:150px;text-align:center;padding:10px;">내 위치</div>'
                    });

                    naver.maps.Event.addListener(marker, "mouseover", function(e) {
                        infowindow.open(map, marker);
                    });

                    naver.maps.Event.addListener(marker, "mouseout", function(e) {
                        infowindow.close();
                    });

                    fetchNearbyTouristData(mapX, mapY);

                }, function(error) {
                    alert("Error occurred. Error code: " + error.code);
                });
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        }

        function fetchNearbyTouristData(mapX, mapY) {
            showLoading();
            var xhr = new XMLHttpRequest();
            xhr.open('GET', '${pageContext.request.contextPath}/travelMap?mapX=' + mapX + '&mapY=' + mapY, true);
            xhr.onload = function() {
                hideLoading();
                if (xhr.status === 200) {
                    var touristData = xhr.responseText;
                    var parsedData = JSON.parse(touristData);
                    var items = parsedData.response.body.items.item;

                    if (items && items.length) {
                        markers.forEach(function(marker) {
                            marker.setMap(null);
                        });
                        markers = [];

                        items.forEach(function(location) {
                            var marker = new naver.maps.Marker({
                                position: new naver.maps.LatLng(parseFloat(location.mapy), parseFloat(location.mapx)),
                                map: map,
                                title: location.title,
                                icon: {
                                    url: 'https://navermaps.github.io/maps.js/docs/img/example/pin_default.png',
                                    size: new naver.maps.Size(70, 70),
                                    scaledSize: new naver.maps.Size(70, 70),
                                    origin: new naver.maps.Point(0, 0),
                                    anchor: new naver.maps.Point(35, 70)
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

                            naver.maps.Event.addListener(marker, "click", function(e) {
                                displaySidebar(location);
                            });

                            markers.push(marker);
                        });
                    } else {
                        alert("No nearby tourist data found.");
                    }
                }
            };
            xhr.send();
        }

        var loadingInterval;
        var loadingVisible = false;

        function showLoading() {
            if (!loadingVisible) {
                var loadingContainer = document.getElementById('loadingContainer');
                loadingContainer.classList.add('show');
                var loadingAnimation = document.getElementById('loadingAnimation');
                var imageIndex = 1;

                loadingInterval = setInterval(function() {
                    imageIndex = (imageIndex % 5) + 1;
                    loadingAnimation.style.backgroundImage = 'url("<c:url value="/resources/image/loading/load' + imageIndex + '.png" />")';
                }, 500);
                loadingVisible = true;
            }
        }

        function hideLoading() {
            if (loadingVisible) {
                var loadingContainer = document.getElementById('loadingContainer');
                loadingContainer.classList.remove('show');
                clearInterval(loadingInterval);
                loadingVisible = false;
            }
        }

        function loadData() {
            showLoading();
            setTimeout(function() {
                hideLoading();
            }, 2000);
        }

        loadData();
    </script>

</body>
</html>

