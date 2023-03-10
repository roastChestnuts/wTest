package com.catdog.times.security;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class CustomLoginFailHandler implements AuthenticationFailureHandler {	
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		
		String errorMessage;
		
		if (exception instanceof BadCredentialsException) {
			errorMessage = "아이디 또는 비밀번호가 틀렸습니다.";
		} else if (exception instanceof InternalAuthenticationServiceException) {
			errorMessage = "내부적으로 문제가 발생했습니다.";
		} else if (exception instanceof DisabledException) {
			errorMessage = "사용할 수 없는 계정입니다. 관리자에게 문의하세요.";
		} else if (exception instanceof UsernameNotFoundException) {
			errorMessage = "계정이 존재하지 않습니다.";
		} else {
			errorMessage = "알 수 없는 이유로 로그인에 실패하였습니다.";
		}

		request.setAttribute("errorMessage", errorMessage);
		request.getRequestDispatcher("/member/loginError").forward(request, response);
	}
}



