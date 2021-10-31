package com.cuppaHouse.Mappers;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.cuppaHouse.vo.CodeVo;
import com.cuppaHouse.vo.MngVo;
import com.cuppaHouse.vo.StockVo;

@Mapper
public interface StockMapper  {
	public List<StockVo> getStockManageList(HashMap<String, Object> params);
	public List<CodeVo> getStockQrList(HashMap<String, Object> params);
    public String getTotalItemCnt();
	public List<StockVo> getCategoryList();
	public void deleteCategory(StockVo params); 
	public void saveCategory(StockVo params); 
	public void updateCategory(StockVo params); 
	public List<StockVo> getLCategoryList(HashMap<String,Object> params);
	public List<StockVo> getMCategoryList(HashMap<String,Object> params);
    public String dupCheckItem(HashMap<String, String> params);
    public void addItem(StockVo params);
    public void deleteItem(StockVo vo);
    public Integer checkCategory(StockVo vo);
    public void saveItem(StockVo params);
    public List<StockVo> dupCategoryChk(HashMap<String,Object> params);
    public List<StockVo> getPartName(HashMap<String,Object> params);
    public List<StockVo> getPartFullList(HashMap<String,Object> params);
    public List<StockVo> getPartList(HashMap<String,Object> params);
    public void deletePart(StockVo params); 
	public void updatePart(StockVo params); 
	public void savePart(StockVo params); 
	public List<StockVo> savePartExcelGridVal(StockVo params); 
	public void savePartExcelGrid(StockVo params); 
	public List<StockVo> saveExcelGridVal(StockVo params); 
	public void saveExcelGrid(StockVo params); 
    
    //재고입력
    public HashMap<String,Object> getTotalEntryCnt();
    public List<StockVo> getEntryList(HashMap<String,Object> params);
    public void saveEntry(StockVo params);
    public void updateQuantity(StockVo params);
    public List<StockVo> getBldgList(HashMap<String,Object> params);
    public List<StockVo> getItemList(HashMap<String,Object> params);
    
  //재고이력 
    public HashMap<String,Object> getTotalHistoryCnt();
    public List<StockVo> getHistoryList(HashMap<String,Object> params);
    public void saveHistory(StockVo params);
    public Integer getGroupSeq();
    public void updateAutoQuantity(StockVo params);
    public void insertAutoQuantity(StockVo params);
    public void resetHistory(HashMap<String,Object> params);
    public void resetHistoryAutoval(HashMap<String,Object> params);
    public void deleteHistorySar(HashMap<String,Object> params);
    public void deleteHistorySarAuto(HashMap<String,Object> params);
    
    //재고현황
    public HashMap<String,Object> getTotalPresentAmt();
    public List<StockVo> getPresentList(HashMap<String,Object> params);
    public List<StockVo> getPartPresentList(HashMap<String,Object> params);
    public List<StockVo> getStockDtl(HashMap<String,Object> params);
    public List<MngVo> getStockBarcodeList(HashMap<String, Object> params);
    
    //홈
    public HashMap<String,Object> getTotalHomeCnt();
}
