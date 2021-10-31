package com.cuppaHouse.Controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cuppaHouse.Service.MemberService;
import com.cuppaHouse.Util.Encrypt;
import com.cuppaHouse.vo.MemberVo;

@Controller
@RequestMapping("/member")
public class MemberController {
    
	@Autowired
	MemberService memberService;
	
    @RequestMapping(value = "/", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveMember(Model model) {
    	return "member/member";
    }
    
    @RequestMapping(value = "/getMemberTotal")
    @ResponseBody
    public HashMap<String,Object> getMemberTotal(){
    	
    	return memberService.getMemberTotal();
    }
    
    @RequestMapping(value = "/getMemberList")
    @ResponseBody
    public List<MemberVo> getMemberList(@RequestParam HashMap<String,Object> params){
    	
    	List<MemberVo> memberList = memberService.getMemberList(params);
    	
    	return memberList;
    }
    
    /** 아이디 중복확인 */
    @RequestMapping(value = "/dupCheckId")
    @ResponseBody
    public String dupCheckId(@RequestParam HashMap<String,String> params){
            return memberService.dupCheckId(params);
    }    
    
    /**직원 등록 */
    @RequestMapping(value = "/saveNewMember")
    public void saveNewMember(HttpServletRequest req, HttpServletResponse res){
    	MemberVo memberInfo = new MemberVo();
        HttpSession session = req.getSession();

        // salt + SHA512 암호화 적용
        String password = req.getParameter("password");
        String password_key = Encrypt.getSaltKey();
        password = Encrypt.setSHA512(password, password_key);

        memberInfo.setId(req.getParameter("id"));
        memberInfo.setPass(password);
        memberInfo.setName(req.getParameter("name"));
        memberInfo.setPnum(req.getParameter("telPhone"));
        memberInfo.setMemo(req.getParameter("memo"));
        memberInfo.setPosition(req.getParameter("position"));
        memberInfo.setAuth(req.getParameter("auth"));
        memberInfo.setDept(req.getParameter("dept"));
        memberInfo.setBldgCd(req.getParameter("bldgCd"));
        memberInfo.setPasswordKey(password_key);
       // memberInfo.setCretId(req.getSession().getAttribute("id").toString());
        memberInfo.setCretId("test");
        try{
        	memberService.saveNewMember(memberInfo);
        }catch(Exception e){
            e.toString();
        }
    }
    
    /* 직원 삭제 */
    @RequestMapping(value = "/deleteMember")  
    @ResponseBody
    public void deleteMember(@RequestParam HashMap<String,String> params){
    	memberService.deleteMember(params);
    }
    
    /* 직원 수정 */
    @RequestMapping(value = "/updateMember")
    @ResponseBody
    public void updateMember(@RequestParam HashMap<String,String> params, HttpServletRequest req){
    	//params.put("updtId",req.getSession().getAttribute("id").toString());
    	params.put("updtId","test");
    	memberService.updateMember(params);
    }    
    
    
    @RequestMapping(value = "/getAppVersion")
    @ResponseBody
    public MemberVo getAppVersion(){
    	
    	return memberService.getAppVersion();
    }
    
    @RequestMapping(value = "/saveAppVersion")
    @ResponseBody
    public void saveAppVersion(@RequestParam HashMap<String,Object> params){
    	
    	memberService.saveAppVersion(params);
    }
    
    @RequestMapping(value = "/getChooseMemberList")
    @ResponseBody
    public List<MemberVo> getChooseMemberList(@RequestParam HashMap<String,Object> params){
    	
    	List<MemberVo> memberList = memberService.getChooseMemberList(params);
    	
    	return memberList;
    }

}
