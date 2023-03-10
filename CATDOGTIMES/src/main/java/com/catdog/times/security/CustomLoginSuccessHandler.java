package com.catdog.times.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

    private static int TIME = 60 * 60; // 세션 유지 시간 (1시간)

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        //request.getSession().setMaxInactiveInterval(TIME);

        List<String> authNames = new ArrayList<String>();

        for(GrantedAuthority auth : authentication.getAuthorities()) {
            authNames.add(auth.getAuthority());
        }

        if(authNames.contains("ROLE_ADMIN")) {
            response.sendRedirect("/");
            return;
        }

        if(authNames.contains("ROLE_USER")) {
            response.sendRedirect("/");
            return;
        }
        //로그인 실패시 다시 로그인 페이지로 리다이렉트
        response.sendRedirect("/member/login");
    }
}
