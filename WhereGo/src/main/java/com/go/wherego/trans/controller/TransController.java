package com.go.wherego.trans.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.go.wherego.trans.model.service.TransService;
import com.go.wherego.trans.model.vo.GTerminal;
import com.go.wherego.trans.model.vo.Instant;
import com.go.wherego.trans.model.vo.STerminal;
import com.go.wherego.trans.model.vo.Train;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Controller
public class TransController {

	public static final String SERVICEKEY = "vVq7VKwdLRErcYMsndwQLiEDXaP1n2Zomtx%2BISxD%2FTjn1U5UofcDQqzwbYkaMtrocp2KvJZFs25lR7JRPG%2FLjw%3D%3D";
	public static final String SERVICE_KEY="ueKBwAad327Iz5OxQC1LBnYtY33Hu7OOrwZzO2CghIQcpby32mjhGT8EMAsCZmMhl6kqeyADZVIVay3rTDinnw%3D%3D";
	
	@Autowired
	private TransService transService;
	
	
	//////////////////////////////////////////고속버스 ///////////////////////////////////////////////////////////////////////
	@RequestMapping("GTerminalInfo.tr")
	public String trans() {
		
		return "trans/saveBus";
	}
	
	//고속버스 시간표 가져오기 
	@ResponseBody
	@RequestMapping(value="GBus.tr",produces = "application/json;charset=UTF-8")
	public String getGBusInfo() throws IOException {
		
		
		String url = "https://apis.data.go.kr/1613000/ExpBusInfoService/getExpBusTrminlList";
		url+="?serviceKey="+SERVICEKEY;
		url+="&numOfRows=230";
		url+="&_type=json";
		
		URL requestUrl = new URL(url);
		
		HttpURLConnection urlCon = (HttpURLConnection)requestUrl.openConnection();
		urlCon.setRequestMethod("GET");
		
		BufferedReader br = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
		
		String str = "";
		
		String line;
		while((line=br.readLine()) != null) {
			str+=line;
		}
		
		br.close();
		urlCon.disconnect();
		
		//json 문자열 형태이기때문에 그대로 반납하여도 json화되어서 넘어감 
		System.out.println(str);
		return str;
	}
	
	//고속버스 시간표 저장
		@ResponseBody
		@RequestMapping(value="saveGTerminalInfo.tr", produces ="application/text;charset=UTF-8")
		public String saveGBusInfo() throws IOException {
			
			String url = "https://apis.data.go.kr/1613000/ExpBusInfoService/getExpBusTrminlList";
			url+="?serviceKey="+SERVICEKEY;
			url+="&numOfRows=230";
			url+="&_type=json";
			
			
			
			URL requestUrl = new URL(url); //요청 url을 넣어서 객체 준비
			
			HttpURLConnection urlCon = (HttpURLConnection)requestUrl.openConnection();
			
			urlCon.setRequestMethod("GET");//get방식 요청 설정
			
			BufferedReader br = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
			
			String responseStr = "";
			String line;
			while((line = br.readLine())!=null) {
				responseStr+=line;
			}
			
			JsonObject jobj = JsonParser.parseString(responseStr).getAsJsonObject();
			
			JsonObject response = jobj.getAsJsonObject("response");
			
			JsonObject body = response.getAsJsonObject("body");
			JsonObject items = body.getAsJsonObject("items");
			JsonArray item = items.getAsJsonArray("item");
			
			
			ArrayList<GTerminal> list = new ArrayList<>(); 
			
			for(int i=0;i<item.size();i++) {

				JsonObject it = item.get(i).getAsJsonObject();
				

				list.add(new GTerminal(it.get("terminalId").getAsString()
								  ,it.get("terminalNm").getAsString()
							));
				
			}

			//작업 끝 자원반납
			br.close(); //버퍼리더반납
			urlCon.disconnect(); // 연결해제
			
			int result = transService.saveGTerminalInfo(list);
			
			if(result>0) {
				return "저장성공";
			}else {
				return "저장실패";
			}
			
		}
		
