package com.cuppaHouse.Service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.cuppaHouse.vo.MemberVo;
import com.cuppaHouse.Mappers.LoginMapper;
import com.cuppaHouse.Util.Encrypt;
import com.cuppaHouse.Util.Util;
import com.cuppaHouse.Mappers.BuildingMapper;
import com.cuppaHouse.Mappers.MemberMapper;
import com.cuppaHouse.Service.BuildingService;
import com.cuppaHouse.Service.MemberService;

@Service
public class MemberServiceImpl implements MemberService{

	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
	private LoginMapper login;
	
	public HashMap<String,Object> getMemberTotal(){
		return memberMapper.getMemberTotal();
	}
	
	@Override
	public List<MemberVo> getMemberList(HashMap<String,Object> params){
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		                		
		List<MemberVo> MemberList = memberMapper.getMemberList(params);
		return MemberList;
	}
	
	@Override
	public String dupCheckId(HashMap<String, String> params) {
		return memberMapper.dupCheckId(params);
	}

	@Override
	public void saveNewMember(MemberVo vo){
		memberMapper.saveNewMember(vo);
	}
	
	@Override
	public void deleteMember(HashMap<String, String> params) {
		memberMapper.deleteMember(params);
		
	}
	
	@Override
	public void updateMember(HashMap<String, String> params) {
		String id = params.get("id");
		String password = params.get("password");
		if(password != ""){
			MemberVo usr = new MemberVo();
			usr.setId(id);
			usr = login.getPassword(usr);	
			String shaPwd = Encrypt.setSHA512(password, usr.getPasswordKey());
			params.replace("password", shaPwd);
		}
		memberMapper.updateMember(params);
	}
	
	@Override
	public MemberVo getAppVersion(){
    	
    	return memberMapper.getAppVersion();
    }
	
	@Override
	public void saveAppVersion(@RequestParam HashMap<String,Object> params){
    	
		memberMapper.saveAppVersion(params);
    }
	
	public List<MemberVo> getChooseMemberList(@RequestParam HashMap<String,Object> params){
		if(params.get("type") != null)
			params.replace("type", Util.makeForeach((String)params.get("type"), ","));
    	
    	List<MemberVo> memberList = memberMapper.getChooseMemberList(params);
    	
    	return memberList;
    }

}