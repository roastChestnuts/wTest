package com.catdog.times.member.model.service;

import java.io.IOException;
import java.util.Map;

import com.catdog.times.member.model.dto.Member;

public interface MemberService {

	Member findMemberById(String id); //아이디찾기
	
	Member login(String id, String password); // 로그인

	int save(Member member); //회원가입

	public int idCheck(String id);// 아이디 중복체크

	public int nickNameCheck(String nickName);// 닉네임 중복체크
	
	String kakaoJoin(Member member); //카카오
	
	Member kakaoLogin(String memberSnsId);
	
    public void naverJoin(Member member); //네이버 
    
    Member naverLogin(String memberSnsId);
    
	String findMemberBySnsId(String memberSnsId);

	String findMemberByEmail(String memberEmail);
	
	//int delete(int no); //회원삭제
}
