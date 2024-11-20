package com.kpaas.kpaasproject.mapper;

import com.kpaas.kpaasproject.dto.CommentDTO;
import com.kpaas.kpaasproject.dto.PostDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PostMapper {
    List<PostDTO> getPostsByPage(int offset, int limit);  // 페이징 처리된 게시글 목록 조회
    int getTotalPostCount();  // 전체 게시글 수 조회

    int getCategoryTotalPostCount(String category);

    List<PostDTO> getPostsByCategory(String category, int offset, int limit);

    void insertPost(PostDTO postDTO);  // 글 저장


    PostDTO getPostByNo(@Param("postNo") int postNo);
    List<CommentDTO> getCommentsByPostNo(@Param("postNo") int postNo);

    void insertComment(CommentDTO commentDTO);

    CommentDTO getCommentByNo(int commentNo);
    void deleteComment(int commentNo);

    void updatePost(PostDTO postDTO);

    void deletePost(int postNo);

    int countUserPosts(@Param("userNo") int userNo);

    List<PostDTO> findPostsByUser(@Param("userNo") int userNo, @Param("offset") int offset, @Param("pageSize") int pageSize);

    int countUserComments(@Param("userNo") int userNo);

    List<CommentDTO> findCommentsByUser(@Param("userNo") int userNo, @Param("offset") int offset, @Param("pageSize") int pageSize);
}
