package com.catdog.times.member.model.dto;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Member implements UserDetails {
	private int no;
	
	private String id;
	
	private String password;
	
	private String name;
	
	private String gender;
	
	private String nickName;
	
	private String email;
	
	private String is; //
	
	private String photo;
	
	private String auth; // 권한 (ROLE_USER:이용자 / ROLE_ADMIN:운영자)
	
	private int warn; //
	
	private Date createDate; //
	
	private Date modifyDate; //

	private String address;
	
	private String zipcode;
	
	private String detailAddress;
	
	private String snsId;

	private int enabled;

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		ArrayList<GrantedAuthority> authList = new ArrayList<GrantedAuthority>();
		authList.add(new SimpleGrantedAuthority(auth));
		return authList;
	}

	@Override
	public String getUsername() {
		return this.id;
	}

	@Override
	public String getPassword() {
		return this.password;

	}
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return enabled==1?true:false;
	}
}
