package com.go.wherego.review.model.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.go.wherego.review.model.vo.Review;
import com.go.wherego.review.model.vo.ReviewPage;
import com.go.wherego.review.model.vo.ReviewReply;

// Reply의 속성이 Trip_Reply의 속성와 비슷함
@Repository
public class ReviewDao {
	public int listCount(SqlSessionTemplate sqlSession) {
		return sqlSession.selectOne("reviewMapper.listCount");
	}

	public ArrayList<Review> selectList(SqlSessionTemplate sqlSession, ReviewPage pi) {
		RowBounds rowBounds=new RowBounds((pi.getCurrentPage()-1)*(pi.getBoardLimit()),pi.getBoardLimit());
		return (ArrayList)sqlSession.selectList("reviewMapper.selectList",null,rowBounds);
	}

	public int insertReview(SqlSessionTemplate sqlSession, Review rv) {
		System.out.println("리뷰 Dao: "+rv.toString());
		return sqlSession.insert("reviewMapper.insertReview",rv);
	}

	public Review selectReview(SqlSessionTemplate sqlSession, int boardNo) {
		return sqlSession.selectOne("reviewMapper.selectReview",boardNo);
	}

	public int increaseCount(SqlSessionTemplate sqlSession, int boardNo) {
		return sqlSession.update("reviewMapper.increaseCount",boardNo);
	}

	public int updateReview(SqlSessionTemplate sqlSession, Review rv) {
		return sqlSession.update("reviewMapper.updateReview",rv);
	}

	public int deleteReview(SqlSessionTemplate sqlSession, int boardNo) {
		return sqlSession.delete("reviewMapper.deleteReview",boardNo);
	}

	public int insertReply(SqlSessionTemplate sqlSession, ReviewReply r) {
		return sqlSession.insert("reviewMapper.insertReply",r);
	}

	public ArrayList<ReviewReply> replyList(SqlSessionTemplate sqlSession, int boardNo) {
		return (ArrayList)sqlSession.selectList("reviewMapper.replyList",boardNo);
	}
	
	public ArrayList<Review> selectMyReview(String name, SqlSessionTemplate sqlSession) {
		return (ArrayList)sqlSession.selectList("reviewMapper.selectMyReview",name);
	}
	
	public ArrayList<Review> selectMyReply(String rpy, SqlSessionTemplate sqlSession) {
		return (ArrayList)sqlSession.selectList("reviewMapper.selectMyReply",rpy);
	}
	
}
