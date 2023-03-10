package com.catdog.times.member.model.service;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.catdog.times.member.model.dto.Member;
import com.catdog.times.member.model.mapper.MemberMapper;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;


@Service
@Slf4j
public class MemberServiceImpl implements MemberService {
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	private MemberMapper mapper;
	
	@Override
	public Member findMemberById(String id) {
		return mapper.selectMemberById(id);
	}
	
	@Override
	public Member login(String id, String password) {
		Member member = null;
		member = this.findMemberById(id);
		
		if(member != null && passwordEncoder.matches(password, member.getPassword())) {
			return member;
		} else {
			return null;
		}
	}

	@Override
	@Transactional
	public int save(Member member) {
		int result = 0;
		
		if(member.getNo() != 0) {
			//// update
			//result = mapper.updateMember(member);
		} else {
			// insert
			member.setPassword(passwordEncoder.encode(member.getPassword()));
			
			result = mapper.insertMember(member);
		}
		
		return result;
	}
	//아이디 중복체크
	@Override
	public int idCheck(String id) {
		int cnt = mapper.idCheck(id);
		return cnt;
	}
	//닉네임 체크
	@Override
	public int nickNameCheck(String nickName) {
		int cnt = mapper.nickNameCheck(nickName);
		return cnt;
	}	
	
	//
    @Override
    public String kakaoJoin(Member member) {
    	member.setPassword(passwordEncoder.encode(member.getSnsId()));
        mapper.kakaoInsert(member);
        String no = Integer.toString(member.getNo());
        log.info("userid:: " + member.getId());
        return no;
    }

    @Override
    public Member kakaoLogin(String memberSnsId) {
        log.info("snsId:: " + memberSnsId);
        return mapper.kakaoSelect(memberSnsId);
    }
	//네이버로그인
    @Override
    public void naverJoin(Member member) {
    	member.setPassword(passwordEncoder.encode(member.getSnsId()));
        mapper.naverInsert(member);
        String memberId = member.getId();
        log.info("userid:: " + memberId);
    }

    @Override
    public Member naverLogin(String memberSnsId) {
        log.info("snsId:: " + memberSnsId);
        return mapper.naverSelect(memberSnsId);
    }
    
    @Override
    public String findMemberBySnsId(String memberSnsId) {
        log.info("snsId:: " + memberSnsId);
        return mapper.findMemberBySnsId(memberSnsId);
    }
    
    @Override
    public String findMemberByEmail(String memberEmail) {
        log.info("snsId:: " + memberEmail);
        return mapper.findMemberByEmail(memberEmail);
    }
}
