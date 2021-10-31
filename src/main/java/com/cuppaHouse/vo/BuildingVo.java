package com.cuppaHouse.vo;

public class BuildingVo {

	private String areaCd; 			
	private String areaNm;    
	private String bldgCd;
	private String bldgNm;
	private String dtlAddr;
	private String memo;
	private boolean activeYn;
	private String auth;
	private String updtDt;
	private String updtId;
	private String cretDt;
	private String cretId;
	public String getAreaCd() {
		return areaCd;
	}
	public void setAreaCd(String areaCd) {
		this.areaCd = areaCd;
	}
	public String getAreaNm() {
		return areaNm;
	}
	public void setAreaNm(String areaNm) {
		this.areaNm = areaNm;
	}
	public String getBldgCd() {
		return bldgCd;
	}
	public void setBldgCd(String bldgCd) {
		this.bldgCd = bldgCd;
	}
	public String getBldgNm() {
		return bldgNm;
	}
	public void setBldgNm(String bldgNm) {
		this.bldgNm = bldgNm;
	}
	public String getDtlAddr() {
		return dtlAddr;
	}
	public void setDtlAddr(String dtlAddr) {
		this.dtlAddr = dtlAddr;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public boolean isActiveYn() {
		return activeYn;
	}
	public void setActiveYn(boolean activeYn) {
		this.activeYn = activeYn;
	}
	public String getAuth() {
		return auth;
	}
	public void setAuth(String auth) {
		this.auth = auth;
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
	@Override
	public String toString() {
		return "BuildingVo [areaCd=" + areaCd + ", areaNm=" + areaNm + ", bldgCd=" + bldgCd + ", bldgNm=" + bldgNm
				+ ", dtlAddr=" + dtlAddr + ", memo=" + memo + ", activeYn=" + activeYn + ", auth=" + auth + ", updtDt="
				+ updtDt + ", updtId=" + updtId + ", cretDt=" + cretDt + ", cretId=" + cretId + "]";
	}
	
	
	

}
