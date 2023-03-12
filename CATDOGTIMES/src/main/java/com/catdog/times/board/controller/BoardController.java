package com.catdog.times.board.controller;

import com.catdog.times.board.model.dto.Board;
import com.catdog.times.board.model.service.BoardService;
import com.catdog.times.common.util.PageInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Slf4j
@Controller
@RequestMapping(value = "/board")
public class BoardController {
    @Autowired
    private BoardService service;

    @Autowired
    private ResourceLoader resourceLoader;

    @GetMapping("/list")
    public ModelAndView list(ModelAndView model,
                             @RequestParam(value = "page", defaultValue = "1") int page) {

        List<Board> list = null;
        PageInfo pageInfo = null;

        pageInfo = new PageInfo(page, 10, service.getBoardCount(), 10);
        list = service.getBoardList(pageInfo);

        model.addObject("list", list);
        model.addObject("pageInfo", pageInfo);
        model.setViewName("board/list");

        return model;
    }

    @GetMapping("/view")
    public ModelAndView view(ModelAndView model, @RequestParam int no){
        Board board = null;

        board = service.findBoardByNo(no);

        model.addObject("board", board);
        model.setViewName("board/view");

        return model;
    }
}
