package com.cuppaHouse.Mappers;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.cuppaHouse.vo.MngVo;

@Mapper
public interface MngMapper  {
	//판매이력
	public List<MngVo> getMngHistList(HashMap<String,Object> params);
	public void deleteMngHist(MngVo params);
    public void saveMngHist(MngVo params);
    public void saveMngHistReset(MngVo params);
    public List<MngVo> saveMngHistVal(MngVo params); 
    
    //제품관리 
    public void deleteMngProduct(MngVo params);
    public void saveMngProduct(MngVo params);
    public void updateMngProduct(MngVo params);
    public void sellMngProduct(MngVo params);
    public HashMap<String,Object> getQrInfo(HashMap<String,Object> params);
    public MngVo getBarcodeInfo(HashMap<String,Object> params);
    public HashMap<String,Object> getTotalMngProductCnt();
    
    //매출
    public List<MngVo> getMngIncomeList(HashMap<String,Object> params);
    public HashMap<String,Object> getTotalMngIncomeCnt();
    public HashMap<String,Object> getLableMngIncomeCnt(HashMap<String,Object> params);
    public void deleteMngIncome(MngVo params);
    public void saveMngIncome(MngVo params);
    public void updateMngIncome(MngVo params);
}

