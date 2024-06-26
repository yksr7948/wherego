package com.go.wherego.auth.model;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;

@Component
public class NaverLoginBean {
	private static final String NAVER_CLIENT_ID="ffVgCarFz11WiReQ550o";
	private static final String NAVER_CLIENT_SAECRET="E28rg6Svhs";
	private static final String NAVER_REDIRECT_URI="http://localhost:8888/wherego/navercallback";
	//private static final String NAVER_REDIRECT_URI="http://localhost:8000/naver/callback";
	private static final String SESSION_STATE="naverState";
	private static final String PROFILE_API_URI="https://openapi.naver.com/v1/nid/me";
	
	public String getAuthorizationUrl(HttpSession session) {
		
		// 세션 유효성 검증을 위해 난수 생성 
		String state=UUID.randomUUID().toString();
		// 생성한 난수 값을 session에 저장 - CSRF 토큰과 동일한 역활
		session.setAttribute(SESSION_STATE, state);
		session.setMaxInactiveInterval(60 * 60); 
		
		// 로그인 기능을 요청하기 위한 정보가 저장된 OAuth20Service 객체 생성 (Scribe에서 제공하는 인증 URL 생성 기능)
		OAuth20Service oAuth20Service=new ServiceBuilder()
				.apiKey(NAVER_CLIENT_ID)
				.callback(NAVER_REDIRECT_URI)
				.state(state)  // 앞에서 생성한 난수값을 인증 URL 생성시 사용
				.build(NaverLoginApi.instance());
		
		// 인증 URL
		String authorizationUrl = oAuth20Service.getAuthorizationUrl();
		
		return authorizationUrl;
	}
	
	// 로그인 처리 후 로그인 사용자의 접근 토큰을 발급받는 API를 호출 -> 사용자 접근 토큰을 반환
	public OAuth2AccessToken getAccessToken(HttpSession session, String code, String state) throws IOException {
		// 세션의 유효성 검증을 위해 세션에 저장된 속성값을 반환받아 저장
		String sessionState=(String)session.getAttribute(SESSION_STATE);
		
		// 매개변수로 전달받은 값과 세션에 저장된 값이 같은 경우에만 실행
		if(StringUtils.pathEquals(sessionState, state)) {
			
			// 사용자 접근 토큰을 발급 받기 위한 정보가 저장된 OAuth20Service 객체 생성
			OAuth20Service oAuth20Service=new ServiceBuilder()
					.apiKey(NAVER_CLIENT_ID)
					.apiSecret(NAVER_CLIENT_SAECRET)
					.callback(NAVER_REDIRECT_URI)
					.state(state)
					.build(NaverLoginApi.instance());
			
			// 사용자 접근 토큰을 발급하는 API를 요청하여 토큰을 발급받아 저장 
			OAuth2AccessToken accessToken=oAuth20Service.getAccessToken(code);
			
			return accessToken;
		}
		return null;
	}
	
	// 사용자 접근 토큰을 사용하여 사용자의 프로필을 제공하는 API를 호출
	public String getUserProfile(OAuth2AccessToken accessToken) throws IOException {
		
		OAuth20Service oAuth20Service=new ServiceBuilder()
				.apiKey(NAVER_CLIENT_ID)
				.apiSecret(NAVER_CLIENT_SAECRET)
				.callback(NAVER_REDIRECT_URI)
				.build(NaverLoginApi.instance());
		
		// 사용자의 프로필을 제공하는 API를 요청하기 위한 객체 생성
		OAuthRequest request=new OAuthRequest(Verb.GET, PROFILE_API_URI, oAuth20Service);
		
		// 사용자 접속 토큰과 API 요청 객체를 전달하여 로그인 사용의 프로필 요청
		oAuth20Service.signRequest(accessToken, request);
		
		// 요청에 대한 결과(사용자 프로필)를 응답받아 저장
		Response response=request.send();
		String responseBody = response.getBody();
		
		return responseBody;
	}
}