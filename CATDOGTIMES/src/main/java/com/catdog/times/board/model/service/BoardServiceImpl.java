package com.catdog.times.board.model.service;

import com.catdog.times.board.model.dto.Board;
import com.catdog.times.common.util.PageInfo;
import com.catdog.times.board.model.mapper.BoardMapper;
import com.catdog.times.board.model.dto.Board;
import com.catdog.times.common.util.PageInfo;
import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class BoardServiceImpl implements BoardService {
	@Autowired
	private BoardMapper mapper;

	@Override
	public int getBoardCount() {
		
		return mapper.selectBoardCount();
	}

	@Override
	public List<Board> getBoardList(PageInfo pageInfo) {
		int offset = (pageInfo.getCurrentPage() - 1) * pageInfo.getListLimit();
		int limit = pageInfo.getListLimit();
		RowBounds rowBounds = new RowBounds(offset, limit);			
		
		return mapper.selectAll(rowBounds);
	}

	@Override
	public Board findBoardByNo(int no) {
		
		return mapper.selectBoardByNo(no);
	}

	@Override
	@Transactional
	public int delete(int no) {
		int result = 0;
		
		result = mapper.updateStatus(no, "N");
		
		return result;
	}

	@Override
	@Transactional
	public int save(Board board) {
		int result = 0;
		
		if(board.getNo() != 0) {
			// update
			result = mapper.updateBoard(board);
		} else {
			// insert
			result = mapper.insertBoard(board);
		}
				
		return result;
	}
	
	
	
	
	
	
	
	
	

}
