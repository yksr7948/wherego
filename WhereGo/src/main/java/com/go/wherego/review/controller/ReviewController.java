package com.go.wherego.review.controller;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.go.wherego.review.model.service.*;
import com.go.wherego.review.model.vo.*;
import com.go.wherego.review.template.ReviewPagination;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Controller
public class ReviewController {
	
	 public static void main(String[] args) {
	        Date currentDate = new Date();
	        SimpleDateFormat sdf = new SimpleDateFormat("yy/MM/dd", Locale.ENGLISH);
	        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
	        String formattedDate = sdf.format(currentDate);
	        System.out.println("Formatted Date: " + formattedDate);
	    }
	
	@Autowired
	private ReviewService rs;
	
	@RequestMapping("review.bo")
	public String reviewList(@RequestParam(value="currentPage",defaultValue="1")int currentPage,Model model) {
		int listCount = rs.listCount();
		int pageLimit = 10;
		int boardLimit = 5;
		
		ReviewPage pi = ReviewPagination.getReviewPage(listCount, currentPage, pageLimit, boardLimit);
		
		ArrayList<Review> list = rs.selectList(pi);
		
		
		model.addAttribute("pi",pi);
		model.addAttribute("list",list);
		
		return "review/reviewList";
	}
	
	@RequestMapping("detail.bo")
	public ModelAndView selectReview(int boardNo,ModelAndView mv) {
		int result=rs.increaseCount(boardNo);
		if(result>0) {Review rv=rs.selectReview(boardNo);mv.addObject("rv",rv).setViewName("review/reviewDetail");}
		else {mv.addObject("errorMsg","조회에 실패").setViewName("common/errorPage");}
		return mv;
	}
	
	@GetMapping("insert.bo")
	public String reviewEnroll() {
		
		return "review/reviewEnroll";
	}
	
	@PostMapping("insert.bo")
	public String insertReview(Review rv, MultipartFile uploadFile,HttpSession session) {
		
		
		int result=rs.insertReview(rv);
		if(result>0) {
			session.setAttribute("alertMsg", "작성이 완료되었습니다!");
		}else {
			session.setAttribute("alertMsg", "오류가 발생해 작성되지 않았습니다...");
		}
		
		return "redirect:/review.bo";
	}
	
	@GetMapping("update.bo")
	public String UpdateReview(int boardNo,Model m) {
		Review rv=rs.selectReview(boardNo);
		m.addAttribute("rv",rv);
		return "review/reviewUpdate";
	}
	
	@PostMapping("update.bo")
	public String updateReview(Review rv, MultipartFile uploadFile,HttpSession session) {
		rs.updateReview(rv);
		return "redirect:/detail.bo?boardNo="+rv.getBoardNo();
	}
	
	@PostMapping("delete.bo")
	public ModelAndView deleteReview(int boardNo,HttpSession session,ModelAndView mv) {
		
		rs.deleteReview(boardNo);
		session.setAttribute("alertMsg", "게시글 삭제 성공");
		mv.setViewName("redirect:/review.bo");
		return mv; 
	}
	
	@ResponseBody
	@RequestMapping(value="replyList.bo",produces="application/json;charset=UTF-8")
	public ArrayList<ReviewReply> replyList(int boardNo) {
		
		ArrayList<ReviewReply> rList = rs.replyList(boardNo);
		
		return rList;
	}
	
	@ResponseBody
	@RequestMapping("insertReply.bo")
	public int insertReply(ReviewReply r) {
		
		System.out.println(r);
		
		int result = rs.insertReply(r);
		
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="myreview.me",produces="application/json;charset=UTF-8")
	public ArrayList<Review> selectMyReview(String name) {
	
		ArrayList<Review> review = rs.selectMyReview(name);
		return review;
	}
	
	@ResponseBody
	@RequestMapping(value="myreply.me",produces="application/json;charset=UTF-8")
	public ArrayList<Review> selectMyReply(String rpy) {
	
		ArrayList<Review> rvreply = rs.selectMyReply(rpy);
		return rvreply;
	}
	
}
