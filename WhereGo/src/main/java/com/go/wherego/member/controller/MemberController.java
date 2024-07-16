package com.go.wherego.member.controller;

import java.io.IOException;
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
import org.springframework.web.servlet.ModelAndView;

import com.go.wherego.member.model.service.MemberService;
import com.go.wherego.member.model.vo.Member;



@Controller
public class MemberController {
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@Autowired 
	private JavaMailSender mailSenderNaver;

	private int mailCheckNum = 0;

	
	
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
	
	@RequestMapping("nlogin.me")
	public String nlogin() {
		return "member/login";
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
		int result = memberService.insertMember(m);
		
		if (result > 0) { 
			session.setAttribute("alertMsg", "회원 가입 성공!");
			model.addAttribute("userId",m.getUserId());
			return "member/additional";
		} else {
			mv.addObject("errorMsg", "회원 가입 실패");

			return "common/errorPage";
		}
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
		public String addtitionalInfo(String selectedMBTI, String selectedWords,String userId) {
			System.out.println(selectedMBTI);
			System.out.println(selectedWords);
			System.out.println("userId : "+userId);
			Member m = memberService.getMemberById(userId);
			m.setMBTI(selectedMBTI);
			m.setTagWords(selectedWords);
			memberService.insertMBTI(m);
			memberService.insertWords(m);
			
			return "redirect:/";
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
		
//		@ResponseBody
//		@PostMapping("findPwd.me")
//		public String findPwd(String email) {
//			
//			return "";
//		}
		
		
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
		
		
		
		
		
	
}
