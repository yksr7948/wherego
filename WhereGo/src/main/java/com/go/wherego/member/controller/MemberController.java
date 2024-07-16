package com.go.wherego.member.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.go.wherego.member.model.service.MemberService;
import com.go.wherego.member.model.vo.Member;
import com.go.wherego.trip.model.service.TripService;
import com.go.wherego.trip.model.vo.Trip;



@Controller
public class MemberController {
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@Autowired 
	private JavaMailSender mailSenderNaver;

	private int mailCheckNum = 0;

	@Autowired
	private TripService tripService;	
	//마이페이지의 좋아요한 여행지 이동을 위해 여행지 정보를 받아야함(매퍼도 이하구문)
	
//	@GetMapping("loginPage.me")
//	public String gologin() {
//		
//		return "member/login";
//	} 
	
	
	private String apiResult = null;

	
	// 로그인 첫 화면 요청 메소드

	@RequestMapping(value = "loginPage.me", method = { RequestMethod.GET, RequestMethod.POST })
	public String login(Model model, HttpSession session) {
		
		return "member/login";
	}

	@RequestMapping("login.me")
	public ModelAndView loginMember(Member m, ModelAndView mv, HttpSession session) {
		
		Member loginUser = memberService.loginMember(m);
		
		if (loginUser == null || !bcryptPasswordEncoder.matches(m.getUserPwd(), loginUser.getUserPwd())) {

			mv.addObject("errorMsg", "로그인 실패");
			mv.setViewName("member/login");

		} else {
			session.setAttribute("alertMsg", "로그인 성공!");
			session.setAttribute("loginUser", loginUser);
			mv.setViewName("redirect:/");
		}
		
		
		return mv;
		
	}
	
	@RequestMapping("logout.me")
	public String logoutMember(HttpSession session) {

		session.removeAttribute("loginUser");

		return "redirect:/";
	}
	
	@RequestMapping("insertEnrollForm.me")
	public String memberEnrollForm() {
		//System.out.println("왔나");
		return "member/memberEnrollForm";
	}
	
	@PostMapping("insert.me")
	public String insertMember(Member m, HttpSession session, ModelAndView mv,Model model) {
		String bcrPwd = bcryptPasswordEncoder.encode(m.getUserPwd());
		m.setUserPwd(bcrPwd);		
		memberService.insertMember(m);
		model.addAttribute("userId",m.getUserId());
		return "member/additional";
		
	}
	
		@ResponseBody
		@RequestMapping("checkId.me")
		public String checkId(String checkId) {
			
			int count = memberService.checkId(checkId);
			
			
			String result = "";
			
			if(count>0) {//중복
				result = "NNNNN";
			}else {//중복아님(사용가능)
				result = "NNNNY";
			}
			//System.out.println(result);
			return result;
		}
		
		@ResponseBody
		@RequestMapping("checkEmailExist.me")
		public String checkEmailExist(String checkEmail) {
			System.out.println("checkEmail : "+checkEmail);
			int count = memberService.checkEmail(checkEmail);
			System.out.println(count);
			String result = "";
			
			if(count>0) {//중복
				result = "NNNNN";
			}else {//중복아님(사용가능)
				result = "NNNNY";
			}
			//System.out.println(result);
			return result;
		}
		
		
		
		@RequestMapping("goAdditional.me")
		public String goAdditional(String rollingUserId,Model model,String userId){
			model.addAttribute("userId",userId);
			return "member/additional";
		}
		
		
		@RequestMapping("additional.me")
		public String addtitionalInfo(String selectedMBTI, String selectedWords,String userId, HttpSession session) {
			System.out.println(selectedMBTI);
			System.out.println(selectedWords);
			System.out.println("userId : "+userId);
			Member m = memberService.getMemberById(userId);
			m.setMBTI(selectedMBTI);
			m.setTagWords(selectedWords);
			memberService.insertMBTI(m);
			memberService.insertWords(m);
			session.setAttribute("userId", userId);
			return "member/myProfile";
		}
		
