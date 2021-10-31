package com.cuppaHouse.Service.impl;


import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cuppaHouse.Util.Util;
import com.cuppaHouse.Mappers.BuildingMapper;
import com.cuppaHouse.Service.BuildingService;
import com.cuppaHouse.vo.BuildingVo;

@Service
public class BuildingServiceImpl implements BuildingService{

	@Autowired
	private BuildingMapper buildingMapper;
	
	@Override
	public List<BuildingVo> getBuildingQrList(HashMap<String, Object> params) {
		if(params.get("selectBldg") != null)
			params.replace("selectBldg", Util.makeForeach((String)params.get("selectBldg"), ","));
		return buildingMapper.getBuildingQrList(params);
	}
	
	public HashMap<String,Object> getBuildingTotal(){
		return buildingMapper.getBuildingTotal();
	}
	
	@Override
	public List<BuildingVo> getBuildingList(HashMap<String,Object> params){
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		                		
		List<BuildingVo> BuildingList = buildingMapper.getBuildingList(params);
		return BuildingList;
	}
	
	@Override
	public void saveBuilding(HashMap<String, String> params) {
		buildingMapper.saveBuilding(params);
	}
	
	@Override
	public void deleteBuilding(HashMap<String, String> params) {
		buildingMapper.deleteBuilding(params);
		
	}
	
	@Override
	public void updateBuilding(HashMap<String, String> params) {
		buildingMapper.updateBuilding(params);
	}

	@Override
	public void updateBuildingGrid(BuildingVo vo) {
		buildingMapper.updateBuildingGrid(vo);
	}
	
	@Override
	public String dupCheckBuilding(HashMap<String, Object> params) {
		int buildingCnt = buildingMapper.dupCheckBuilding(params);
		String result = "";
		if(buildingCnt > 0)
			result = "true";
		else
			result = "false";
		return result;
	}
	
	@Override
	public String getNewBldgCd() {
		return buildingMapper.getNewBldgCd();
	}


}