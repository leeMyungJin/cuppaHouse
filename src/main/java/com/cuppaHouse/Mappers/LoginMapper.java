package com.cuppaHouse.Mappers;


import com.cuppaHouse.vo.MemberVo;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LoginMapper  {
	public MemberVo getPassword(MemberVo vo);
    public void updateLoginTime(MemberVo vo);
    
    public String getUserToken(HashMap<String, String> params);
    
    public MemberVo getMemberInfo(MemberVo vo);
}
