package com.cuppaHouse.Service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.cuppaHouse.vo.ProcessVo;
import com.cuppaHouse.Mappers.LoginMapper;
import com.cuppaHouse.Util.Encrypt;
import com.cuppaHouse.Util.Util;
import com.cuppaHouse.Mappers.ProcessMapper;
import com.cuppaHouse.Service.ProcessService;

@Service
public class ProcessServiceImpl implements ProcessService{

	@Autowired
	private ProcessMapper processMapper;
	
	@Override
	public List<ProcessVo> getProcessList(HashMap<String,Object> params){
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		                		
		List<ProcessVo> processList = processMapper.getProcessList(params);
		return processList;
	}
	
	public HashMap<String,Object> getProcessTotal(){
		return processMapper.getProcessTotal();
	}
	
	public HashMap<String,Object> getProcessLable(HashMap<String,Object> params){
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		
		return processMapper.getProcessLable(params);
	}
	
	@Override
	public void saveProcessGrid(ProcessVo vo) {
		processMapper.saveProcessGrid(vo);
	}

	@Override
	public void saveProcess(HashMap<String, String> params) {
		processMapper.saveProcess(params);
	}
	
	@Override
	public void deleteProcess(HashMap<String, String> params) {
		processMapper.deleteProcess(params);
		
	}
	
	@Override
	public void updateProcess(HashMap<String, String> params) {
		processMapper.updateProcess(params);
	}

	@Override
	public List<ProcessVo> getNeedMaterList(HashMap<String,Object> params){
		return processMapper.getNeedMaterList(params);
	}
	
	@Override
	public ProcessVo getShowImgPop(HashMap<String,String> params) {
		
		ProcessVo processInfo = processMapper.getShowImgPop(params);
		
		return processInfo;
	}

}