package com.cuppaHouse.vo;

public class MngVo {
	private String itemNm;
	private String itemCd; 	
	private String prodCd; 	
	private String partCd; 	
	private String barcode; 
	private String barcodeTemp;
	private String sellYn; 	
	private String sellDt;
	private String colorCd; 	
	private String prodSeq; 	
	private String cretDt; 	
	private String cretId; 	
	private String updtDt; 	
	private String updtId;
	private String selectYn;
	
	//매출
	private Integer incomeSeq;
	private Integer sellAmt;
	private Integer sellCnt;
	private Integer cost;
	private String path;
	private String custNm;
	private String memo;
	
	public String getItemNm() {
		return itemNm;
	}
	public void setItemNm(String itemNm) {
		this.itemNm = itemNm;
	}
	public String getItemCd() {
		return itemCd;
	}
	public void setItemCd(String itemCd) {
		this.itemCd = itemCd;
	}
	public String getProdCd() {
		return prodCd;
	}
	public void setProdCd(String prodCd) {
		this.prodCd = prodCd;
	}
	public String getPartCd() {
		return partCd;
	}
	public void setPartCd(String partCd) {
		this.partCd = partCd;
	}
	public String getBarcode() {
		return barcode;
	}
	public void setBarcode(String barcode) {
		this.barcode = barcode;
	}
	public String getBarcodeTemp() {
		return barcodeTemp;
	}
	public void setBarcodeTemp(String barcodeTemp) {
		this.barcodeTemp = barcodeTemp;
	}
	public String getSellYn() {
		return sellYn;
	}
	public void setSellYn(String sellYn) {
		this.sellYn = sellYn;
	}
	public String getSellDt() {
		return sellDt;
	}
	public void setSellDt(String sellDt) {
		this.sellDt = sellDt;
	}
	public String getColorCd() {
		return colorCd;
	}
	public void setColorCd(String colorCd) {
		this.colorCd = colorCd;
	}
	public String getProdSeq() {
		return prodSeq;
	}
	public void setProdSeq(String prodSeq) {
		this.prodSeq = prodSeq;
	}
	public String getCretDt() {
		return cretDt;
	}
	public void setCretDt(String cretDt) {
		this.cretDt = cretDt;
	}
	public String getCretId() {
		return cretId;
	}
	public void setCretId(String cretId) {
		this.cretId = cretId;
	}
	public String getUpdtDt() {
		return updtDt;
	}
	public void setUpdtDt(String updtDt) {
		this.updtDt = updtDt;
	}
	public String getUpdtId() {
		return updtId;
	}
	public void setUpdtId(String updtId) {
		this.updtId = updtId;
	}
	public String getSelectYn() {
		return selectYn;
	}
	public void setSelectYn(String selectYn) {
		this.selectYn = selectYn;
	}
	public Integer getIncomeSeq() {
		return incomeSeq;
	}
	public void setIncomeSeq(Integer incomeSeq) {
		this.incomeSeq = incomeSeq;
	}
	public Integer getSellAmt() {
		return sellAmt;
	}
	public void setSellAmt(Integer sellAmt) {
		this.sellAmt = sellAmt;
	}
	public Integer getSellCnt() {
		return sellCnt;
	}
	public void setSellCnt(Integer sellCnt) {
		this.sellCnt = sellCnt;
	}
	public Integer getCost() {
		return cost;
	}
	public void setCost(Integer cost) {
		this.cost = cost;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getCustNm() {
		return custNm;
	}
	public void setCustNm(String custNm) {
		this.custNm = custNm;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	@Override
	public String toString() {
		return "MngVo [itemNm=" + itemNm + ", itemCd=" + itemCd + ", prodCd=" + prodCd + ", partCd=" + partCd
				+ ", barcode=" + barcode + ", barcodeTemp=" + barcodeTemp + ", sellYn=" + sellYn + ", sellDt=" + sellDt
				+ ", colorCd=" + colorCd + ", prodSeq=" + prodSeq + ", cretDt=" + cretDt + ", cretId=" + cretId
				+ ", updtDt=" + updtDt + ", updtId=" + updtId + ", selectYn=" + selectYn + ", incomeSeq=" + incomeSeq
				+ ", sellAmt=" + sellAmt + ", sellCnt=" + sellCnt + ", cost=" + cost + ", path=" + path + ", custNm="
				+ custNm + ", memo=" + memo + "]";
	}
	
	
	
}
