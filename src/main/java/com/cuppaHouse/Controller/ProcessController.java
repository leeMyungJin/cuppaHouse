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

import com.cuppaHouse.Service.ProcessService;
import com.cuppaHouse.vo.ProcessVo;

@Controller
@RequestMapping("/process")
public class ProcessController {
    
	@Autowired
	ProcessService processService;
	
    @RequestMapping(value = "/", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveProcess(Model model) {
    	return "process/process";
    }
    
    @RequestMapping(value = "/getProcessList")
    @ResponseBody
    public List<ProcessVo> getProcessList(@RequestParam HashMap<String,Object> params){
    	
    	List<ProcessVo> processList = processService.getProcessList(params);
    	
    	return processList;
    }
    
    @RequestMapping(value = "/getProcessTotal")
    @ResponseBody
    public HashMap<String,Object> getProcessTotal(){
    	
    	return processService.getProcessTotal();
    }
    
    @RequestMapping(value = "/getProcessLable")
    @ResponseBody
    public HashMap<String,Object> getProcessLable(@RequestParam HashMap<String,Object> params){
    	
    	return processService.getProcessLable(params);
    }
    
    @RequestMapping(value = "/saveProcessGrid")
    @ResponseBody
    public void saveProcessGrid(@RequestBody List<ProcessVo> params, HttpServletRequest req){
        // BLDG_BAS 등록
        for(ProcessVo vo : params){
            vo.setCretId(req.getSession().getAttribute("id").toString());
            vo.setUpdtId(req.getSession().getAttribute("id").toString());
            processService.saveProcessGrid(vo);
        }
    }
    
    /* 건물 등록 */
    @RequestMapping(value = "/saveProcess")
    @ResponseBody
    public void saveProcess(@RequestParam HashMap<String,String> params, HttpServletRequest req){
    	params.put("updtId",req.getSession().getAttribute("id").toString());
    	processService.saveProcess(params);
    }    
    
    /* 건물 삭제 */
    @RequestMapping(value = "/deleteProcess")  
    @ResponseBody
    public void deleteProcess(@RequestParam HashMap<String,String> params){
    	processService.deleteProcess(params);
    }
    
    /* 건물 수정 */
    @RequestMapping(value = "/updateProcess")
    @ResponseBody
    public void updateProcess(@RequestParam HashMap<String,String> params, HttpServletRequest req){
    	params.put("updtId",req.getSession().getAttribute("id").toString());
    	processService.updateProcess(params);
    }    
    
    @RequestMapping(value = "/getNeedMaterList")
    @ResponseBody
    public List<ProcessVo> getNeedMaterList(@RequestParam HashMap<String,Object> params){
    	
    	List<ProcessVo> materList = processService.getNeedMaterList(params);
    	
    	return materList;
    }
    
    @RequestMapping(value = "/getShowImgPop")
    public String getShowImgPop(@RequestParam HashMap<String, String> params, Model model){
    	
    	ProcessVo processInfo = processService.getShowImgPop(params);
    	
    	model.addAttribute("processInfo", processInfo);
    	model.addAttribute("imgPath", processInfo.getImgPath());
    	
    	return "process/p_img";
    }
    
    
    
}
