package com.go.wherego.member.model.service;

import java.util.ArrayList;

import com.go.wherego.member.model.vo.Member;
import com.go.wherego.trip.model.vo.Trip;

public interface MemberService {

	//로그인 기능 
	Member loginMember(Member m);
	
	//회원가입 기능
	int insertMember(Member m);
	
	//정보수정 기능
	int updateMember(Member m);
	
	//회원 탈퇴 기능
	int deleteMember(String userId);
	
	//아이디 중복체크
	int checkId(String checkId);
	
	void addNaverUserinfo(Member m);

	void addGoogleUserinfo(Member m);
	
	void addKakaoUserinfo(Member m);

	Member getMemberById(String userId);

	void insertMBTI(Member m);

	void insertWords(Member m);

	String findIdByEmail(String byEmail);

	int updatePwd(Member m);

	int checkEmail(String checkEmail);

	int pushProfile(Member m);

	ArrayList<Trip> selectFavor(String userId);
	

	
}
