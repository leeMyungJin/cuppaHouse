package com.cuppaHouse.Mappers;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.cuppaHouse.vo.WorkVo;

@Mapper
public interface WorkMapper  {
	
	public List<WorkVo> getWorkList(HashMap<String,Object> params);
	
	public HashMap<String,Object> getWorkLable(HashMap<String,Object> params);
	
	public void saveWorkGrid(WorkVo params);
	
	public void updateWorkGrid(WorkVo params);
	
	public void saveWorkStTime(HashMap<String,Object> params);
	
	public List<WorkVo> chkWorkDup(HashMap<String,Object> params);
	
	public HashMap<String,Object> getWorkStTime();
}
