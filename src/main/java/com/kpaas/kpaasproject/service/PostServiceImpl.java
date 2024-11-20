package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.CommentDTO;
import com.kpaas.kpaasproject.dto.PageDTO;
import com.kpaas.kpaasproject.dto.PostDTO;
import com.kpaas.kpaasproject.mapper.PostMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostServiceImpl implements PostService {

    @Autowired
    private PostMapper postMapper;

    @Override
    public List<PostDTO> getPostsByPage(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return postMapper.getPostsByPage(offset, pageSize);
    }

    @Override
    public PageDTO getPaginationInfo(int currentPage, int pageSize) {
        int totalPosts = postMapper.getTotalPostCount();
        int totalPages = (int) Math.ceil((double) totalPosts / pageSize);

        PageDTO pageDto = new PageDTO(currentPage, totalPosts, pageSize);
        pageDto.setCurrentPage(currentPage);
        pageDto.setTotalPages(totalPages);
        pageDto.setFirstPage(currentPage == 1);
        pageDto.setLastPage(currentPage == totalPages);

        return pageDto;
    }

    @Override
    public PageDTO getCategoryPaginationInfo(String category, int currentPage, int pageSize) {
        int totalPosts = postMapper.getCategoryTotalPostCount(category);
        int totalPages = (int) Math.ceil((double) totalPosts / pageSize);

        PageDTO pageDto = new PageDTO(currentPage, totalPosts, pageSize);
        pageDto.setCurrentPage(currentPage);
        pageDto.setTotalPages(totalPages);
        pageDto.setFirstPage(currentPage == 1);
        pageDto.setLastPage(currentPage == totalPages);

        return pageDto;
    }

    @Override
    public List<PostDTO> getPostsByCategory(String category, int page, int pageSize) {
        int offset = (page - 1) * 10;
        return postMapper.getPostsByCategory(category, offset, 10);
    }

    @Override
    public int createPost(PostDTO postDTO) {
        postMapper.insertPost(postDTO);
        return postDTO.getPostNo(); // 방금 생성된 postNo 반환
    }



    @Override
    public PostDTO getPostByNo(int postNo) {
        return postMapper.getPostByNo(postNo);
    }

    @Override
    public List<CommentDTO> getCommentsByPostNo(int postNo) {
        return postMapper.getCommentsByPostNo(postNo);
    }

    @Override
    public void addComment(CommentDTO commentDTO) {
        postMapper.insertComment(commentDTO);
    }

    @Override
    public CommentDTO getCommentByNo(int commentNo) {
        return postMapper.getCommentByNo(commentNo);
    }

    @Override
    public void deleteComment(int commentNo) {
        postMapper.deleteComment(commentNo);
    }

    @Override
    public void updatePost(PostDTO postDTO) {
        postMapper.updatePost(postDTO);
    }

    @Override
    public void deletePost(int postNo) {
        postMapper.deletePost(postNo);
    }

    @Override
    public int getUserPostCount(int userNo) {
        return postMapper.countUserPosts(userNo);
    }

    @Override
    public List<PostDTO> getPostsByUser(int userNo, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return postMapper.findPostsByUser(userNo, offset, pageSize);
    }

    @Override
    public int getUserCommentCount(int userNo) {
        return postMapper.countUserComments(userNo);
    }

    @Override
    public List<CommentDTO> getCommentsByUser(int userNo, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return postMapper.findCommentsByUser(userNo, offset, pageSize);
    }

}
