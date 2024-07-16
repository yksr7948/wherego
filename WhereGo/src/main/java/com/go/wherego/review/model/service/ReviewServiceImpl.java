package com.go.wherego.review.model.service;

import java.util.*;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.go.wherego.review.model.dao.ReviewDao;
import com.go.wherego.review.model.vo.Review;
import com.go.wherego.review.model.vo.ReviewPage;
import com.go.wherego.review.model.vo.ReviewReply;

@Service
public class ReviewServiceImpl implements ReviewService {
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private ReviewDao dao; 
	
	@Override
	public int listCount() {return dao.listCount(sqlSession);}
	
	@Override
	public ArrayList<Review> selectList(ReviewPage pi){return dao.selectList(sqlSession,pi);}
	
	@Override
	public int insertReview(Review rv) {System.out.println("리뷰서비스 : "+rv.toString()); return dao.insertReview(sqlSession,rv);}
	
	@Override
	public Review selectReview(int boardNo) {return dao.selectReview(sqlSession,boardNo);}

	@Override
	public int increaseCount(int boardNo) {return dao.increaseCount(sqlSession,boardNo);}

	@Override
	public int updateReview(Review rv) {return dao.updateReview(sqlSession,rv);}

	@Override
	public int deleteReview(int boardNo) {return dao.deleteReview(sqlSession,boardNo);}

	@Override
	public int insertReply(ReviewReply r) {return dao.insertReply(sqlSession,r);}

	@Override
	public ArrayList<ReviewReply> replyList(int boardNo) {return dao.replyList(sqlSession,boardNo);}

	@Override
	public ArrayList<Review> selectMyReview(String name) {return dao.selectMyReview(name,sqlSession);}

	@Override
	public ArrayList<Review> selectMyReply(String rpy) {return dao.selectMyReply(rpy,sqlSession);}
	
	@Override
	public ArrayList<Review> searchReview(String keyword) {return dao.searchReview(sqlSession,keyword);}

}
