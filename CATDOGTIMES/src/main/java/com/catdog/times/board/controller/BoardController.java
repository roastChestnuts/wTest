package com.catdog.times.board.controller;

import com.catdog.times.board.model.dto.Board;
import com.catdog.times.board.model.service.BoardService;
import com.catdog.times.common.util.MultipartFileUtil;
import com.catdog.times.common.util.PageInfo;
import com.catdog.times.member.model.dto.Member;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
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

    @GetMapping("/delete")
    public ModelAndView delete(ModelAndView model,
                               @AuthenticationPrincipal Member member,
                               @RequestParam int no) {
        int result = 0;
        Board board = null;

        board = service.findBoardByNo(no);

        if(board.getWriterId().equals(member.getId())) {
            result = service.delete(no);

            if(result > 0) {
                model.addObject("msg", "게시글이 정상적으로 삭제되었습니다.");
                model.addObject("location", "/board/list");
            } else {
                model.addObject("msg", "게시글 삭제를 실패하였습니다.");
                model.addObject("location", "/board/view?no=" + no);
            }
        } else {
            model.addObject("msg", "잘못된 접근입니다.");
            model.addObject("location", "/board/list");
        }

        model.setViewName("common/msg");

        return model;
    }

    @GetMapping("/write")
    public String write() {
        log.info("게시글 작성 페이지 요청");

        return "board/write";
    }

    @PostMapping("/write")
    public ModelAndView write(ModelAndView model,
                              @ModelAttribute Board board,
                              @RequestParam(value="upfile", required = true) MultipartFile upfile,
                              @AuthenticationPrincipal Member member) {

        int result = 0;

//		파일을 업로드하지 않으면 true, 파일을 업로드하면 false
        log.info("Upfile is Empty : {}", upfile.isEmpty());
//		파일을 업로드하지 않으면 "", 파일을 업로드하면 "파일명"
        log.info("Upfile Name : {}", upfile.getOriginalFilename());

        // 1. 파일을 업로드 했는지 확인 후 파일을 저장
        if(upfile != null && !upfile.isEmpty()) {
            // 파일을 저장하는 로직 작성
            String location = null;
            String renamedFileName = null;

            try {
                location = resourceLoader.getResource("resources/upload/board").getFile().getPath();
                renamedFileName = MultipartFileUtil.save(upfile, location);
            } catch (IOException e) {
                e.printStackTrace();
            }

            if(renamedFileName != null) {
                board.setOriginalFileName(upfile.getOriginalFilename());
                board.setRenamedFileName(renamedFileName);
            }
        }

        // 2. 작성한 게시글 데이터를 데이터 베이스에 저장
        board.setWriterNo(member.getNo());
        result = service.save(board);

        if(result > 0) {
            model.addObject("msg", "게시글이 정상적으로 등록되었습니다.");
            model.addObject("location", "/board/view?no=" + board.getNo());
        } else {
            model.addObject("msg", "게시글 등록을 실패하였습니다.");
            model.addObject("location", "/board/write");
        }

        model.setViewName("common/msg");

        return model;
    }
    @GetMapping("/fileDown")
    public ResponseEntity<Resource> fileDown(@RequestHeader("user-agent") String userAgent,
                                             @RequestParam String oname, @RequestParam String rname) {

        Resource resource = null;
        String downFileName = null;

        log.info("oname : {}, rname : {}", oname, rname);
        log.info("{}", userAgent);

        try {
            resource = resourceLoader.getResource("resources/upload/board/" + rname);

            if(userAgent.indexOf("MSIE") != -1 || userAgent.indexOf("Trident") != -1) {
                downFileName = URLEncoder.encode(oname, "UTF-8").replaceAll("\\+", "%20");
            } else {
                downFileName = new String(oname.getBytes("UTF-8"), "ISO-8859-1");
            }

            return ResponseEntity.ok()
                                 .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE)
                                 .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + downFileName)
                                 .body(resource);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/update")
    public ModelAndView update(ModelAndView model,
                               @RequestParam int no,
                               @AuthenticationPrincipal Member member) {
        Board board = null;

        board = service.findBoardByNo(no);

        if(board.getWriterId().equals(member.getId())) {
            model.addObject("board", board);
            model.setViewName("board/update");
        } else {
            model.addObject("msg", "잘못된 접근입니다.");
            model.addObject("location", "/board/list");
            model.setViewName("common/msg");
        }

        return model;
    }
    @PostMapping("/update")
    public ModelAndView update(ModelAndView model,
                               @ModelAttribute Board board,
                               @RequestParam("upfile") MultipartFile upfile,
                               @AuthenticationPrincipal Member member) {
        int result = 0;
        String location = null;
        String renamedFileName = null;

        if(service.findBoardByNo(board.getNo()).getWriterId().equals(member.getId())) {
            if(upfile != null && !upfile.isEmpty()) {
                try {
                    location = resourceLoader.getResource("resources/upload/board").getFile().getPath();

                    if(board.getRenamedFileName() != null) {
                        // 이전에 업로드 된 첨부 파일이 존재하면 삭제
                        MultipartFileUtil.delete(location + "/" + board.getRenamedFileName());
                    }

                    renamedFileName = MultipartFileUtil.save(upfile, location);

                    if(renamedFileName != null) {
                        board.setOriginalFileName(upfile.getOriginalFilename());
                        board.setRenamedFileName(renamedFileName);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            result = service.save(board);

            if(result > 0) {
                model.addObject("msg", "게시글이 정상적으로 수정되었습니다.");
                model.addObject("location", "/board/view?no=" + board.getNo());
            } else {
                model.addObject("msg", "게시글 수정을 실패하였습니다.");
                model.addObject("location", "/board/update?no=" + board.getNo());
            }
        } else {
            model.addObject("msg", "잘못된 접근입니다.");
            model.addObject("location", "/board/list");
        }

        model.setViewName("common/msg");

        return model;
    }
}
