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

import com.cuppaHouse.Service.WorkService;
import com.cuppaHouse.vo.BuildingVo;
import com.cuppaHouse.vo.WorkVo;

@Controller
@RequestMapping("/work")
public class WorkController {
    
	@Autowired
	WorkService workService;
	
    @RequestMapping(value = "/", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveWork(Model model) {
    	return "work/work";
    }
    
    @RequestMapping(value = "/getWorkList")
    @ResponseBody
    public List<WorkVo> getWorkList(@RequestParam HashMap<String,Object> params){
    	
    	List<WorkVo> workList = workService.getWorkList(params);
    	
    	return workList;
    }
    
    @RequestMapping(value = "/getWorkLable")
    @ResponseBody
    public HashMap<String,Object> getWorkLable(@RequestParam HashMap<String,Object> params){
    	
    	return workService.getWorkLable(params);
    }
    
    @RequestMapping(value = "/saveWorkGrid")
    @ResponseBody
    public void saveWorkGrid(@RequestBody List<WorkVo> params, HttpServletRequest req){
        // BLDG_BAS 등록
        for(WorkVo vo : params){
            vo.setCretId(req.getSession().getAttribute("id").toString());
            vo.setUpdtId(req.getSession().getAttribute("id").toString());
            workService.saveWorkGrid(vo);
        }
    }
    
    @RequestMapping(value = "/updateWorkGrid")
    @ResponseBody
    public void updateWorkGrid(@RequestBody List<WorkVo> params, HttpServletRequest req){
        for(WorkVo vo : params){
            vo.setCretId(req.getSession().getAttribute("id").toString());
            vo.setUpdtId(req.getSession().getAttribute("id").toString());
            workService.updateWorkGrid(vo);
        }
    }
    
    // 출근시간 저장
    @RequestMapping(value = "/saveWorkStTime")
    @ResponseBody
    public void saveWorkStTime(@RequestParam HashMap<String,Object> params){
    
    	workService.saveWorkStTime(params);
    }
    
    @RequestMapping(value = "/chkWorkDup")
    @ResponseBody
    public List<WorkVo> chkWorkDup(@RequestParam HashMap<String,Object> params){
    	
    	List<WorkVo> workList = workService.chkWorkDup(params);
    	
    	return workList;
    }
    
    @RequestMapping(value = "/getWorkStTime")
    @ResponseBody
    public HashMap<String,Object> getWorkStTime(){
    	
    	return workService.getWorkStTime();
    }
    
}
