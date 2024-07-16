package com.go.wherego.member.model.vo;

import java.sql.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class Member {
	private String userId;	
	private String userPwd;
	private String userName;
	private String userNickname;
	private int age;
	private Date enrollDate;
	private Date modifyDate;
	private String email;
	private String phone;
	private String MBTI;
	private String tagWords;
	private int userPoint;
	private String gender;
	private String status;
	private String profile;
	private String MyProfile;
	private String address;
	private List<MemberAuth> securityAuthList;
	
	private String title;
	private String firstImage2;
	private String contentId;
	private String addr1;
}
