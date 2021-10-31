package com.cuppaHouse.Mappers;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.cuppaHouse.vo.BuildingVo;

@Mapper
public interface BuildingMapper  {
	
	public List<BuildingVo> getBuildingQrList(HashMap<String,Object> params);
	
	public HashMap<String,Object> getBuildingTotal();
	
	public List<BuildingVo> getBuildingList(HashMap<String,Object> params);
	
	public void saveBuilding(HashMap<String,String>params);
	
	public void deleteBuilding(HashMap<String,String>params);
	
	public void updateBuilding(HashMap<String,String> params);
	
	public void updateBuildingGrid(BuildingVo vo);
	
	public Integer dupCheckBuilding(HashMap<String, Object> params);
	
	public String getNewBldgCd();
}
