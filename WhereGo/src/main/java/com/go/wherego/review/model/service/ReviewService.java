package com.go.wherego.review.model.service;

import java.util.*;

import com.go.wherego.review.model.vo.*;

public interface ReviewService {
	//리뷰 댓글 : ReviewReply
	
	int listCount();

	ArrayList<Review> selectList(ReviewPage pi);

	int insertReview(Review rv);

	Review selectReview(int boardNo);

	int increaseCount(int boardNo);

	int updateReview(Review rv);

	int deleteReview(int boardNo);

	int insertReply(ReviewReply r);

	ArrayList<ReviewReply> replyList(int boardNo);

	ArrayList<Review> selectMyReview(String name);

	ArrayList<Review> selectMyReply(String rpy);
	
	ArrayList<Review> searchReview(String keyword);
}
