package com.go.wherego.review.model.vo;

import java.sql.Date;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewReply {
	private int replyNo;
	private int replyBno;
	private String replyWriter;
	private String replyContent;
	private Date replyDate;
	private String status;
}