		//출발지 like검색
		@ResponseBody
		@RequestMapping("searchDp.tr")
		public ArrayList<String> searchDp(String searchDp, String date) throws IOException{

			ArrayList<String> dlist = transService.likeSearch(searchDp);
			System.out.println(dlist);	
			
			return dlist;
			
		}
		
		//도착지 like검색
		@ResponseBody
		@RequestMapping("searchAr.tr")
		public ArrayList<String> searchAr(String searchDp,String searchAr,String date) throws IOException{
			
			String departureCode = transService.getGTerminalCode(searchDp);
			
			String url = "https://apis.data.go.kr/1613000/ExpBusInfoService/getStrtpntAlocFndExpbusInfo";
			url+="?serviceKey="+SERVICEKEY;
			url+="&pageNo=1";
			url+="&numOfRows=1000";
			url+="&_type=json";
			url+="&depTerminalId="+departureCode;
			url+="&depPlandTime="+date;
			
			URL requestUrl = new URL(url);
			
			HttpURLConnection urlCon = (HttpURLConnection)requestUrl.openConnection();
			urlCon.setRequestMethod("GET");
			
			BufferedReader br = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
			
			
			String str = "";
			
			String line;
			while((line=br.readLine()) != null) {
				str+=line;
			}
			JsonObject jobj = JsonParser.parseString(str).getAsJsonObject();
			
			JsonObject response = jobj.getAsJsonObject("response");
			
			JsonObject body = response.getAsJsonObject("body");
			JsonObject items = body.getAsJsonObject("items");
			JsonArray item = items.getAsJsonArray("item");
			
			ArrayList<Instant> list = new ArrayList<>(); 
			
			for(int i=0;i<item.size();i++) {

				JsonObject it = item.get(i).getAsJsonObject();
				
				list.add(new Instant(it.get("arrPlaceNm").getAsString()));
			}
			
			// HashSet을 사용하여 중복을 제거
			HashSet<Instant> set = new HashSet<>(list);

			// HashSet을 다시 ArrayList로 변환
			list.clear();
			list.addAll(set);
			
			System.out.println("db에 넣을 리스트 : "+list);
			
			transService.insertInstant(list); // 해당 출발지에 대한 도착지 LIST 저장
			 
			
			
			ArrayList<String> arrivalList = transService.arrivalLikeSearch(searchAr); // 위에 instant 테이블에 저장한 도착지 리스트에서 
																				//사용자가 검색한 단어로 like검색 
			
			HashSet<String> arrivalSet = new HashSet<String>(arrivalList);
			
			arrivalList.clear();
			arrivalList.addAll(arrivalSet);
			
			System.out.println("like 검색 결과"+arrivalList);
			transService.deleteInstant();
			return arrivalList;
			
		}
		
		
		
		//사용자가 찾는 고속버스 시간표 출력
		@RequestMapping("Gardp.tr")
		public String Gardp() {
			return "trans/ardp";
		}
		
