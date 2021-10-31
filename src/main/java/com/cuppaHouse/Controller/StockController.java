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

import com.cuppaHouse.vo.BuildingVo;
import com.cuppaHouse.vo.CodeVo;
import com.cuppaHouse.vo.MngVo;
import com.cuppaHouse.Service.StockService;
import com.cuppaHouse.vo.StockVo;

@Controller
@RequestMapping("/stock")
public class StockController {
    
	@Autowired
	StockService stockService;
	
    @RequestMapping(value = "/entry", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveStockEntry(Model model) {
    	return "stock/stock_entry";
    }
    
    @RequestMapping(value = "/history", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveStockHistory(Model model) {
    	return "stock/stock_history";
    }
    
    @RequestMapping(value = "/manage", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveStockManage(Model model) {
    	return "stock/stock_manage";
    }
    
    @RequestMapping(value = "/present", method = {RequestMethod.POST , RequestMethod.GET})
    public String moveStockPresent(Model model) {
    	return "stock/stock_present";
    }
    
    
    //////////////////////////////////////////////// 물품관리 ////////////////////////////////
    @RequestMapping(value = "/getTotalItemCnt")
    @ResponseBody
    public String getStockMamageTotal(){
    	
    	return stockService.getTotalItemCnt();
    }
    
    /**
     * 코드 리스트 가져오기
     * @param params
     * @return
     */
    @RequestMapping(value="/getStockManageList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getStockList(@RequestParam HashMap<String,Object> params){
        return stockService.getStockManageList(params);
    }
    
    /**
     * 코드 리스트 가져오기
     * @param params
     * @return
     */
    @RequestMapping(value="/getStockQrList", method = {RequestMethod.POST , RequestMethod.GET})
    public String getStockQrList(@RequestParam HashMap<String,Object> params, Model model){
    	List<CodeVo> codeVo = stockService.getStockQrList(params);
        
    	model.addAttribute("qrList", codeVo);
        model.addAttribute("qrCnt",codeVo.size());
        
    	return "stock/stock_qr";
    }


    /**
     * 카테고리 리스트 가져오기
     * 
     * @return
     */
    @RequestMapping(value="/getCategoryList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getCategoryList(){
        return stockService.getCategoryList();
    }

     /**
     * 카테고리 삭제하기
     * 
     * @return
     */
    @RequestMapping(value="/deleteCategory", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void deleteCategory(@RequestBody List<StockVo> params){
        stockService.deleteCategory(params);
    }

    /**
     * 카테고리 저장하기
     * 
     * @return
     */
    @RequestMapping(value="/saveCategory", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> saveCategory(@RequestBody List<StockVo> params, HttpServletRequest req){
        stockService.saveCategory(params, req.getSession().getAttribute("id").toString());
        return stockService.getCategoryList(); // 카테고리 저장 후 다시 조회
    }
    
    @RequestMapping(value="/updateCategory", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void updateCategory(@RequestBody List<StockVo> params, HttpServletRequest req){
        stockService.updateCategory(params, req.getSession().getAttribute("id").toString());
    }

    /**
     * 대카테고리 리스트 가져오기
     */
    @RequestMapping(value="/getLCategoryList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getLCategoryList(@RequestParam HashMap<String,Object> params){
        return stockService.getLCategoryList(params); // 카테고리 저장 후 다시 조회
    }

    /**
     * 중카테고리 리스트 가져오기
     */
    @RequestMapping(value="/getMCategoryList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getMCategoryList(@RequestParam HashMap<String,Object> params){
        return stockService.getMCategoryList(params); // 카테고리 저장 후 다시 조회
    }    

    /**
     * 물품 등록 
     */
    @RequestMapping(value="/addItem", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void addItem(@RequestBody StockVo params, HttpServletRequest req){
        params.setCretId(req.getSession().getAttribute("id").toString());
        params.setUpdtId(req.getSession().getAttribute("id").toString());
        stockService.addItem(params); // 카테고리 저장 후 다시 조회
    }

    /**
     * 물품 삭제하기
     * 
     * @return
     */
    @RequestMapping(value="/deleteItem", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void deleteItem(@RequestBody List<StockVo> params){
        stockService.deleteItem(params);
    }

    /**
     * 물품 저장하기
     * 
     * @return
     */
    @RequestMapping(value="/saveItem", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public Integer saveStock(@RequestBody List<StockVo> params, HttpServletRequest req){
        return stockService.saveItem(params, req.getSession().getAttribute("id").toString());
        // return stockService.getStockList(params); // 카테고리 저장 후 다시 조회
    }
    
    /**
     * 중복 카테고리 리스트 가져오기
     */
    @RequestMapping(value="/dupCategoryChk", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> dupCategoryChk(@RequestParam HashMap<String,Object> params){
        return stockService.dupCategoryChk(params); 
    }    
    
    /**
     * 카테고리 리스트 가져오기
     * 
     * @return
     */
    @RequestMapping(value="/getPartName", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getPartName(@RequestParam HashMap<String,Object> params){
        return stockService.getPartName(params);
    }
    
    /**
     * 카테고리 리스트 가져오기
     * 
     * @return
     */
    @RequestMapping(value="/getPartFullList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getPartFullList(@RequestParam HashMap<String,Object> params){
        return stockService.getPartFullList(params);
    }
    
    /**
     * 카테고리 리스트 가져오기
     * 
     * @return
     */
    @RequestMapping(value="/getPartList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getPartList(@RequestParam HashMap<String,Object> params){
        return stockService.getPartList(params);
    }
    
    /**
     * 물품 삭제하기
     * 
     * @return
     */
    @RequestMapping(value="/deletePart", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void deletePart(@RequestBody List<StockVo> params){
        stockService.deletePart(params);
    }

    /**
     * 물품 저장하기
     * 
     * @return
     */
    @RequestMapping(value="/savePart", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void savePart(@RequestBody List<StockVo> params, HttpServletRequest req){
        stockService.savePart(params, req.getSession().getAttribute("id").toString());
        // return stockService.getStockList(params); // 카테고리 저장 후 다시 조회
    }
    
    /**
     * 물품 저장하기
     * 
     * @return
     */
    @RequestMapping(value="/updatePart", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void updatePart(@RequestBody List<StockVo> params, HttpServletRequest req){
        stockService.updatePart(params, req.getSession().getAttribute("id").toString());
        // return stockService.getStockList(params); // 카테고리 저장 후 다시 조회
    }

    
    @RequestMapping(value="/savePartExcelGrid", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public String savePartExcelGrid(@RequestBody List<StockVo> params, HttpServletRequest req){
        return stockService.savePartExcelGrid(params, req.getSession().getAttribute("id").toString());
    }
    
    @RequestMapping(value="/saveExcelGrid", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public String saveExcelGrid(@RequestBody List<StockVo> params, HttpServletRequest req){
        return stockService.saveExcelGrid(params, req.getSession().getAttribute("id").toString());
    }
    
    
    ///////////////////////////////// 재고입력 ////////////////
    @RequestMapping(value = "/getTotalEntryCnt")
    @ResponseBody
    public HashMap<String,Object> getTotalEntryCnt(){
    	
    	return stockService.getTotalEntryCnt();
    }
    
    /**
     * 코드 리스트 가져오기
     * @param params
     * @return
     */
    @RequestMapping(value="/getEntryList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getEntryList(@RequestParam HashMap<String,Object> params){
        return stockService.getEntryList(params);
    }
   
    
    /**
     * 물품 저장하기
     * 
     * @return
     */
    @RequestMapping(value="/saveEntry", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void saveEntry(@RequestBody List<StockVo> params, HttpServletRequest req){
        stockService.saveEntry(params, req.getSession().getAttribute("id").toString());
    }
    
    /**getBldgList
     * 업체 리스트 가져오기
     */
    @RequestMapping(value="/getBldgList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getBldgList(@RequestParam HashMap<String,Object> params){
        return stockService.getBldgList(params); // 카테고리 저장 후 다시 조회
    }
    
    
    /**
     * 물품 리스트 가져오기
     */
    @RequestMapping(value="/getItemList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getItemList(@RequestParam HashMap<String,Object> params){
        return stockService.getItemList(params); // 카테고리 저장 후 다시 조회
    }
    
    
    /////////////////////재고이력//////////////////////
    @RequestMapping(value = "/getTotalHistoryCnt")
    @ResponseBody
    public HashMap<String,Object> getTotalHistoryCnt(){
    	
    	return stockService.getTotalHistoryCnt();
    }
    
    /**
     * 코드 리스트 가져오기
     * @param params
     * @return
     */
    @RequestMapping(value="/getHistoryList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getHistoryList(@RequestParam HashMap<String,Object> params){
        return stockService.getHistoryList(params);
    }
   
    
    /**
     * 물품 저장하기
     * 
     * @return
     */
    @RequestMapping(value="/saveHistory", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void saveHistory(@RequestBody List<StockVo> params, HttpServletRequest req){
        stockService.saveHistory(params, req.getSession().getAttribute("id").toString());
    }
    
    /**
     * 이력 삭제하기
     * 
     * @return
     */
    @RequestMapping(value="/deleteHistory", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public void deleteHistory(@RequestParam HashMap<String,Object> params){
        stockService.deleteHistory(params);
    }

    
    ////////////////////// 재고현황 //////////////////////////////
    @RequestMapping(value = "/getTotalPresentAmt")
    @ResponseBody
    public HashMap<String,Object> getTotalPresentAmt(){
    	
    	return stockService.getTotalPresentAmt();
    }
    
    /**
     * 재고현황 리스트 가져오기
     * @param params
     * @return
     */
    @RequestMapping(value="/getPresentList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getPresentList(@RequestParam HashMap<String,Object> params){
        return stockService.getPresentList(params);
    }
    
    /**
     * 파트현황 팝업 리스트 가져오기
     * @param params
     * @return
     */
    @RequestMapping(value="/getPartPresentList", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getPartPresentList(@RequestParam HashMap<String,Object> params){
        return stockService.getPartPresentList(params);
    }
    
    /**
     * 재고상세 팝업 리스트 가져오기
     * @param params
     * @return
     */
    @RequestMapping(value="/getStockDtl", method = {RequestMethod.POST , RequestMethod.GET})
    @ResponseBody
    public List<StockVo> getStockDtl(@RequestParam HashMap<String,Object> params){
        return stockService.getStockDtl(params);
    }
    
    /**
     * 바코드 리스트 가져오기
     * @param params
     * @return
     */
    @RequestMapping(value="/getStockBarcodeList", method = {RequestMethod.POST , RequestMethod.GET})
    public String getStockBarcodeList(@RequestParam HashMap<String,Object> params, Model model){
    	List<MngVo> mngVo = stockService.getStockBarcodeList(params);
        
    	model.addAttribute("barcodeList", mngVo);
        model.addAttribute("barcodeCnt",mngVo.size());
        
    	return "mng/mng_qr";
    }
    
	///////////////////////////////// 홈 ////////////////
	@RequestMapping(value = "/getTotalHomeCnt")
	@ResponseBody
	public HashMap<String,Object> getTotalHomeCnt(){
	
	return stockService.getTotalHomeCnt();
	}
    
}
