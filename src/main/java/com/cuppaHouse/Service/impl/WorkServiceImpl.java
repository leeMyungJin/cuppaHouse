package com.cuppaHouse.Service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cuppaHouse.Mappers.BuildingMapper;
import com.cuppaHouse.Mappers.WorkMapper;
import com.cuppaHouse.Service.BuildingService;
import com.cuppaHouse.Service.WorkService;
import com.cuppaHouse.Util.Util;
import com.cuppaHouse.vo.MemberVo;
import com.cuppaHouse.vo.WorkVo;

@Service
public class WorkServiceImpl implements WorkService{

	@Autowired
	private WorkMapper workMapper;

	@Override
	public List<WorkVo> getWorkList(HashMap<String,Object> params){
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		                		
		List<WorkVo> WorkList = workMapper.getWorkList(params);
		return WorkList;
	}
	
	public HashMap<String,Object> getWorkLable(HashMap<String,Object> params){
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		
		return workMapper.getWorkLable(params);
	}
	
	@Override
	public void saveWorkGrid(WorkVo params) {
		workMapper.saveWorkGrid(params);
	}
	
	
	@Override
	public void updateWorkGrid(WorkVo params) {
		workMapper.updateWorkGrid(params);
	}
	
	public void saveWorkStTime(HashMap<String,Object> params) {
		workMapper.saveWorkStTime(params);
	}
	
	@Override
	public List<WorkVo> chkWorkDup(HashMap<String,Object> params){
		
		List<WorkVo> WorkList = workMapper.chkWorkDup(params);
		return WorkList;
	}
	
	@Override
	public HashMap<String,Object> getWorkStTime(){
	
		return workMapper.getWorkStTime();
	}
	
}