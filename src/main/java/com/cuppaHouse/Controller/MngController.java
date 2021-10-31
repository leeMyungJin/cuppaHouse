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

import com.cuppaHouse.Service.MngService;
import com.cuppaHouse.vo.MngVo;
import com.cuppaHouse.vo.StockVo;

@Controller
@RequestMapping("/mng")
public class MngController {
    
	@Autowired
	MngService mngService;
	
    @RequestMapping(value = "/income", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveMngIncome(Model model) {
    	return "mng/mng_income";
    }
    
    @RequestMapping(value = "/product", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveMngProduct(Model model) {
    	return "mng/mng_product";
    }
    
    @RequestMapping(value = "/history", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveMngSalesHistory(Model model) {
    	return "mng/mng_sales_history";
    }
    
    
    /////////////////////// 판매이력
    @RequestMapping(value="/getMngHistList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<MngVo> getMngHistList(@RequestParam HashMap<String,Object> params){
        return mngService.getMngHistList(params);
    }
    
    @RequestMapping(value="/deleteMngHist", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void deleteMngHist(@RequestBody List<MngVo> params){
    	mngService.deleteMngHist(params);
    }

    @RequestMapping(value="/saveMngHist", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public String saveMngHist(@RequestBody List<MngVo> params, HttpServletRequest req){
    	return mngService.saveMngHist(params, req.getSession().getAttribute("id").toString());
    }
    
    ////////////////////////제품관리
    @RequestMapping(value="/deleteMngProduct", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void deleteMngProduct(@RequestBody List<MngVo> params){
    	mngService.deleteMngProduct(params);
    }

    @RequestMapping(value="/saveMngProduct", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public String saveMngProduct(@RequestBody List<MngVo> params, HttpServletRequest req){
    	return mngService.saveMngProduct(params, req.getSession().getAttribute("id").toString());
    }
    
    @RequestMapping(value="/saveMngExcelProduct", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public String saveMngExcelProduct(@RequestBody List<MngVo> params, HttpServletRequest req){
    	return mngService.saveMngExcelProduct(params, req.getSession().getAttribute("id").toString());
    }
    
    @RequestMapping(value="/updateMngProduct", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void updateMngProduct(@RequestBody List<MngVo> params, HttpServletRequest req){
    	mngService.updateMngProduct(params, req.getSession().getAttribute("id").toString());
    }
    
    @RequestMapping(value="/sellMngProduct", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void sellMngProduct(@RequestBody List<MngVo> params, HttpServletRequest req){
    	mngService.sellMngProduct(params, req.getSession().getAttribute("id").toString());
    }
    
    @RequestMapping(value="/getQrInfo", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public HashMap<String,Object> getQrInfo(@RequestParam HashMap<String,Object> params){
        return mngService.getQrInfo(params);
    }
    
    @RequestMapping(value="/getBarcodeInfo", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public MngVo getBarcodeInfo(@RequestParam HashMap<String,Object> params){
        return mngService.getBarcodeInfo(params);
    }
    
    @RequestMapping(value = "/getTotalMngProductCnt")
    @ResponseBody
    public HashMap<String,Object> getTotalMngProductCnt(){
    	return mngService.getTotalMngProductCnt();
    }
    
    
    ////// 매출
	@RequestMapping(value="/getMngIncomeList", method = {RequestMethod.POST , RequestMethod.GET})
	@ResponseBody
	public List<MngVo> getMngIncomeList(@RequestParam HashMap<String,Object> params){
	return mngService.getMngIncomeList(params);
	}
    
	@RequestMapping(value = "/getTotalMngIncomeCnt")
    @ResponseBody
    public HashMap<String,Object> getTotalMngIncomeCnt(){
    	return mngService.getTotalMngIncomeCnt();
    }
	
	@RequestMapping(value = "/getLableMngIncomeCnt")
    @ResponseBody
    public HashMap<String,Object> getLableMngIncomeCnt(@RequestParam HashMap<String,Object> params){
    	return mngService.getLableMngIncomeCnt(params);
    }
	
	@RequestMapping(value="/deleteMngIncome", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void deleteMngIncome(@RequestBody List<MngVo> params){
    	mngService.deleteMngIncome(params);
    }
	
	@RequestMapping(value="/saveMngIncome", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void saveMngIncome(@RequestBody List<MngVo> params, HttpServletRequest req){
    	mngService.saveMngIncome(params, req.getSession().getAttribute("id").toString());
    }
	
	@RequestMapping(value="/updateMngIncome", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void updateMngIncome(@RequestBody List<MngVo> params, HttpServletRequest req){
    	mngService.updateMngIncome(params, req.getSession().getAttribute("id").toString());
    }
	
	@RequestMapping(value="/saveExcelMngIncome", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public String saveExcelMngIncome(@RequestBody List<MngVo> params, HttpServletRequest req){
    	return mngService.saveExcelMngIncome(params, req.getSession().getAttribute("id").toString());
    }
}
