package com.cuppaHouse.Service;

import java.util.HashMap;
import java.util.List;

import com.cuppaHouse.vo.MngVo;

public interface MngService {
	//판매이력
	public List<MngVo> getMngHistList(HashMap<String,Object> params);
	public void deleteMngHist(List<MngVo> params);
    public String saveMngHist(List<MngVo> params, String id);
    
    //제품관리 
    public void deleteMngProduct(List<MngVo> params);
    public String saveMngProduct(List<MngVo> params, String id);
    public String saveMngExcelProduct(List<MngVo> params, String id);
    public void updateMngProduct(List<MngVo> params, String id);
    public void sellMngProduct(List<MngVo> params, String id);
    public HashMap<String,Object> getQrInfo(HashMap<String,Object> params);
    public MngVo getBarcodeInfo(HashMap<String,Object> params);
    public HashMap<String,Object> getTotalMngProductCnt();
    
    //매출 
    public List<MngVo> getMngIncomeList(HashMap<String,Object> params);
    public HashMap<String,Object> getTotalMngIncomeCnt();
    public HashMap<String,Object> getLableMngIncomeCnt(HashMap<String,Object> params);
    public void deleteMngIncome(List<MngVo> params);
    public void saveMngIncome(List<MngVo> params, String id);
    public void updateMngIncome(List<MngVo> params, String id);
    public String saveExcelMngIncome(List<MngVo> params, String id);
    
}