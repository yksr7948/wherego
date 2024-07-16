package com.go.wherego.review.model.vo;

import java.util.*;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Review {
	private int boardNo;
	private String boardTitle;
	private String boardContent;
	private String boardWriter;
	private int count;
	private String country;
	private Date boardDate;
	private String status;
	private String boardImg;
	
	private ArrayList<ReviewReply> rList;
}