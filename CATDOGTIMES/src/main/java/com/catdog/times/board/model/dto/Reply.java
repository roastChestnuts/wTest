package com.catdog.times.board.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Reply {
	private String no;	//댓글 번호
	
	private String boardNo; //게시물 번호

	private String parent; // 부모

	private String depth; // 댓글 깊이

	private int order; // 그룹내 순서

	private int writerNo; //작성자no
	
	private String writerId;//작성자id
	
	private String content;	//댓글내용
	
	private Date createDate; //댓글작성일자
	
	private Date modifyDate; //댓글수정일자
}