		@ResponseBody
		@RequestMapping(value="getGArdp.tr", produces ="application/json;charset=UTF-8")
		public String getGArdp(String date, String departure, String arrival)throws IOException {
			
			String departureCode = transService.getGTerminalCode(departure);
			String arrivalCode = transService.getGTerminalCode(arrival);
			System.out.println(departureCode);
			System.out.println(arrivalCode);
			System.out.println(date);
			
			
			
			String url = "https://apis.data.go.kr/1613000/ExpBusInfoService/getStrtpntAlocFndExpbusInfo";
			url+="?serviceKey="+SERVICEKEY;
			url+="&numOfRows=20";
			url+="&_type=json";
			url+="&depTerminalId="+departureCode;
			url+="&arrTerminalId="+arrivalCode;
			url+="&depPlandTime="+date;
			
			URL requestUrl = new URL(url);
			
			HttpURLConnection urlCon = (HttpURLConnection)requestUrl.openConnection();
			urlCon.setRequestMethod("GET");
			
			BufferedReader br = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
			
			String str = "";
			
			String line;
			while((line=br.readLine()) != null) {
				str+=line;
			}

			JsonObject jobj = JsonParser.parseString(str).getAsJsonObject();
			
			JsonObject response = jobj.getAsJsonObject("response");
			
			JsonObject body = response.getAsJsonObject("body");
			int totalCount = body.get("totalCount").getAsInt();
			
			System.out.println("totalCount : "+totalCount);
			
			if(totalCount==0) {
				br.close();
				urlCon.disconnect();
				System.out.println("str : "+str);
				return str;
			}else {
				br.close();
				urlCon.disconnect();
				
				//json 문자열 형태이기때문에 그대로 반납하여도 json화되어서 넘어감 
				System.out.println(str);
				return str;
			}
			
		}
		
		
		////////////////////////////// 여기서부터는 시외버스  ////////////////////////////////////////////////////
		
		
		@RequestMapping("STerminalInfo.tr")
		public String Strans() {
			
			return "trans/saveSBus";
		}
		
		//시외버스 시간표 가져오기 
		@ResponseBody
		@RequestMapping(value="SBus.tr",produces = "application/json;charset=UTF-8")
		public String getSBusInfo(String location) throws IOException {
			
			
			String url = "https://apis.data.go.kr/1613000/SuburbsBusInfoService/getSuberbsBusTrminlList";
			url+="?serviceKey="+SERVICEKEY;
			url+="&numOfRows=2117";
			url+="&_type=json";
			
			URL requestUrl = new URL(url);
			
			HttpURLConnection urlCon = (HttpURLConnection)requestUrl.openConnection();
			urlCon.setRequestMethod("GET");
			
			BufferedReader br = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
			
			String str = "";
			
			String line;
			while((line=br.readLine()) != null) {
				str+=line;
			}
			
			br.close();
			urlCon.disconnect();
			
			//json 문자열 형태이기때문에 그대로 반납하여도 json화되어서 넘어감 
			System.out.println(str);
			return str;
		}
		
		//시외버스 시간표 저장
			@ResponseBody
			@RequestMapping(value="saveSTerminalInfo.tr", produces ="application/text;charset=UTF-8")
			public String saveSBusInfo() throws IOException {
				
				String url = "https://apis.data.go.kr/1613000/SuburbsBusInfoService/getSuberbsBusTrminlList";
				url+="?serviceKey="+SERVICEKEY;
				url+="&numOfRows=2117";
				url+="&_type=json";
				
				
				
				URL requestUrl = new URL(url); //요청 url을 넣어서 객체 준비
				
				HttpURLConnection urlCon = (HttpURLConnection)requestUrl.openConnection();
				
				urlCon.setRequestMethod("GET");//get방식 요청 설정
				
				BufferedReader br = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
				
				String responseStr = "";
				String line;
				while((line = br.readLine())!=null) {
					responseStr+=line;
				}
				
				JsonObject jobj = JsonParser.parseString(responseStr).getAsJsonObject();
				
				JsonObject response = jobj.getAsJsonObject("response");
				
				JsonObject body = response.getAsJsonObject("body");
				JsonObject items = body.getAsJsonObject("items");
				JsonArray item = items.getAsJsonArray("item");
				
				
				ArrayList<STerminal> list = new ArrayList<>(); 
				
				for(int i=0;i<item.size();i++) {

					JsonObject it = item.get(i).getAsJsonObject();
					

					list.add(new STerminal(it.get("terminalId").getAsString()
									  ,it.get("terminalNm").getAsString()
									  ,it.get("cityName").getAsString()
								));
					
				}

				//작업 끝 자원반납
				br.close(); //버퍼리더반납
				urlCon.disconnect(); // 연결해제
				
				int result = transService.saveSTerminalInfo(list);
				
				if(result>0) {
					return "저장성공";
				}else {
					return "저장실패";
				}
				
			}
			//시외버스 출발지 like검색
			@ResponseBody
			@RequestMapping("searchSDp.tr")
			public ArrayList<String> searchSDp(String searchDp, String date) throws IOException{

				ArrayList<String> dlist = transService.likeSSearch(searchDp);
				System.out.println(dlist);	
				
				return dlist;
				
			}
			
