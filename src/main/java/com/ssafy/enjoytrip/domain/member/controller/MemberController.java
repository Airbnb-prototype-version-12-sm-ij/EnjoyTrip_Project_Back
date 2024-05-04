package com.ssafy.enjoytrip.domain.member.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.enjoytrip.domain.member.dto.MemberDto;
import com.ssafy.enjoytrip.domain.member.entity.MemberEntity;
import com.ssafy.enjoytrip.domain.member.service.MemberServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
@CrossOrigin("*")
public class MemberController {

	private final MemberServiceImpl memberServiceImpl;

	@PostMapping("/login")
	public ResponseEntity<?> login(@Validated @RequestBody MemberDto.Login login,
		BindingResult bindingResult,
		HttpServletRequest request) {
		log.info("--------------------MemberController --- login: {}----------------------", login);

		// errors 의 메세지만 출력
		for (ObjectError error : bindingResult.getAllErrors()) {
			log.info("Error: {}", error.getDefaultMessage());
		}

		if (bindingResult.hasErrors()) {
			log.info("bindingResult: {}", bindingResult);
			return new ResponseEntity<>(bindingResult.getAllErrors(), HttpStatus.BAD_REQUEST);
		}

		try {
			MemberEntity loginInfo = memberServiceImpl.login(login);
			log.info("loginInfo: {}", loginInfo);
			if (loginInfo != null) {
				HttpSession session = request.getSession();
				session.setAttribute("memberDto", loginInfo);
				System.out.println(loginInfo.getUserId() + "님 로그인 성공");
				return new ResponseEntity<>(HttpStatus.OK);
			} else {
				return new ResponseEntity<>("유저 로그인 정보를 확인하세요", HttpStatus.UNAUTHORIZED);
			}
		} catch (Exception e) {
			return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@PostMapping("/logout")
	public void logout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		if (session != null) {
			session.invalidate();
		} else {
			throw new RuntimeException("로그아웃 실패");
		}
		log.info("로그아웃 성공");
	}

	@PostMapping("/join")
	public void join(@Validated @RequestBody MemberDto.Info info, BindingResult bindingResult) {
		log.info("--------------------MemberController --- join: {}----------------------", info);

		// errors 의 메세지만 출력
		for (ObjectError error : bindingResult.getAllErrors()) {
			log.info("Error: {}", error.getDefaultMessage());
		}

		if (bindingResult.hasErrors()) {
			System.out.println(bindingResult.getAllErrors());
			throw new RuntimeException("회원가입 정보를 확인하세요");
		}

		try {
			memberServiceImpl.addMember(info);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	// 비밀번호 변경
	@PostMapping("/modify")
	public ResponseEntity<?> modify(@Validated @RequestBody MemberDto.ForModify userPassword,
		BindingResult bindingResult,
		HttpServletRequest request,
		HttpSession session) {

		log.info("------------------------modify: {}------------------------", userPassword);

		// errors 의 메세지만 출력
		for (ObjectError error : bindingResult.getAllErrors()) {
			log.info("Error: {}", error.getDefaultMessage());
		}

		if (bindingResult.hasErrors()) {
			System.out.println(bindingResult.getAllErrors());
			return new ResponseEntity<>(bindingResult.getAllErrors(), HttpStatus.BAD_REQUEST);
		}
		MemberEntity loginInfo = (MemberEntity)session.getAttribute("memberDto");
		MemberDto.Info info = MemberDto.Info.of(loginInfo);
		info.setUserPassword(userPassword.getUserPassword().replace("\"", ""));
		log.info("------------------------modify: {}------------------------", info);

		try {
			memberServiceImpl.modifyMember(info);
			// 비밀번호 변경 작업이 성공했을 경우
			return new ResponseEntity<>(HttpStatus.OK);
		} catch (Exception e) {
			// 비밀번호 변경 작업이 실패했을 경우
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("{\"success\": false}");
		}
	}

	// 버튼을 누르면 회원들의 정보를 반환 해주는 회원 관리 REST API
	@GetMapping("/info")
	public ResponseEntity<?> getMemberInfo(HttpServletRequest request) {
		log.info("===========getMemberInfo: {}================", request);
		try {
			List<MemberEntity> memberList = memberServiceImpl.loadMember();
			return new ResponseEntity<List<MemberEntity>>(memberList, HttpStatus.OK);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	// 회원 id를 받아 회원을 삭제하는 REST API
	// 검증 로직 필요함
	@PostMapping("/delete")
	public ResponseEntity<?> deleteMember(@Validated @RequestBody MemberDto.ForDelete userId,
		BindingResult bindingResult) {

		log.info("===========deleteMember: {}", userId);
		// errors 의 메세지만 출력
		for (ObjectError error : bindingResult.getAllErrors()) {
			log.info("Error: {}", error.getDefaultMessage());
		}

		if (bindingResult.hasErrors()) {
			log.info("bindingResult: {}", bindingResult);
			return new ResponseEntity<>(bindingResult.getAllErrors(), HttpStatus.BAD_REQUEST);
		}

		try {
			memberServiceImpl.deleteMember(userId.getUserId());
			log.info("deleteMember: {}", userId.getUserId());
			return new ResponseEntity<>(HttpStatus.OK);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	// 회원이 탈퇴하는 Controller
	@PostMapping("/withdraw")
	public ResponseEntity<?> withdrawMember(HttpSession session) {

		String userId = ((MemberEntity)session.getAttribute("memberDto")).getUserId();

		try {
			memberServiceImpl.deleteMember(userId);
			log.info("withdrawMember: {}", userId);
			return new ResponseEntity<>(HttpStatus.OK);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	@PostMapping("/find")
	public ResponseEntity<?> findMember(@Validated @RequestBody MemberDto.Info info, BindingResult bindingResult) {

		if (bindingResult.hasErrors()) {
			System.out.println(bindingResult.getAllErrors());
			return new ResponseEntity<>(bindingResult.getAllErrors(), HttpStatus.BAD_REQUEST);
		}

		MemberDto.Find find = MemberDto.Find.builder().userId(info.getUserId()).userName(info.getUserName()).build();

		try {

			MemberEntity member = memberServiceImpl.findMember(find);
			log.info("findMember: {}", member);

			if (member != null) {
				member.setUserPassword(info.getUserPassword());
				memberServiceImpl.modifyMember(MemberDto.Info.of(member));
				return new ResponseEntity<MemberEntity>(member, HttpStatus.OK);
			} else {
				return new ResponseEntity<MemberEntity>(member, HttpStatus.UNAUTHORIZED);
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

	}

}
