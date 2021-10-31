package com.cuppaHouse.Controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cuppaHouse.Service.BuildingService;
import com.cuppaHouse.vo.BuildingVo;

@Controller
@RequestMapping("/building")
public class BuildingController {
    
	@Autowired
	BuildingService buildingService;
	
    @RequestMapping(value = "/", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveBuilding(Model model) {
    	return "building/building";
    }
    
    @RequestMapping(value="/getBuildingQrList", method = {RequestMethod.POST , RequestMethod.GET})
    public String getBuildingQrList(@RequestParam HashMap<String,Object> params, Model model){
    	List<BuildingVo> buildingVo = buildingService.getBuildingQrList(params);
        
    	model.addAttribute("qrList", buildingVo);
        model.addAttribute("qrCnt",buildingVo.size());
        
    	return "building/p_qr";
    }
    
    @RequestMapping(value = "/getBuildingTotal")
    @ResponseBody
    public HashMap<String,Object> getBuildingTotal(){
    	
    	return buildingService.getBuildingTotal();
    }
    
    @RequestMapping(value = "/getBuildingList")
    @ResponseBody
    public List<BuildingVo> getBuildingList(@RequestParam HashMap<String,Object> params){
    	
    	List<BuildingVo> buildingList = buildingService.getBuildingList(params);
    	
    	return buildingList;
    }

    /* 건물 등록 */
    @RequestMapping(value = "/saveBuilding")
    @ResponseBody
    public void saveBuilding(@RequestParam HashMap<String,String> params, HttpServletRequest req){
    	params.put("updtId",req.getSession().getAttribute("id").toString());
    	buildingService.saveBuilding(params);
    }    
    
    /* 건물 삭제 */
    @RequestMapping(value = "/deleteBuilding")  
    @ResponseBody
    public void deleteBuilding(@RequestParam HashMap<String,String> params){
    	buildingService.deleteBuilding(params);
    }
    
    /* 건물 수정 */
    @RequestMapping(value = "/updateBuilding")
    @ResponseBody
    public void updateBuilding(@RequestParam HashMap<String,String> params, HttpServletRequest req){
    	params.put("updtId",req.getSession().getAttribute("id").toString());
    	buildingService.updateBuilding(params);
    }    
    
    @RequestMapping(value = "/updateBuildingGrid")
    @ResponseBody
    public void updateBuilding(@RequestBody List<BuildingVo> params, HttpServletRequest req){
        // BLDG_BAS 등록
        for(BuildingVo vo : params){
            vo.setCretId(req.getSession().getAttribute("id").toString());
            vo.setUpdtId(req.getSession().getAttribute("id").toString());
            buildingService.updateBuildingGrid(vo);
        }
    }
   
    /**
     * 건물 중복 체크
     */
    @RequestMapping(value = "/dupCheckBuilding")
    @ResponseBody
    public String dupCheckBuilding(@RequestParam HashMap<String,Object> params){
        return  buildingService.dupCheckBuilding(params);
    } 
    
    @RequestMapping(value = "/getNewBldgCd")
    @ResponseBody
    public String getNewBldgCd(){
    	 return  buildingService.getNewBldgCd();
    }
    
    /**
     * 주소검색 팝업 띄우기
     */
    @RequestMapping(value = "/p_addr")
    public String addrPopup(@RequestParam HashMap<String,Object> params){
        return "building/p_addr";
    } 
    
}