		@GetMapping("findId.me")
		public String findId() {
			return "member/findId";
		}
		
		@ResponseBody
		@PostMapping("findId.me")
		public String findId(String byEmail) {
			String id = memberService.findIdByEmail(byEmail);
			System.out.println(id);
			return id;
		}
		
		@GetMapping("findPwd.me")
		public String findPwd() {
			return "member/findPwd";
		}
		
		@ResponseBody
		@PostMapping("findPwd.me")
		public String findPwd(String email) {
			
			return "";
		}
		
		
		@ResponseBody
		@RequestMapping("sendEmail.me")
		public Map sendEmail(String userId) {
			Map map = new HashMap();
	        
			Member m = memberService.getMemberById(userId);
			if(m==null) {
				map.put("status", false);
				return map;
			}else{ //아이디 및 이메일이 일치 할때
				
				//session.removeAttribute("numAcc");
				Random r = new Random();
		        int numE = r.nextInt(9999);
		        //session.setAttribute("numAcc", num);
		        //model.addAttribute("numAcc", num);
		        
		        mailCheckNum = numE;
		        
				StringBuilder sb = new StringBuilder();
				
				
				String setFrom = "bria0130@naver.com";//발신자 이메일
				String tomail = m.getEmail();//수신자 이메일
				String title = "[어디가] 비밀번호 변경 인증 이메일입니다.";
				sb.append(String.format("안녕하세요 %s님\n", m.getUserId()));
				sb.append(String.format("어디가 비밀번호 찾기(변경) 인증번호는 %d입니다.", numE));
				String content = sb.toString();
				
				try {
					//보낼 이메일 주소 선언후 작성
					MimeMessage mm = mailSenderNaver.createMimeMessage();
					MimeMessageHelper mh = new MimeMessageHelper(mm,true,"UTF-8");
					mh.setFrom(setFrom);
					mh.setTo(tomail);
					mh.setSubject(title);
					mh.setText(content);
					
					mailSenderNaver.send(mm);
					
				} catch (MessagingException e) {
					//e.printStackTrace();
					//System.out.println(e.getMessage());
					
				}
				map.put("status", true);
				map.put("num", numE);
				map.put("m_idx",userId );
				return map;

			} 
		}
		
		@ResponseBody
		@RequestMapping("checkEmail.me")
		public int checkEmail(int fullCode) {
			int result=0;
			
			System.out.println(fullCode);
			if(mailCheckNum==fullCode) { //같다면
				result = 1;
				return result;
			}else { //틀리면 그대로 0
				return result;
			}
		}
		
		@ResponseBody
		@RequestMapping("changePwd.me")
		public String checkId(String newPassword,String userId,HttpSession session) {
				String result = "";
				Member m = new Member();
				m.setUserId(userId);
				String bcrPwd = bcryptPasswordEncoder.encode(newPassword);
				m.setUserPwd(bcrPwd);
				
				int updateCheck = memberService.updatePwd(m);

				if(updateCheck>0) {
					result = "NNNNY";
					
				}else {
					result = "NNNNN";
				}
				//System.out.println(result);
				return result;
			
			
		}
		
		//내 정보 변경
				@RequestMapping("mypage.me")
				public String myPage(String userId) {
					return "member/myPage";
				}
				
				//마이페이지 - 정상작동
				@RequestMapping("myinfo.me")
				public String myInfo(String userId,HttpSession session,Model mi,Model mu) {
					session.setAttribute("userId", userId);
					System.out.println("유저 아이디 : "+userId);
					ArrayList<Trip> myList=tripService.selectMyTrip();
					ArrayList<Trip> myFavor = memberService.selectFavor(userId);
					System.out.println("내가 좋아하는 여행지 :"+myFavor);
					mi.addAttribute("myList",myList);
					mu.addAttribute("myFavor",myFavor);
					return "member/myInfo";
				}
				
