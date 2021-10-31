package com.cuppaHouse.Service;

import java.util.HashMap;
import java.util.List;

import com.cuppaHouse.vo.WorkVo;

public interface WorkService {
	
	public List<WorkVo> getWorkList(HashMap<String,Object> params);
	
	public HashMap<String,Object> getWorkLable(HashMap<String,Object> params);
	
	public void saveWorkGrid(WorkVo params);
	
	public void updateWorkGrid(WorkVo params);
	
	public void saveWorkStTime(HashMap<String,Object> params);
	
	public List<WorkVo> chkWorkDup(HashMap<String,Object> params);
	
	public HashMap<String,Object> getWorkStTime();
	
}