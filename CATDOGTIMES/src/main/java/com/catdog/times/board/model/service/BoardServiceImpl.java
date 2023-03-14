package com.catdog.times.board.model.service;

import com.catdog.times.board.model.dto.Board;
import com.catdog.times.board.model.dto.Reply;
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

	//댓글 조회(게시글 번호)
	@Override
	public List<Reply> findReplyByBoardNo(int boardNo) {
		return mapper.selectReplyByBoardNo(boardNo);
	}

	@Override
	public int deleteBoardReply(String no) {
		return mapper.deleteBoardReply(no);
	}

	@Override
	public int insertBoardReply(Reply reply) {
		int result = 0;
		//등록일 경우
		if (reply.getNo() == null || "".equals(reply.getNo())) {

			if (reply.getParent() != null) {
				//Reply replyInfo = sqlSession.selectOne("selectBoardReplyParent", reply.getParent());
				Reply replyInfo = mapper.selectBoardReplyParent(reply.getParent());
				reply.setDepth(replyInfo.getDepth());
				reply.setOrder(replyInfo.getOrder() + 1);
				mapper.updateBoardReplyOrder(replyInfo);
			} else {
				//Integer reorder = sqlSession.selectOne("selectBoardReplyMaxOrder", reply.getBoardNo());
				Integer reOrder = mapper.selectBoardReplyMaxOrder(reply.getBoardNo());
				reply.setOrder(reOrder);
			}

			//result = sqlSession.insert("insertBoard6Reply", reply);
			result = mapper.insertBoardReply(reply);
		} else {
			//result = sqlSession.insert("updateBoard6Reply", reply);
			result = mapper.updateBoardReply(reply);
		}
		return result;
	}

	@Override
	public int updateBoardReply(Reply reply) {
		return mapper.updateBoardReply(reply);
	}


}
