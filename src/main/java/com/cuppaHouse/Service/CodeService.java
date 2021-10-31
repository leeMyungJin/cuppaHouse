package com.cuppaHouse.Service;

import java.util.HashMap;
import java.util.List;

import org.springframework.web.bind.annotation.RequestParam;

import com.cuppaHouse.vo.CodeVo;
import com.cuppaHouse.vo.MemberVo;

public interface CodeService {
    
    public List<CodeVo> getCodeList(HashMap<String,Object> params);

}