			//시외버스 도착지 like검색
			@ResponseBody
			@RequestMapping("searchSAr.tr")
			public ArrayList<String> searchSAr(String searchDp,String searchAr,String date) throws IOException{
				
				String departureCode = transService.getSTerminalCode(searchDp);
				
				String url = "https://apis.data.go.kr/1613000/SuburbsBusInfoService/getStrtpntAlocFndSuberbsBusInfo";
				url+="?serviceKey="+SERVICEKEY;
				url+="&pageNo=1";
				url+="&numOfRows=1000";
				url+="&_type=json";
				url+="&depTerminalId="+departureCode;
				url+="&depPlandTime="+date;
				
				URL requestUrl = new URL(url);
				
				HttpURLConnection urlCon = (HttpURLConnection)requestUrl.openConnection();
				urlCon.setRequestMethod("GET");
				
				BufferedReader br = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
				
				
				String str = "";
				
				String line;
				while((line=br.readLine()) != null) {
					str+=line;
				}
				JsonObject jobj = JsonParser.parseString(str).getAsJsonObject();
				
				JsonObject response = jobj.getAsJsonObject("response");
				
				JsonObject body = response.getAsJsonObject("body");
				JsonObject items = body.getAsJsonObject("items");
				JsonArray item = items.getAsJsonArray("item");
				
				ArrayList<Instant> list = new ArrayList<>(); 
				
				for(int i=0;i<item.size();i++) {

					JsonObject it = item.get(i).getAsJsonObject();
					
					list.add(new Instant(it.get("arrPlaceNm").getAsString()));
				}
				
				// HashSet을 사용하여 중복을 제거
				HashSet<Instant> set = new HashSet<>(list);

				// HashSet을 다시 ArrayList로 변환
				list.clear();
				list.addAll(set);
				
				System.out.println("db에 넣을 리스트 : "+list);
				
				int insertResult = transService.insertSInstant(list); // 해당 출발지에 대한 도착지 LIST 저장
				 
				
				
				ArrayList<String> arrivalList = transService.arrivalSLikeSearch(searchAr); // 위에 instant 테이블에 저장한 도착지 리스트에서 
																					//사용자가 검색한 단어로 like검색 
				
				HashSet<String> arrivalSet = new HashSet<String>(arrivalList);
				
				arrivalList.clear();
				arrivalList.addAll(arrivalSet);
				
				System.out.println("like 검색 결과"+arrivalList);
				transService.deleteSInstant();
				return arrivalList;
				
			}
			
			
			//사용자가 찾는 시외버스 시간표 출력
			@RequestMapping("Sardp.tr")
			public String Sardp() {
				return "trans/sardp";
			}
			
