package com.cuppaHouse.Service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cuppaHouse.Service.LoginService;
import com.cuppaHouse.vo.MemberVo;
import com.cuppaHouse.Mappers.LoginMapper;
import com.cuppaHouse.Util.Encrypt;

@Service
public class LoginServiceImpl implements LoginService {

	@Autowired
	private LoginMapper loginMapper;
	
	@Override
	public String getPasswordCheck(MemberVo vo, HttpServletRequest request) {

		HttpSession session = request.getSession();
		MemberVo regMember = loginMapper.getPassword(vo);
		String url = null;

		if(regMember == null){
			url = "login_fail";
		}else{
			String sha512Pwd = Encrypt.setSHA512(vo.getPass(), regMember.getPasswordKey());
			if(!regMember.getId().equals(null) && sha512Pwd.equals(regMember.getPass())){ // 비밀번호 일치 하는 경우

				regMember = loginMapper.getMemberInfo(vo);
				
				session.setAttribute("id", regMember.getId());
				session.setAttribute("pass", regMember.getPass());
				session.setAttribute("name", regMember.getName());
				session.setAttribute("pnum", regMember.getPnum());
				session.setAttribute("activeYn", (Boolean)regMember.isActiveYn());
				session.setAttribute("lateassDt", regMember.getLateassDt());
				session.setAttribute("dept", regMember.getDept());
				session.setAttribute("auth", regMember.getAuth());
				session.setAttribute("position", regMember.getPosition());

				if( !regMember.isActiveYn()){
					url = "login_auth_fail";
					session.invalidate();
				}else{
					url = "login";
				}
					
			}else{  // 비밀번호 불일치
				 session.invalidate();
					url = "login_fail";
			}
		}
		return url;
	}
	
	
	@Override
	public void updateLoginTime(MemberVo vo){
		SimpleDateFormat timeFormat = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");		
		Date time = new Date();
		String loginTime = timeFormat.format(time);
		vo.setLateassDt(loginTime);
		loginMapper.updateLoginTime(vo);
	}
	
	@Override
	public void autoLogin(String id, HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVo memberVo = new MemberVo();
		memberVo.setId(id);
		memberVo = loginMapper.getMemberInfo(memberVo);
		
		if(memberVo != null ){
			session.setAttribute("id", memberVo.getId());
			session.setAttribute("pass", memberVo.getPass());
			session.setAttribute("name", memberVo.getName());
			session.setAttribute("pnum", memberVo.getPnum());
			session.setAttribute("activeYn", memberVo.isActiveYn());
			session.setAttribute("lateassDt", memberVo.getLateassDt());
			session.setAttribute("dept", memberVo.getDept());
			session.setAttribute("auth", memberVo.getAuth());
			session.setAttribute("position", memberVo.getPosition());
		}
			
	}
	
	@Override
	public String logOut(HttpServletRequest request) {
		HttpSession session = request.getSession();
		System.out.println("session invalidate!!");
		session.invalidate();
		return "/";
		
	}
	
}