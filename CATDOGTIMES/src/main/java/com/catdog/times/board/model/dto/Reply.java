package com.catdog.times.board.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Reply {
	private int no;
	
	private int boardNo;
	
	private int writerNo;
	
	private String writerId;
	
	private String content;	
	
	private Date createDate;
	
	private Date modifyDate;
}
