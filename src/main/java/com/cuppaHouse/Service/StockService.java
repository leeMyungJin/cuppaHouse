package com.cuppaHouse.Service;

import java.util.HashMap;
import java.util.List;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import com.cuppaHouse.vo.CodeVo;
import com.cuppaHouse.vo.MngVo;
import com.cuppaHouse.vo.StockVo;

public interface StockService {
	//물품관리
    public List<StockVo> getStockManageList(HashMap<String,Object> params);
	public List<CodeVo> getStockQrList(HashMap<String,Object> params);
    public String getTotalItemCnt();
    public List<StockVo> getCategoryList();
    public void deleteCategory(List<StockVo> params);
    public void saveCategory(List<StockVo> params, String id);
    public void updateCategory(List<StockVo> params, String id);
    public List<StockVo> getLCategoryList(HashMap<String,Object> params);
    public List<StockVo> getMCategoryList(HashMap<String,Object> params);
    public void addItem(StockVo params);
    public void deleteItem(List<StockVo> params);
    public Integer saveItem(List<StockVo> params, String id);
    public List<StockVo> dupCategoryChk(HashMap<String,Object> params);
    public List<StockVo> getPartName(HashMap<String,Object> params);
    public List<StockVo> getPartFullList(HashMap<String,Object> params);
    public List<StockVo> getPartList(HashMap<String,Object> params);
    public void deletePart(List<StockVo> params);
    public void savePart(List<StockVo> params, String id);
    public void updatePart(List<StockVo> params, String id);
    public String savePartExcelGrid(List<StockVo> params, String id);
    public String saveExcelGrid(List<StockVo> params, String id);
    
    //재고입력
    public HashMap<String,Object> getTotalEntryCnt();
    public List<StockVo> getEntryList(HashMap<String,Object> params);
    public void saveEntry(List<StockVo> params, String id);
    public List<StockVo> getBldgList(HashMap<String,Object> params);
    public List<StockVo> getItemList(HashMap<String,Object> params);
    
  //재고이력
    public HashMap<String,Object> getTotalHistoryCnt();
    public List<StockVo> getHistoryList(HashMap<String,Object> params);
    public void saveHistory(List<StockVo> params, String id);
    public void deleteHistory(HashMap<String,Object> params);
    
    public HashMap<String,Object> getTotalPresentAmt();
    public List<StockVo> getPresentList(HashMap<String,Object> params);
    public List<StockVo> getPartPresentList(HashMap<String,Object> params);
    public List<StockVo> getStockDtl(HashMap<String,Object> params);
    public List<MngVo> getStockBarcodeList(HashMap<String,Object> params);
    
    //홈
    public HashMap<String,Object> getTotalHomeCnt();
    
    
    
}