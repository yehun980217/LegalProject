package com.kpaas.kpaasproject.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.List;

@Getter
@Setter
public class PostDTO {
    private int postNo;
    private int userNo;
    private String userId;
    private String title;
    private String content;
    private Date createdDate;
    private String category;
    private Date updatedDate;
    private List<CommentDTO> comments;  // 게시글에 달린 댓글 리스트
}
