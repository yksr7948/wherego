package com.go.wherego.member.model.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.go.wherego.member.model.dao.MemberDao;
import com.go.wherego.member.model.vo.Member;
import com.go.wherego.member.model.vo.MemberAuth;
import com.go.wherego.trip.model.vo.Trip;



@Service
public class MemberServiceImpl implements MemberService {
	private final BCryptPasswordEncoder pwEncoder = new BCryptPasswordEncoder();
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Override
	public Member loginMember(Member m) {

		Member loginUser = memberDao.loginMember(sqlSession,m);
		
		return loginUser;
	}
	
	//회원가입 메소드
	@Override
	public int insertMember(Member m) {
		return memberDao.insertMember(sqlSession,m);
	}
	
	/*소셜 로그인 회원가입 */
	@Override
	public void addNaverUserinfo(Member m) {
		String rawPw = m.getUserPwd(); // 사용자가 입력한 원래의 비밀번호
		String encodePw = pwEncoder.encode(rawPw); // 비밀번호 인코딩
		m.setUserPwd(encodePw); // 인코딩된 비밀번호를 설정

		memberDao.insertNaverUserinfo(sqlSession,m);
//		
//		/* 권한 설정 */
//		if(userinfoRole.equals("ROLE_USER")) {
//			memberDao.insertSecurityAuth(new MemberAuth(m.getUserId(),"ROLE_USER"));
//		}
//		if(userinfoRole.equals("ROLE_ADMIN")) {
//			memberDao.insertSecurityAuth(new MemberAuth(m.getUserId(),"ROLE_ADMIN"));
//		}
	}
	
	@Override
	public void addGoogleUserinfo(Member m) {
		String rawPw = m.getUserPwd(); // 사용자가 입력한 원래의 비밀번호
		String encodePw = pwEncoder.encode(rawPw); // 비밀번호 인코딩
		m.setUserPwd(encodePw); // 인코딩된 비밀번호를 설정

		memberDao.insertGoogleUserinfo(sqlSession,m);
	}
	
	@Override
	public void addKakaoUserinfo(Member m) {
		String rawPw = m.getUserPwd(); // 사용자가 입력한 원래의 비밀번호
		String encodePw = pwEncoder.encode(rawPw); // 비밀번호 인코딩
		m.setUserPwd(encodePw); // 인코딩된 비밀번호를 설정

		memberDao.insertKakaoUserinfo(sqlSession,m);
	}
	
	
	
	@Override
	public int updateMember(Member m) {
		
		return memberDao.updateMember(sqlSession,m);
	}

	@Override
	public int deleteMember(String userId) {
		
		return memberDao.deleteMember(sqlSession,userId);
	}

	@Override
	public int checkId(String checkId) {
		
		return memberDao.checkId(sqlSession,checkId);
	}


	@Override
	public Member getMemberById(String userId) {
		return memberDao.getMemberById(sqlSession,userId);
	}

	@Override
	public void insertMBTI(Member m) {
		memberDao.insertMBTI(sqlSession,m);
		
	}

	@Override
	public void insertWords(Member m) {
		memberDao.insertWords(sqlSession,m);
		
	}

	@Override
	public String findIdByEmail(String byEmail) {
		return memberDao.findIdByEmail(sqlSession, byEmail);
		
	}

	@Override
	public int updatePwd(Member m) {
		return memberDao.updatePwd(sqlSession,m);
	}

	@Override
	public int checkEmail(String checkEmail) {
		return memberDao.checkEmail(sqlSession,checkEmail);
	}

	@Override
	public int pushProfile(Member m) {
		return memberDao.pushProfile(sqlSession,m);
	}

	@Override
	public ArrayList<Trip> selectFavor(String userId){	
		return memberDao.selectFavor(sqlSession, userId);
	}
	
	
	
	
	
}
