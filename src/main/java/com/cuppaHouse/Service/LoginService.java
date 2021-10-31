package com.cuppaHouse.Service;

import javax.servlet.http.HttpServletRequest;

import com.cuppaHouse.vo.MemberVo;


public interface LoginService {
	
	public String getPasswordCheck(MemberVo vo, HttpServletRequest request);
	
	public void updateLoginTime(MemberVo vo);
	
	public void autoLogin(String id, HttpServletRequest request);

	public String logOut(HttpServletRequest request);

}