package com.cuppaHouse.Service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.cuppaHouse.vo.CodeVo;
import com.cuppaHouse.Mappers.CodeMapper;
import com.cuppaHouse.Service.CodeService;

@Service
public class CodeServiceImpl implements CodeService{

	@Autowired
	private CodeMapper codeMapper;
	
	@Override
	public List<CodeVo> getCodeList(@RequestParam HashMap<String,Object> params){
		return codeMapper.getCodeList(params);
	}
	
}