package com.cuppaHouse.Service;

import java.util.HashMap;
import java.util.List;

import org.springframework.web.bind.annotation.RequestParam;

import com.cuppaHouse.vo.MemberVo;

public interface MemberService {
	public HashMap<String,Object> getMemberTotal();
	
	public List<MemberVo> getMemberList(HashMap<String,Object> params);
    
    public String dupCheckId(HashMap<String,String> params);
    
    public void saveNewMember(MemberVo vo);
    
    public void deleteMember( HashMap<String,String> params);
    
    public void updateMember(HashMap<String,String> params);
    
    public MemberVo getAppVersion();
    
    public void saveAppVersion(HashMap<String,Object> params);
    
    public List<MemberVo> getChooseMemberList(HashMap<String,Object> params);

}