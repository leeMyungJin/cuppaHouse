package com.cuppaHouse.Mappers;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.cuppaHouse.vo.ProcessVo;

@Mapper
public interface ProcessMapper  {
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
