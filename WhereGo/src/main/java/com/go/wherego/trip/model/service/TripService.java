package com.go.wherego.trip.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.go.wherego.trip.model.vo.Likes;
import com.go.wherego.trip.model.vo.PageInfo;
import com.go.wherego.trip.model.vo.Reply;
import com.go.wherego.trip.model.vo.Trip;

public interface TripService {

	//지역별 데이터 저장
	int saveArea(ArrayList<Trip> list);
	
	//목록별 전체 개수
	int listCount(String ContentTypeId);
	
	//목록별 지역별 개수
	int areaListCount(Trip t);
	
	//목록별 전체 조회
	ArrayList<Trip> selectList(PageInfo pi, String contentTypeId);
	
	//목록별 지역별 조회
	ArrayList<Trip> selectAreaList(PageInfo pi, Trip t);
	
	//여행지 Top5 조회
	ArrayList<Trip> selectTripTopList();

	//조회수 증가
	int increaseCount(String contentId);
	
	//조회수 조회
	int selectCount(String contentId);
	
	//좋아요 count 조회
	int selectLikeCount(String contentId);
	
	//좋아요 여부
	boolean likeYN(Likes like);
	
	//좋아요 정보 추가
	int insertLike(Likes like);
	
	//좋아요 count 증가
	int increaseLike(Likes like);

	//좋아요 count 감소
	int decreaseLike(Likes like);
	
	//좋아요 정보 삭제
	int deleteLike(Likes like);
	
	//댓글 리스트
	ArrayList<Reply> replyList(String contentId);
	
	//댓글 작성
	int insertReply(Reply r);
	
	//댓글 수정
	int updateReply(Reply r);
	
	//댓글  삭제
	int deleteReply(int replyNo);
	
	//키워드 조회
	ArrayList<Trip> searchTrip(HashMap map, PageInfo pi);

	//키워드에 맞는 여행지 개수
	int count(HashMap map);
	
	ArrayList<Trip> selectMyTrip();
}
