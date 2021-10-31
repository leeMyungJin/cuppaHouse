package com.cuppaHouse.Service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cuppaHouse.Util.Util;
import com.cuppaHouse.vo.StockVo;
import com.cuppaHouse.vo.BuildingVo;
import com.cuppaHouse.vo.CodeVo;
import com.cuppaHouse.vo.MngVo;
import com.cuppaHouse.Mappers.BuildingMapper;
import com.cuppaHouse.Mappers.StockMapper;
import com.cuppaHouse.Service.BuildingService;
import com.cuppaHouse.Service.StockService;

@Service
public class StockServiceImpl implements StockService{

	@Autowired
	private StockMapper stockMapper;
	
	@Override
	public List<StockVo> getStockManageList(HashMap<String, Object> params) {
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		return stockMapper.getStockManageList(params);
	}
	
	@Override
	public List<CodeVo> getStockQrList(HashMap<String, Object> params) {
		if(params.get("selectStock") != null)
			params.replace("selectStock", Util.makeForeach((String)params.get("selectStock"), ","));
		return stockMapper.getStockQrList(params);
	}

	@Override
	public String getTotalItemCnt() {
		return stockMapper.getTotalItemCnt();
	}
	
	@Override
	public List<StockVo> getCategoryList() {
		return stockMapper.getCategoryList();
	}

	@Override
	public void deleteCategory(List<StockVo> params) {
		for(StockVo vo : params)
			stockMapper.deleteCategory(vo);
	}

	@Override
	public void saveCategory(List<StockVo> params, String id) {
		for(StockVo vo : params){
			vo.setUpdtId(id);
			vo.setCretId(id);
			stockMapper.saveCategory(vo);
		}
	}
	
	@Override
	public void updateCategory(List<StockVo> params, String id) {
		for(StockVo vo : params){
			vo.setUpdtId(id);
			vo.setCretId(id);
			stockMapper.updateCategory(vo);
		}
	}

	@Override
	public List<StockVo> getLCategoryList(HashMap<String,Object> params) {
		return stockMapper.getLCategoryList(params);
	}	
	@Override
	public List<StockVo> getMCategoryList(HashMap<String,Object> params) {
		return stockMapper.getMCategoryList(params);
	}

	@Override
	public void addItem(StockVo  params) {
		stockMapper.addItem(params);
	}

	@Override
	public void deleteItem(List<StockVo> params) {
		for(StockVo vo : params)
			stockMapper.deleteItem(vo);
		
	}

	@Override
	public Integer saveItem(List<StockVo> params, String id) {
		int cnt = 0;
		for(StockVo vo : params){
			vo.setUpdtId(id);
			
			stockMapper.saveItem(vo);
			cnt++;
		}
		return cnt;		
	}	
	
	@Override
	public List<StockVo> dupCategoryChk(HashMap<String,Object> params) {
		return stockMapper.dupCategoryChk(params);
	}
	
	@Override
	public List<StockVo> getPartName(HashMap<String,Object> params) {
		return stockMapper.getPartName(params);
	}
	
	@Override
	public List<StockVo> getPartFullList(HashMap<String,Object> params) {
		return stockMapper.getPartFullList(params);
	}
	
	
	@Override
	public List<StockVo> getPartList(HashMap<String,Object> params) {
		return stockMapper.getPartList(params);
	}
	
	@Override
	public void deletePart(List<StockVo> params) {
		for(StockVo vo : params)
			stockMapper.deletePart(vo);
	}

	@Override
	public void savePart(List<StockVo> params, String id) {
		for(StockVo vo : params){
			vo.setUpdtId(id);
			vo.setCretId(id);
			stockMapper.savePart(vo);
		}
	}
	
	@Override
	public void updatePart(List<StockVo> params, String id) {
		for(StockVo vo : params){
			vo.setUpdtId(id);
			stockMapper.updatePart(vo);
		}
	}
	
	@Override
	public String savePartExcelGrid(List<StockVo> params, String id) {
		int cnt = 0;
		int voCount = 0;
		String errorMsgAll = "";
		List<StockVo> dataChk; 
		
		for(StockVo vo : params){
			vo.setCretId(id);
			dataChk = stockMapper.savePartExcelGridVal(vo);
			voCount += 1;
			
			if(dataChk.size() > 0 && dataChk.get(0).getItemCd() != null) {
				stockMapper.savePartExcelGrid(vo);
				cnt += 1;
			
			}else {
				errorMsgAll += voCount + "번 항목 : "+vo.getItemCd() + " - " + vo.getPartCd() + "\n"; 
			}
		}
		
		if(errorMsgAll != "") {
			errorMsgAll = "[엑셀업로드 불가 항목]\n"+errorMsgAll;
		}
		
		return "총 "+cnt+" 건이 저장되었습니다\n\n"+errorMsgAll;
	}
	
