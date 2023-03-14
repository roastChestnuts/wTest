package com.catdog.times.board.model.mapper;

import com.catdog.times.board.model.dto.Board;
import com.catdog.times.board.model.dto.Board;
import com.catdog.times.board.model.dto.Reply;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.RowBounds;

import java.util.List;

@Mapper
public interface BoardMapper {
	int selectBoardCount();

	List<Board> selectAll(RowBounds rowBounds);

	Board selectBoardByNo(@Param("no") int no);

	int insertBoard(Board board);

	int updateBoard(Board board);
	
	int updateStatus(@Param("no")int no, @Param("status") String status);

	List<Reply> selectReplyByBoardNo(int boardNo);

	Reply selectBoardReplyParent(@Param("parent") String parent);

	int selectBoardReplyMaxOrder(@Param("boardNo")String boardNo);

	int updateBoardReplyOrder(Reply reply);

	int insertBoardReply(Reply reply);

	int updateBoardReply(Reply reply);

	int deleteBoardReply(String no);
}
