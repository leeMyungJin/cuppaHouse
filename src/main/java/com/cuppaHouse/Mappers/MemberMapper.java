package com.cuppaHouse.Mappers;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.cuppaHouse.vo.MemberVo;

@Mapper
public interface MemberMapper  {
	public HashMap<String,Object> getMemberTotal();
	
	public List<MemberVo> getMemberList(HashMap<String,Object> params);
	
	public String dupCheckId(HashMap<String,String>params);

	public void saveNewMember(MemberVo vo);
	
	public void deleteMember(HashMap<String,String>params);
	
	public void updateMember(HashMap<String,String> params);
	
	public MemberVo getAppVersion();
    
    public void saveAppVersion(HashMap<String,Object> params);
    
    public List<MemberVo> getChooseMemberList(HashMap<String,Object> params);
	
}
