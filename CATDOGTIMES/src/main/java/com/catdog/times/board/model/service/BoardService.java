package com.catdog.times.board.model.service;

import com.catdog.times.board.model.dto.Board;
import com.catdog.times.common.util.PageInfo;
import com.catdog.times.board.model.dto.Board;
import com.catdog.times.common.util.PageInfo;

import java.util.List;

public interface BoardService {

	int getBoardCount();

	List<Board> getBoardList(PageInfo pageInfo);

	Board findBoardByNo(int no);

	int delete(int no);

	int save(Board board);

}
