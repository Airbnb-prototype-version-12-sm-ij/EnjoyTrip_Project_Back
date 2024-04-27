package com.ssafy.enjoytrip.domain.posting.controller;

import static com.ssafy.enjoytrip.domain.posting.dto.PostDto.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ssafy.enjoytrip.domain.member.entity.MemberEntity;
import com.ssafy.enjoytrip.domain.posting.entity.PostEntity;
import com.ssafy.enjoytrip.domain.posting.service.PostService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/posting")
public class PostingController {

	private final PostService postService;

	@GetMapping("/list")
	public String list(Model model) {

		try {
			List<PostEntity> postList = postService.getPostList();

			List<String> sidos = new ArrayList<>();

			for (PostEntity post : postList) {
				sidos.add(postService.getSido(post.getSidoCode()));
			}
			model.addAttribute("postList", postList);
			model.addAttribute("sidos", sidos);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
		return "posting/list";
	}

	@GetMapping("/write")
	public String writeForm() {
		return "posting/write";
	}

	@PostMapping("/write")
	public String write(@Validated Regist regist,
		BindingResult bindingResult,
		Model model,
		HttpSession session) {
		log.info("=======================regist : {}", regist);
		if (bindingResult.hasErrors()) {

			log.info("error : {}", bindingResult.getAllErrors());

			StringBuilder sb = new StringBuilder();

			for (ObjectError error : bindingResult.getAllErrors()) {
				sb.append(error.getDefaultMessage());
			}
			model.addAttribute("errorMsg", sb.toString());
			return "posting/write";
		}

		String userId = ((MemberEntity)session.getAttribute("memberDto")).getUserId();
		regist.setUserId(userId);
		try {
			postService.registPost(regist);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		return "redirect:/posting/list";
	}

	// 시도 코드로 구군 데이터 얻기
	@GetMapping("/getGugun/{sidoCode}")
	public ResponseEntity<List<Gugun>> getGugun(@PathVariable String sidoCode) {
		try {
			List<Gugun> gugun = postService.getGugun(sidoCode);
			return new ResponseEntity<>(gugun, HttpStatus.OK);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	// 게시글 상세 조회
	@GetMapping("{postId}")
	public String view(@PathVariable Integer postId, Model model) {

		try {
			PostEntity post = postService.getPost(postId);

			model.addAttribute("post", post);

			log.info("post : {}", post);

		} catch (IOException e) {
			throw new RuntimeException(e);
		}
		return "posting/view";
	}

	@PostMapping("/delete/{postId}")
	public String deletePost(@PathVariable Integer postId, HttpSession session) {

		DeletePost deletePost = DeletePost.builder()
			.userId(((MemberEntity)session.getAttribute("memberDto")).getUserId())
			.postId(postId)
			.build();

		try {
			postService.deletePost(deletePost);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		return "redirect:/posting/list";
	}

	//수정
	@GetMapping("/modify/{postId}")
	public String modifyForm(@PathVariable Integer postId, Model model, HttpSession session) {

		PostEntity post = null;

		try {
			post = postService.getPost(postId);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		post.setUserId(((MemberEntity)session.getAttribute("memberDto")).getUserId());
		model.addAttribute("post", post);

		return "/posting/modify";
	}

	@PostMapping("/modify/{postId}")
	public String modify(@PathVariable Integer postId,
		@Validated Update update,
		BindingResult bindingResult,
		Model model,
		HttpSession session) {

		if (bindingResult.hasErrors()) {

			log.info("error : {}", bindingResult.getAllErrors());

			return "posting/modify/" + postId;
		}

		String userId = ((MemberEntity)session.getAttribute("memberDto")).getUserId();
		update.setUserId(userId);
		update.setPostId(postId);

		try {
			postService.modifyPost(update);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		return "redirect:/posting/list";
	}
}