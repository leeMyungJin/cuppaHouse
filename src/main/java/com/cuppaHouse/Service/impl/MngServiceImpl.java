package com.cuppaHouse.Service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cuppaHouse.Mappers.BuildingMapper;
import com.cuppaHouse.Mappers.MngMapper;
import com.cuppaHouse.Service.BuildingService;
import com.cuppaHouse.Service.MngService;
import com.cuppaHouse.Util.Util;
import com.cuppaHouse.vo.MngVo;
import com.cuppaHouse.vo.StockVo;

@Service
public class MngServiceImpl implements MngService{

	@Autowired
	private MngMapper mngMapper;
	
	
	@Override
	public List<MngVo> getMngHistList(HashMap<String, Object> params) {
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		return mngMapper.getMngHistList(params);
	}
	
	@Override
	public void deleteMngHist(List<MngVo> params) {
		for(MngVo vo : params)
			mngMapper.deleteMngHist(vo);
	}

	@Override
	public String saveMngHist(List<MngVo> params, String id) {
		int cnt = 0;
		String errorMsgAll = "";
		List<MngVo> dataChk; 
		
		for(MngVo vo : params){
			vo.setCretId(id);
			dataChk = mngMapper.saveMngHistVal(vo);
			
			if(dataChk.get(0).getSellYn() != null && "N".equals(dataChk.get(0).getSellYn()) ) {
				mngMapper.saveMngHist(vo);
				mngMapper.saveMngHistReset(vo);
				cnt += 1;
			
			}else if(dataChk.get(0).getSellYn() != null && "Y".equals(dataChk.get(0).getSellYn())){
				errorMsgAll += vo.getBarcode()+ " - 기 판매된 바코드\n"; 
				
			}else {
				errorMsgAll += vo.getBarcode()+ " - 존재하지 않는 바코드\n"; 
			}
		}
		
		if(errorMsgAll != "") {
			errorMsgAll = "[저장불가 항목]\n"+errorMsgAll;
		}
		
		return "총 "+cnt+" 건이 저장되었습니다\n\n"+errorMsgAll;
	}
	
	///////제품관리 
	@Override
	public void deleteMngProduct(List<MngVo> params) {
		for(MngVo vo : params){
			mngMapper.deleteMngProduct(vo);
		}
	}
	
	@Override
	public String saveMngProduct(List<MngVo> params, String id) {
		int cnt = 0;
		String errorMsgAll = "";
		List<MngVo> dataChk; 
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String today = sdf.format(new Date());
		
		for(MngVo vo : params){
			vo.setCretId(id);
			vo.setBarcode(today + vo.getProdCd()+vo.getPartCd()+vo.getColorCd()+vo.getProdSeq());
			dataChk = mngMapper.saveMngHistVal(vo);
			
			if(dataChk.get(0).getSellYn() == null) {
				mngMapper.saveMngProduct(vo);
				cnt += 1;
			
			}else{
				errorMsgAll += vo.getBarcode()+ " - 기 등록된 바코드\n"; 
				
			}
		}
		
		if(errorMsgAll != "") {
			errorMsgAll = "[저장불가 항목]\n"+errorMsgAll;
		}
		
		return "총 "+cnt+" 건이 저장되었습니다\n\n"+errorMsgAll;
	}
	
	@Override
	public String saveMngExcelProduct(List<MngVo> params, String id) {
		int cnt = 0;
		int voCount = 0;
		String errorMsgAll = "";
		List<MngVo> dataChk; 
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String today = sdf.format(new Date());
		
		for(MngVo vo : params){
			vo.setCretId(id);
			vo.setBarcode(today + vo.getProdCd()+vo.getPartCd()+vo.getColorCd()+vo.getProdSeq());
			dataChk = mngMapper.saveMngHistVal(vo);
			voCount += 1;
			
			if(dataChk.get(0).getSellYn() != null) {
				errorMsgAll += voCount + "번 항목 : "+vo.getBarcode()+ " - 기 등록된 바코드\n"; 
			
			}else if(dataChk.get(0).getItemCd() == null) {
				errorMsgAll += voCount + "번 항목 : "+vo.getItemCd()+ " - 존재하지 않는 제품\n"; 
			
			}else{
				mngMapper.saveMngProduct(vo);
				cnt += 1;
				
			}
		}
		
		if(errorMsgAll != "") {
			errorMsgAll = "[엑셀업로드 불가 항목]\n"+errorMsgAll;
		}
		
		return "총 "+cnt+" 건이 저장되었습니다\n\n"+errorMsgAll;
	}
	
	@Override
	public void updateMngProduct(List<MngVo> params, String id) {
		for(MngVo vo : params){
			vo.setUpdtId(id);
			mngMapper.updateMngProduct(vo);
		}
	}
	
	@Override
	public void sellMngProduct(List<MngVo> params, String id) {
		for(MngVo vo : params){
			vo.setUpdtId(id);
			mngMapper.sellMngProduct(vo);
		}
	}
	
	@Override
	public HashMap<String,Object> getQrInfo(HashMap<String,Object> params) {
		return mngMapper.getQrInfo(params);
	}

	@Override
	public MngVo getBarcodeInfo(HashMap<String,Object> params) {
		return mngMapper.getBarcodeInfo(params);
	}
	
	@Override
	public HashMap<String,Object> getTotalMngProductCnt() {
		return mngMapper.getTotalMngProductCnt();
	}
	
	
	//매출
	@Override
	public List<MngVo> getMngIncomeList(HashMap<String, Object> params) {
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		return mngMapper.getMngIncomeList(params);
	}
	
	@Override
	public HashMap<String,Object> getTotalMngIncomeCnt() {
		return mngMapper.getTotalMngIncomeCnt();
	}
	
	@Override
	public HashMap<String,Object> getLableMngIncomeCnt(HashMap<String, Object> params) {
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		return mngMapper.getLableMngIncomeCnt(params);
	}
	
	@Override
	public void deleteMngIncome(List<MngVo> params) {
		for(MngVo vo : params){
			mngMapper.deleteMngIncome(vo);
		}
	}
	
	@Override
	public void saveMngIncome(List<MngVo> params, String id) {
		for(MngVo vo : params){
			mngMapper.saveMngIncome(vo);
		}
	}
	
	@Override
	public void updateMngIncome(List<MngVo> params, String id) {
		for(MngVo vo : params){
			mngMapper.updateMngIncome(vo);
		}
	}
	
	@Override
	public String saveExcelMngIncome(List<MngVo> params, String id) {
		int cnt = 0;
		
		for(MngVo vo : params){
			vo.setCretId(id);
			mngMapper.saveMngIncome(vo);
			cnt += 1;
		}
		
		return "총 "+cnt+" 건이 저장되었습니다\n";
	}
	
}