package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.CommentDTO;
import com.kpaas.kpaasproject.dto.PageDTO;
import com.kpaas.kpaasproject.dto.PostDTO;

import java.util.List;

public interface PostService {
    List<PostDTO> getPostsByPage(int page, int pageSize);
    PageDTO getPaginationInfo(int currentPage, int pageSize);

    PageDTO getCategoryPaginationInfo(String category, int currentPage, int pageSize);

    List<PostDTO> getPostsByCategory(String category, int page, int pageSize);

    int createPost(PostDTO postDTO);  // 글 작성 후 postNo 반환

    PostDTO getPostByNo(int postNo);               // 게시글 정보 가져오기
    List<CommentDTO> getCommentsByPostNo(int postNo);  // 게시글에 달린 댓글 가져오기

    void addComment(CommentDTO commentDTO);

    CommentDTO getCommentByNo(int commentNo);
    void deleteComment(int commentNo);

    void updatePost(PostDTO postDTO);

    void deletePost(int postNo);

    int getUserPostCount(int userNo);

    List<PostDTO> getPostsByUser(int userNo, int page, int pageSize);

    int getUserCommentCount(int userNo);

    List<CommentDTO> getCommentsByUser(int userNo, int page, int pageSize);
}
