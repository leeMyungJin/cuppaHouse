package com.cuppaHouse.Mappers;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.web.bind.annotation.RequestParam;

import com.cuppaHouse.vo.CodeVo;
import com.cuppaHouse.vo.MemberVo;

@Mapper
public interface CodeMapper  {
	
	public List<CodeVo> getCodeList(@RequestParam HashMap<String,Object> params);
	
}
