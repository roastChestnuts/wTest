
package com.catdog.times.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;


//화면에서 입력한 로그인 정보와 DB에서 가져온 사용자의 정보를 비교해주는 인터페이스
public class CustomAuthenticationProvider implements AuthenticationProvider {
	
	@Autowired
	private CustomUserDetailsService CustomUserDetailsService;
	
	@Autowired
	private PasswordEncoder passwordEncoder;

	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		
		String id = (String) authentication.getPrincipal();
		String pwd = (String) authentication.getCredentials();
		
		UsernamePasswordAuthenticationToken authToken = (UsernamePasswordAuthenticationToken) authentication;
		
		UserDetails user = CustomUserDetailsService.loadUserByUsername(authToken.getName());

		if (user == null) {
			throw new UsernameNotFoundException(id);
		}
		
		if(!passwordEncoder.matches(pwd, user.getPassword())) {
			throw new BadCredentialsException(id);
		}
		
		if (!user.isEnabled()) {
			throw new BadCredentialsException(id);
		}
		
		return new UsernamePasswordAuthenticationToken(id, pwd, user.getAuthorities());
	} 
	
	@Override
	public boolean supports(Class<?> authentication) {
    	return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}

}