				//내 프로필 등록 이전 모델
				@RequestMapping("myProfile.me")
				public String usemyprofile(String userId, Model model) {
					model.addAttribute("userId",userId);
					return "member/myProfile";
				}
				
				//탈퇴
				@RequestMapping("delete.me")
				public String deleteMember(String userPwd
										  ,HttpSession session
										  ,Model model) {
					Member loginUser = ((Member)session.getAttribute("loginUser"));
					String encPwd = loginUser.getUserPwd();
					String userId = loginUser.getUserId();
					
					if(bcryptPasswordEncoder.matches(userPwd, encPwd)) {
						int result = memberService.deleteMember(userId);

						if(result>0) {
							session.removeAttribute("loginUser");
							session.setAttribute("alertMsg", "회원탈퇴가 완료되었습니다.");
							return "redirect:/";
						}else {
							model.addAttribute("errorMsg","회원 탈퇴 실패");
							return "common/errorPage";
						}
					}else {
						session.setAttribute("alertMsg", "비밀번호 입력 오류");
						return "redirect:/mypage.me";
					}
				}
				
				//내 프로필 등록하기
				@PostMapping("profile.me")
				public String profileUpload(MultipartFile profile, HttpSession session,String userId) {
					
					Member m = memberService.getMemberById(userId);
					
					if(!profile.getOriginalFilename().equals("")){
						String myProfile=saveFile(profile,session);
						m.setProfile(profile.getOriginalFilename());
						m.setMyProfile("resources/uploadFiles/profile/"+myProfile);
					}
					
					if(m!=null){
						session.setAttribute("alertMsg", "회원 가입 성공!");
						memberService.pushProfile(m);
						return "main";
					} else{
						session.setAttribute("alertMsg", "회원 가입 실패");
						return "common/errorPage";
					}
					
				}

				
				@GetMapping("mypage.me")
				public String memberEnrollForm(HttpSession session) {
					Member m=(Member) session.getAttribute("loginUser");
					System.out.println("아이디를 받은 유저 정보 : "+m);
					return "member/myPage";
				}
				
				//회원정보 수정처리 메소드
				@PostMapping("mypage.me")
				public String updateMember(Member m,MultipartFile reprofile ,HttpSession session) {
					
				
					boolean flag = false; 		
					String deleteProfile = "";		
					if(!reprofile.getOriginalFilename().equals("")) {
						if(m.getProfile()!=null) {
							flag = true;
							deleteProfile = m.getMyProfile();
						} 
						String myProfile = saveFile(reprofile,session);
						
						m.setProfile(reprofile.getOriginalFilename());
						m.setMyProfile("resources/uploadFiles/profile/"+myProfile);
					}
					
					int result=memberService.updateMember(m);
					System.out.println("업데이트 됐는지 ? : "+result);
					System.out.println("멤버 값 : "+m);
					System.out.println("프로필 갱신"+m.getMyProfile());
					
					String msg="";
					if(result>0) {
						msg="회원 정보 수정이 완료되었습니다.";
						session.setAttribute("loginUser", m);
						if(flag) {
							File f = new File(session.getServletContext().getRealPath(deleteProfile));
							f.delete();
						}
					}else {
						msg="수정되지 않았습니다.";
					}
					
					session.setAttribute("alertMsg", msg);
					return "member/myInfo";	
				}
				
				//사진 저장하는 도중 사진 이름 바꾸는 메소드
				private String saveFile(MultipartFile profile, HttpSession session) {
					String originName = profile.getOriginalFilename();
					String currentTime ="myprofile";
					String ext = originName.substring(originName.lastIndexOf("."));
					int ranNum = (int)(Math.random()*900000+100000);
					String myProfile = currentTime+ranNum+ext;
					String savePath = session.getServletContext().getRealPath("/resources/uploadFiles/profile/");
					System.out.println("프로필 저장 경로 : "+savePath);
					try {profile.transferTo(new File(savePath+myProfile));} 
					catch (IllegalStateException | IOException e) {e.printStackTrace();}
					return myProfile;
				}
}