	@Override
	public String saveExcelGrid(List<StockVo> params, String id) {
		int cnt = 0;
		int voCount = 0;
		Boolean flag = true;
		String errorMsgAll = "";
		List<StockVo> dataChk; 
		
		for(StockVo vo : params){
			vo.setCretId(id);
			dataChk = stockMapper.saveExcelGridVal(vo);
			voCount += 1;
			flag = true;
			
			if(dataChk.get(0).getmCategyCd() == null) {
				errorMsgAll += voCount + "번 항목 : "+vo.getItemCd() + " - 카테고리 부적합\n"; 
				flag = false;
			}
			
			if(dataChk.get(0).getItemCdLen() != 10){
				errorMsgAll += voCount + "번 항목 : "+vo.getItemCd() + " - 물품코드 자릿수(10자리) 부적합\n"; 
				flag = false;
			}
			
			if(dataChk.get(0).getItemCd() != null){
				errorMsgAll += voCount + "번 항목 : "+vo.getItemCd() + " - 기저장 된 물품코드\n"; 
				flag = false;
			}
			
			if(flag) {
				stockMapper.saveExcelGrid(vo);
				cnt += 1;
				
			}
		}
		
		if(errorMsgAll != "") {
			errorMsgAll = "[엑셀업로드 불가 항목]\n"+errorMsgAll;
		}
		
		return "총 "+cnt+" 건이 저장되었습니다\n\n"+errorMsgAll;
	}
	
	
	
	/////////재고입력////////////////////
	@Override
	public HashMap<String,Object> getTotalEntryCnt() {
		return stockMapper.getTotalEntryCnt();
	}
	
	@Override
	public List<StockVo> getEntryList(HashMap<String, Object> params) {
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		return stockMapper.getEntryList(params);
	}
	
	@Override
	public void saveEntry(List<StockVo> params, String id) {
		Integer maxGroupSeq = stockMapper.getGroupSeq();
		String type = params.get(0).getClassifiCd();
		
		for(StockVo vo : params){
			vo.setUpdtId(id);
			vo.setCretId(id);
			vo.setGroupSeq(maxGroupSeq);
			stockMapper.updateQuantity(vo);
			stockMapper.saveEntry(vo);
		}
		
		StockVo vo2 = new StockVo();
		vo2.setClassifiCd(type);
		vo2.setGroupSeq(maxGroupSeq);
		stockMapper.updateAutoQuantity(vo2);
		stockMapper.insertAutoQuantity(vo2);
		
	}	
	
	@Override
	public List<StockVo> getBldgList(HashMap<String,Object> params) {
		return stockMapper.getBldgList(params);
	}	
	
	@Override
	public List<StockVo> getItemList(HashMap<String,Object> params) {
		return stockMapper.getItemList(params);
	}	
	
	
	/////////재고이력////////////
	@Override
	public HashMap<String,Object> getTotalHistoryCnt() {
		return stockMapper.getTotalHistoryCnt();
	}
	
	@Override
	public List<StockVo> getHistoryList(HashMap<String, Object> params) {
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		return stockMapper.getHistoryList(params);
	}
	
	@Override
	public void saveHistory(List<StockVo> params, String id) {
		for(StockVo vo : params){
			vo.setUpdtId(id);
			vo.setCretId(id);
			stockMapper.updateQuantity(vo);
			stockMapper.saveHistory(vo);
		}
	}	
	
	@Override
	public void deleteHistory(HashMap<String,Object> params) {
		//입출고내역 원복 
		stockMapper.resetHistory(params);
		
		//입고/반입(return_quantity) :  증가 판재, 파트 리스트 조회해서 해당 재고 플러스 (소모품, 판재입고는 이력에만 저장. 재고 자동 변동 없음)
		//출고/반출(return_quantity) :  감소 파트, 제품 리스트 조회해서 해당 재고 마이너스 (소모품, 판재입고는 이력에만 저장. 재고 자동 변동 없음)
		stockMapper.resetHistoryAutoval(params);
		
		//이력 삭제
		stockMapper.deleteHistorySar(params);
		
		//이력 등록시 자동변환 된 내역 삭제
		stockMapper.deleteHistorySarAuto(params);
	}
	
	
	////////////////// 재고현황 ////////////////////////
	@Override
	public HashMap<String,Object> getTotalPresentAmt() {
		return stockMapper.getTotalPresentAmt();
	}
	
	@Override
	public List<StockVo> getPresentList(HashMap<String, Object> params) {
		if(params.get("inq") != null)
			params.replace("inq", Util.makeForeach((String)params.get("inq"), ","));
		return stockMapper.getPresentList(params);
	}
	
	@Override
	public List<StockVo> getPartPresentList(HashMap<String,Object> params) {
		return stockMapper.getPartPresentList(params);
	}
	
	@Override
	public List<StockVo> getStockDtl(HashMap<String,Object> params) {
		return stockMapper.getStockDtl(params);
	}
	
	@Override
	public List<MngVo> getStockBarcodeList(HashMap<String, Object> params) {
		if(params.get("selectBarcode") != null)
			params.replace("selectBarcode", Util.makeForeach((String)params.get("selectBarcode"), ","));
		return stockMapper.getStockBarcodeList(params);
	}
	
	//////////홈///////////////////
	@Override
	public HashMap<String,Object> getTotalHomeCnt() {
		return stockMapper.getTotalHomeCnt();
	}

}