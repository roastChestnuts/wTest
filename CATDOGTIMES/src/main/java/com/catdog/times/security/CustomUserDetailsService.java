package com.catdog.times.security;

import com.catdog.times.member.model.dto.Member;
import com.catdog.times.member.model.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {
    @Autowired
    private MemberMapper mapper;

    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
        Member member = mapper.selectMemberById(id);

        if(member == null) {
            throw new UsernameNotFoundException("user Not Found");
        }
        return member;
    }

}
