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

import com.cuppaHouse.Service.CodeService;
import com.cuppaHouse.Service.MemberService;
import com.cuppaHouse.Util.Encrypt;
import com.cuppaHouse.vo.CodeVo;
import com.cuppaHouse.vo.MemberVo;

@Controller
@RequestMapping("/code")
public class CodeController {
    
	@Autowired
	CodeService codeService;
	
    @RequestMapping(value="/getCodeList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<CodeVo> getCodeList(@RequestParam HashMap<String,Object> params){
        return codeService.getCodeList(params); // 카테고리 저장 후 다시 조회
    }
}
