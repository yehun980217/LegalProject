package com.kpaas.kpaasproject.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class CommentDTO {
    private int commentNo;
    private int postNo;
    private int userNo;
    private String userId;
    private String content;
    private Date createdDate;
}