			@ResponseBody
			@RequestMapping(value="getSArdp.tr", produces ="application/json;charset=UTF-8")
			public String getSArdp(String date, String departure, String arrival)throws IOException {
				
				String departureCode = transService.getSTerminalCode(departure);
				String arrivalCode = transService.getSTerminalCode(arrival);
				System.out.println(departureCode);
				System.out.println(arrivalCode);
				System.out.println(date);
				
				
				
				String url = "https://apis.data.go.kr/1613000/SuburbsBusInfoService/getStrtpntAlocFndSuberbsBusInfo";
				url+="?serviceKey="+SERVICEKEY;
				url+="&numOfRows=20";
				url+="&_type=json";
				url+="&depTerminalId="+departureCode;
				url+="&arrTerminalId="+arrivalCode;
				url+="&depPlandTime="+date;
				
				URL requestUrl = new URL(url);
				
				HttpURLConnection urlCon = (HttpURLConnection)requestUrl.openConnection();
				urlCon.setRequestMethod("GET");
				
				BufferedReader br = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
				
				String str = "";
				
				String line;
				while((line=br.readLine()) != null) {
					str+=line;
				}

				JsonObject jobj = JsonParser.parseString(str).getAsJsonObject();
				
				JsonObject response = jobj.getAsJsonObject("response");
				
				JsonObject body = response.getAsJsonObject("body");
				int totalCount = body.get("totalCount").getAsInt();
				
				System.out.println("totalCount : "+totalCount);
				
				if(totalCount==0) {
					br.close();
					urlCon.disconnect();
					System.out.println("str : "+str);
					return str;
				}else {
					br.close();
					urlCon.disconnect();
					
					//json 문자열 형태이기때문에 그대로 반납하여도 json화되어서 넘어감 
					System.out.println(str);
					return str;
				}
				
			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
	/*********************************************/
	//철도
			
			
			@GetMapping("Train.tr")
			public String goTrain() {
				return "trans/train";
			}
			
			@ResponseBody
			@GetMapping(value = "traintest.tr",produces = "text/plain;charset=UTF-8")
			public String getTrain(String departDate, String departNo,String arriveNo,String trainNo,int pageNo) throws IOException {
				String responseStr="";
				HttpURLConnection urlConn=null;
				BufferedReader br=null;
				//URL객체 얻기(java.net.url)
				String day=departDate.replace("-", "");
				if(trainNo.equals("0")) {
					trainNo="";
				}
				
				URL requestUrl;
				String url = "https://apis.data.go.kr/1613000/TrainInfoService/getStrtpntAlocFndTrainInfo";
				url += "?serviceKey="+SERVICE_KEY
						+ "&pageNo="+pageNo
						+ "&numOfRows="+URLEncoder.encode("50", "UTF-8")
						+ "&_type="+URLEncoder.encode("xml", "UTF-8")
						+ "&depPlaceId="+departNo
						+ "&arrPlaceId="+arriveNo
						+ "&depPlandTime="+day
						+ "&trainGradeCode="+trainNo;

				requestUrl = new URL(url);
				urlConn=(HttpURLConnection)requestUrl.openConnection();
				urlConn.setRequestMethod("GET");
				urlConn.setRequestProperty("Content-type", "application/json");
				
				br=new BufferedReader(new InputStreamReader(urlConn.getInputStream()));
				
				
				String line="";
				while((line=br.readLine())!=null) {
					responseStr+=line;
				}
				
				br.close();
				urlConn.disconnect();
				return responseStr;
			}
			
			@ResponseBody
			@GetMapping(value = "areadetail.tr",produces = "text/plain;charset=UTF-8")
			public String getArea(String area) throws IOException{
				String responseStr="";
				HttpURLConnection urlConn=null;
				BufferedReader br=null;
				//URL객체 얻기(java.net.url)
				URL requestUrl;
				
				String url="http://apis.data.go.kr/1613000/TrainInfoService/getCtyAcctoTrainSttnList";
				url += "?serviceKey="+SERVICE_KEY
						+ "&pageNo="+URLEncoder.encode("1", "UTF-8")
						+ "&numOfRows="+URLEncoder.encode("50", "UTF-8")
						+ "&_type="+URLEncoder.encode("xml", "UTF-8")
						+ "&cityCode="+area;
				
				requestUrl = new URL(url);
				urlConn=(HttpURLConnection)requestUrl.openConnection();
				urlConn.setRequestMethod("GET");
				urlConn.setRequestProperty("Content-type", "application/json");
				
				br=new BufferedReader(new InputStreamReader(urlConn.getInputStream()));
				
				
				String line="";
				while((line=br.readLine())!=null) {
					responseStr+=line;
				}
				
				br.close();
				urlConn.disconnect();
				
				return responseStr;
			}
			
			@ResponseBody
			@GetMapping("getArea.tr")
			public ArrayList<Train> getArea() {
				ArrayList<Train> trList=transService.getArea();
				return trList;
			}
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
	
	
	
	
	
}
