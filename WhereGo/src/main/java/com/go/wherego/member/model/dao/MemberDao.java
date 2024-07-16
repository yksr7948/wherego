package com.go.wherego.member.model.dao;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.go.wherego.member.model.vo.Member;
import com.go.wherego.trip.model.vo.Trip;

//Repository 저장소
//주로 DB(저장소) 와 관련된 작업을 수행하는 역할로 사용(DAO)
@Repository
public class MemberDao {

	//로그인 메소드
	public Member loginMember(SqlSessionTemplate sqlSession, Member m) {
		
		Member loginMember = sqlSession.selectOne("memberMapper.loginMember",m);
		
		return loginMember;
	}
	/* 네이버 */
	   public int insertNaverUserinfo(SqlSessionTemplate sqlSession, Member m) {
	      return sqlSession.insert("memberMapper.insertNaverUser",m);
	 
	   }
	/* 구글 */
	  public int insertGoogleUserinfo(SqlSessionTemplate sqlSession, Member m) {
	     return sqlSession.insert("memberMapper.insertGoogleUser",m);
	
	  }
	  /* 카카오 */
	  public int insertKakaoUserinfo(SqlSessionTemplate sqlSession, Member m) {
	     return sqlSession.insert("memberMapper.insertKakaoUser",m);
	
	  }
	   
	
	//회원가입 메소드
	public int insertMember(SqlSessionTemplate sqlSession, Member m) {
		
		return sqlSession.insert("memberMapper.insertMember",m);
	}
	
	//정보수정 메소드
	public int updateMember(SqlSessionTemplate sqlSession, Member m) {
		
		return sqlSession.update("memberMapper.updateMember", m);
	}
	//회원탈퇴 메소드
	public int deleteMember(SqlSessionTemplate sqlSession, String userId) {
		// TODO Auto-generated method stub
		return sqlSession.update("memberMapper.deleteMember", userId);
	}
	
	//아이디 중복체크
	public int checkId(SqlSessionTemplate sqlSession, String checkId) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("memberMapper.checkId",checkId);
	}
	

	
	
	public Member getMemberById(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("memberMapper.getMemberById",userId);
	}
	public void insertMBTI(SqlSessionTemplate sqlSession, Member m) {
		sqlSession.update("memberMapper.insertMBTI",m);
		
	}
	public void insertWords(SqlSessionTemplate sqlSession, Member m) {
		sqlSession.update("memberMapper.insertWords",m);
		
	}
	public String findIdByEmail(SqlSessionTemplate sqlSession, String byEmail) {
		return sqlSession.selectOne("memberMapper.findIdByEmail",byEmail);
		
	}
	public int updatePwd(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("memberMapper.updatePwd",m);
	}
	public int checkEmail(SqlSessionTemplate sqlSession, String checkEmail) {
		// TODO Auto-generated method stub
		 return sqlSession.selectOne("memberMapper.checkEmail",checkEmail);
	}
	public int pushProfile(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("memberMapper.pushProfile",m);
	}
	public ArrayList<Trip> selectFavor(SqlSessionTemplate sqlSession, String userId) {
		return (ArrayList)sqlSession.selectList("memberMapper.selectFavor", userId);
	}


}
