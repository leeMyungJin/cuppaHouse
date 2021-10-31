package com.cuppaHouse.Service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.cuppaHouse.vo.MemberVo;
import com.cuppaHouse.vo.ProcessVo;

public interface ProcessService {
	
	public List<ProcessVo> getProcessList(HashMap<String,Object> params);
	
	public HashMap<String,Object> getProcessTotal();
	
	public HashMap<String,Object> getProcessLable(HashMap<String,Object> params);
	
	public void saveProcessGrid(ProcessVo params);
	
	public void saveProcess(HashMap<String,String> params);
	
	public void deleteProcess(HashMap<String,String> params);
	
	public void updateProcess(HashMap<String,String> params);
	
	public List<ProcessVo> getNeedMaterList(HashMap<String,Object> params);
	
	public ProcessVo getShowImgPop(HashMap<String,String> params);
	
	
}