package com.go.wherego.trip.model.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.go.wherego.trip.model.vo.Likes;
import com.go.wherego.trip.model.vo.PageInfo;
import com.go.wherego.trip.model.vo.Reply;
import com.go.wherego.trip.model.vo.Trip;

@Repository
public class TripDao {

	//데이터 저장
	public int saveArea(ArrayList<Trip> list, SqlSessionTemplate sqlSession){
			
		return sqlSession.insert("tripMapper.saveArea",list);
	}
		
	//목록별 전체 개수
	public int listCount(SqlSessionTemplate sqlSession, String contentTypeId) {
			
		return sqlSession.selectOne("tripMapper.listCount", contentTypeId);
	}
	
	//목록별 지역별 개수
	public int areaListCount(SqlSessionTemplate sqlSession, Trip t) {

		return sqlSession.selectOne("tripMapper.areaListCount", t); 
	}
		
	//목록별 전체 조회
	public ArrayList<Trip> selectList(SqlSessionTemplate sqlSession, PageInfo pi, String contentTypeId){
			
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage()-1)*limit;
			
		RowBounds rowBounds = new RowBounds(offset,limit);
			
		return (ArrayList)sqlSession.selectList("tripMapper.selectList", contentTypeId, rowBounds);
	}
	
	//목록별 지역별 조회
	public ArrayList<Trip> selectAreaList(SqlSessionTemplate sqlSession, PageInfo pi, Trip t){
		
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage()-1)*limit;
			
		RowBounds rowBounds = new RowBounds(offset,limit);
			
		return (ArrayList)sqlSession.selectList("tripMapper.selectAreaList", t, rowBounds);
	}
	
	//여행지 Top5 조회
	public ArrayList<Trip> selectTripTopList(SqlSessionTemplate sqlSession){
		
		return (ArrayList)sqlSession.selectList("tripMapper.selectTripTopList");
	}

	//조회수 증가
	public int increaseCount(SqlSessionTemplate sqlSession, String contentId) {

		return sqlSession.update("tripMapper.increaseCount", contentId);
		
	}
	
	//조회수 가져오기
	public int selectCount(SqlSessionTemplate sqlSession, String contentId) {
		
		Integer count = sqlSession.selectOne("tripMapper.selectCount", contentId);
	    return (count == null) ? 0 : count;
	}
	
	//좋아요 count 조회
	public int selectLikeCount(SqlSessionTemplate sqlSession, String contentId) {
		
		Integer likeCount = sqlSession.selectOne("tripMapper.selectLikeCount", contentId);
	    return (likeCount == null) ? 0 : likeCount;
	}
	
	//좋아요 여부
	public boolean likeYN(SqlSessionTemplate sqlSession, Likes like) {
		
		String userId = sqlSession.selectOne("tripMapper.likeYN", like);
		
		boolean flag = false;
		
		if(userId == null) {
			flag = false;
		}else {
			flag = true;
		}
		
		return flag;
	}
	
	//좋아요 정보 추가
	public int insertLike(SqlSessionTemplate sqlSession, Likes like) {
		
		return sqlSession.insert("tripMapper.insertLike", like);
	}
	
	//좋아요 count 증가
	public int increaseLike(SqlSessionTemplate sqlSession, Likes like) {
		
		return sqlSession.update("tripMapper.increaseLike", like);
	}
	
	//좋아요 count 감소
	public int decreaseLike(SqlSessionTemplate sqlSession, Likes like) {
		
		return sqlSession.update("tripMapper.decreaseLike", like);
	}
	
	//좋아요 정보 삭제
	public int deleteLike(SqlSessionTemplate sqlSession, Likes like) {
		
		return sqlSession.delete("tripMapper.deleteLike", like);
	}
	
	//댓글 리스트
	public ArrayList<Reply> replyList(SqlSessionTemplate sqlSession, String contentId) {

		return (ArrayList)sqlSession.selectList("tripMapper.replyList", contentId);
	}
	
	//댓글 작성
	public int insertReply(SqlSessionTemplate sqlSession, Reply r) {
		
		return sqlSession.insert("tripMapper.insertReply", r);
	}
	
	//댓글 수정
	public int updateReply(SqlSessionTemplate sqlSession, Reply r) {
		
		return sqlSession.update("tripMapper.updateReply", r);
	}
	
	//댓글 삭제
	public int deleteReply(SqlSessionTemplate sqlSession, int replyNo) {
		
		return sqlSession.delete("tripMapper.deleteReply", replyNo);
	}
	
	//키워드에 맞는 여행지 조회
	public ArrayList<Trip> searchTrip(SqlSessionTemplate sqlSession, HashMap map, PageInfo pi) {

		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;

		RowBounds rowBounds = new RowBounds(offset, limit);
		ArrayList<Trip> tList = (ArrayList) sqlSession.selectList("tripMapper.searchTrip", map, rowBounds);
		return tList;
	}

	//키워드에 맞는 여행지 개수
	public int count(SqlSessionTemplate sqlSession, HashMap map) {
		return sqlSession.selectOne("tripMapper.countByKeyword", map);
	}

	public ArrayList<Trip> selectMyTrip(SqlSessionTemplate sqlSession){
		return (ArrayList)sqlSession.selectList("tripMapper.selectMyTrip");
	}
}
