package com.go.wherego.trip.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.go.wherego.trip.model.dao.TripDao;
import com.go.wherego.trip.model.vo.Likes;
import com.go.wherego.trip.model.vo.PageInfo;
import com.go.wherego.trip.model.vo.Reply;
import com.go.wherego.trip.model.vo.Trip;


@Service
public class TripServiceImpl implements TripService{

	@Autowired
	private TripDao tripDao;
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	//데이터 저장
	@Override
	public int saveArea(ArrayList<Trip> list) {
		
		int result = tripDao.saveArea(list, sqlSession);
		
		return result;
	}
	
	//목록별 전체 개수
	@Override
	public int listCount(String contentTypeId) {
		
		int listCount = tripDao.listCount(sqlSession, contentTypeId);
		
		return listCount;
	}
	
	//목록별 지역별 개수
	@Override
	public int areaListCount(Trip t) {
			
		int listCount = tripDao.areaListCount(sqlSession, t);
			
		return listCount;
	}
	
	//목록별 전체 조회
	@Override
	public ArrayList<Trip> selectList(PageInfo pi, String contentTypeId){
		
		ArrayList<Trip> tList = tripDao.selectList(sqlSession, pi, contentTypeId);
		
		return tList;
	}
	
	//목록별 지역별 조회
	@Override
	public ArrayList<Trip> selectAreaList(PageInfo pi, Trip t){
			
		ArrayList<Trip> aList = tripDao.selectAreaList(sqlSession, pi, t);
			
		return aList;
	}
	
	//여행지 Top5
	@Override
	public ArrayList<Trip> selectTripTopList(){
		
		ArrayList<Trip> tripTopList = tripDao.selectTripTopList(sqlSession);
		
		return tripTopList;
	}
	
	//조회수 증가
	@Override
	public int increaseCount(String contentId) {
		
		int result = tripDao.increaseCount(sqlSession, contentId);
		
		return result;
	}
	
	//조회수 가져오기
	@Override
	public int selectCount(String contentId) {
		
		int count = tripDao.selectCount(sqlSession, contentId);
		
		return count;
	}
	
	//좋아요 count 조회
	@Override
	public int selectLikeCount(String contentId) {
		
		int likeCount = tripDao.selectLikeCount(sqlSession, contentId);
		
		return likeCount;
	}
	
	//좋아요 여부
	@Override
	public boolean likeYN(Likes like) {
		
		boolean flag = tripDao.likeYN(sqlSession, like);
		
		return flag;
	}
	
	//좋아요 정보 추가
	@Override
	public int insertLike(Likes like) {
		
		int result = tripDao.insertLike(sqlSession, like);
		
		return result;
	}
	
	//좋아요 count 증가
	public int increaseLike(Likes like) {
		
		int result = tripDao.increaseLike(sqlSession, like);
		
		return result;
	}
	
	//좋아요 count 감소
	public int decreaseLike(Likes like) {
		
		int result = tripDao.decreaseLike(sqlSession, like);
		
		return result;
	}
	
	//좋아요 정보 삭제
	@Override
	public int deleteLike(Likes like) {
		
		int result = tripDao.deleteLike(sqlSession, like);
		
		return result;
	}
	
	//댓글 리스트
	@Override
	public ArrayList<Reply> replyList(String contentId){
		
		ArrayList<Reply> rList = tripDao.replyList(sqlSession, contentId);
		
		return rList;
	}
	
	//댓글 작성
	@Override
	public int insertReply(Reply r) {
		
		int result = tripDao.insertReply(sqlSession, r);
		
		return result;
	}
	
	//댓글 수정
	@Override
	public int updateReply(Reply r) {
		
		int result = tripDao.updateReply(sqlSession, r);
		
		return result;
	}
	
	//댓글 삭제
	@Override
	public int deleteReply(int replyNo) {
		
		int result = tripDao.deleteReply(sqlSession, replyNo);
		
		return result;
	}

	@Override
	public ArrayList<Trip> searchTrip(HashMap map, PageInfo pi) {
		return tripDao.searchTrip(sqlSession, map, pi);
	}

	@Override
	public int count(HashMap map) {
		return tripDao.count(sqlSession, map);
	}
	
	@Override
	public ArrayList<Trip> selectMyTrip(){	
		return tripDao.selectMyTrip(sqlSession);
	}

}
