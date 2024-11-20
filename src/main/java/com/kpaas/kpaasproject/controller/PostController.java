package com.kpaas.kpaasproject.controller;

import com.kpaas.kpaasproject.dto.CommentDTO;
import com.kpaas.kpaasproject.dto.PageDTO;
import com.kpaas.kpaasproject.dto.PostDTO;
import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.service.PostService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class PostController {

    @Autowired
    private PostService postService;

    @GetMapping("/post/listPost")
    public String listPosts(@RequestParam(value = "page", defaultValue = "1") int page, Model model, HttpSession session) {

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        int pageSize = 10;  // 한 페이지에 보여줄 게시글 수
        List<PostDTO> posts = postService.getPostsByPage(page, pageSize);
        PageDTO pageDto = postService.getPaginationInfo(page, pageSize);

        model.addAttribute("posts", posts);
        model.addAttribute("pageDto", pageDto);

        return "post/listPost";  // listPost.jsp로 이동
    }

    @GetMapping("/post/listPostByCategory")
    public String listPostsByCategory(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model, HttpSession session) {

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        System.out.println("category: "+category);

        int pageSize = 10;  // 한 페이지에 보여줄 게시글 수

        List<PostDTO> posts = postService.getPostsByCategory(category, page, pageSize);
        PageDTO pageDto = postService.getCategoryPaginationInfo(category, page, pageSize);

        model.addAttribute("posts", posts);
        model.addAttribute("pageDto", pageDto);
        model.addAttribute("category", category); // 선택된 카테고리도 모델에 추가

        return "post/listPost";
    }

    @GetMapping("/post/writePost")
    public String writePost(HttpSession session) {
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login"; // 비로그인 사용자는 로그인 페이지로 리다이렉트
        }
        return "post/writePost";
    }

    @PostMapping("/post/createPost")
    public String createPost(
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam("category") String category,
            HttpSession session) {

        // 로그인한 사용자 정보 가져오기
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            return "redirect:/login"; // 비로그인 사용자는 로그인 페이지로 리다이렉트
        }

        // 글 작성 서비스 호출
        PostDTO postDTO = new PostDTO();
        postDTO.setTitle(title);
        postDTO.setContent(content);
        postDTO.setCategory(category);
        postDTO.setUserNo(loggedInUser.getUserNo()); // 작성자 정보 설정

        int postNo = postService.createPost(postDTO); // 새 글 작성 후 postNo 반환

        // 글 작성 후 리스트 페이지로 리다이렉트
        return "redirect:post/listPost";
    }



    @GetMapping("/post/detailPost")
    public String detailPost(@RequestParam("postNo") int postNo, Model model, HttpSession session) {

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        // 게시글 정보 가져오기
        PostDTO post = postService.getPostByNo(postNo);

        // 댓글 및 이미지 정보도 가져와서 모델에 추가
        List<CommentDTO> comments = postService.getCommentsByPostNo(postNo);

        if (loggedInUser != null) {
            System.out.println("로그인한 사용자 번호: " + loggedInUser.getUserNo());
            System.out.println("게시글 작성자 번호: " + post.getUserNo());
            System.out.println("작성자 여부: " + (loggedInUser.getUserNo() == post.getUserNo()));
            model.addAttribute("isOwner", loggedInUser.getUserNo() == post.getUserNo()); // 작성자 여부 확인
        } else {
            model.addAttribute("isOwner", false);
        }

        post.setComments(comments);

        model.addAttribute("post", post);

        return "post/detailPost";  // detailPost.jsp로 이동
    }

    @PostMapping("/post/addComment")
    public String addComment(
            @RequestParam("postNo") int postNo,
            @RequestParam("content") String content,
            HttpSession session) {

        // 로그인한 사용자 정보 가져오기
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            return "redirect:/login"; // 비로그인 사용자는 로그인 페이지로 리다이렉트
        }

        // 댓글 정보 설정
        CommentDTO commentDTO = new CommentDTO();
        commentDTO.setPostNo(postNo);
        commentDTO.setUserNo(loggedInUser.getUserNo());
        commentDTO.setContent(content);

        // 댓글 저장 서비스 호출
        postService.addComment(commentDTO);

        // 댓글 작성 후 해당 게시글의 상세 페이지로 리다이렉트
        return "post/detailPost?postNo=" + postNo;
    }

    @PostMapping("/post/deleteComment")
    public String deleteComment(
            @RequestParam("commentNo") int commentNo,
            @RequestParam("postNo") int postNo,
            HttpSession session,
            RedirectAttributes rttr) {

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        CommentDTO comment = postService.getCommentByNo(commentNo);

        // 작성자이거나 관리자인 경우에만 삭제 가능
        if (loggedInUser == null ||
                (comment == null ||
                        (comment.getUserNo() != loggedInUser.getUserNo() && !"admin".equals(loggedInUser.getUserGrade())))) {
            rttr.addFlashAttribute("message", "본인의 댓글만 삭제할 수 있습니다.");
            return "redirect:post/detailPost?postNo=" + postNo;
        }

        postService.deleteComment(commentNo);  // 댓글 삭제 서비스 호출
        return "redirect:post/detailPost?postNo=" + postNo;  // 삭제 후 게시글 상세 페이지로 이동
    }



    @GetMapping("/post/editPost")
    public String editPost(@RequestParam("postNo") int postNo, Model model, HttpSession session) {
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        PostDTO post = postService.getPostByNo(postNo);

        // 로그인한 사용자와 게시글 작성자가 일치하지 않으면 수정 불가
        if (loggedInUser == null || loggedInUser.getUserNo() != post.getUserNo()) {
            return "post/listPost"; // 권한이 없으면 리스트 페이지로 리다이렉트
        }

        model.addAttribute("post", post);
        return "post/editPost";  // editPost.jsp로 이동
    }

    @PostMapping("/post/updatePost")
    public String updatePost(
            @RequestParam("postNo") int postNo,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam("category") String category,
            HttpSession session) {

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        PostDTO post = postService.getPostByNo(postNo);

        // 로그인한 사용자와 게시글 작성자가 일치하지 않으면 수정 불가
        if (loggedInUser == null || loggedInUser.getUserNo() != post.getUserNo()) {
            return "post/listPost"; // 권한이 없으면 리스트 페이지로 리다이렉트
        }

        post.setTitle(title);
        post.setContent(content);
        post.setCategory(category);

        postService.updatePost(post);  // 게시글 수정 서비스 호출

        return "post/detailPost?postNo=" + postNo;  // 수정 후 상세보기 페이지로 이동
    }


    @PostMapping("/post/deletePost")
    public String deletePost(@RequestParam("postNo") int postNo, HttpSession session) {
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        PostDTO post = postService.getPostByNo(postNo);

        // 작성자이거나 관리자인 경우에만 삭제 가능
        if (loggedInUser == null ||
                (loggedInUser.getUserNo() != post.getUserNo() && !"admin".equals(loggedInUser.getUserGrade()))) {
            return "post/listPost";  // 권한이 없으면 리스트 페이지로 리다이렉트
        }

        postService.deletePost(postNo);  // 게시글 삭제 서비스 호출
        return "post/listPost";  // 삭제 후 리스트 페이지로 이동
    }

    @GetMapping("/user/myPosts")
    public String getMyPosts(
            HttpSession session,
            Model model,
            @RequestParam(value = "page", defaultValue = "1") int page) {

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        int pageSize = 10;  // 한 페이지에 보여줄 게시글 수
        int totalItems = postService.getUserPostCount(loggedInUser.getUserNo());  // 총 게시글 수 조회
        PageDTO pageDto = new PageDTO(page, totalItems, pageSize);

        List<PostDTO> myPosts = postService.getPostsByUser(loggedInUser.getUserNo(), page, pageSize);
        model.addAttribute("myPosts", myPosts);
        model.addAttribute("pageDto", pageDto);

        return "user/myPosts";  // myPosts.jsp 페이지로 이동
    }

    @GetMapping("/user/myComments")
    public String getMyComments(
            HttpSession session,
            Model model,
            @RequestParam(value = "page", defaultValue = "1") int page) {

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        int pageSize = 10;  // 한 페이지에 보여줄 댓글 수
        int totalItems = postService.getUserCommentCount(loggedInUser.getUserNo());  // 총 댓글 수 조회
        PageDTO pageDto = new PageDTO(page, totalItems, pageSize);

        List<CommentDTO> myComments = postService.getCommentsByUser(loggedInUser.getUserNo(), page, pageSize);
        model.addAttribute("myComments", myComments);
        model.addAttribute("pageDto", pageDto);

        return "user/myComments";  // myComments.jsp 페이지로 이동
    }


}