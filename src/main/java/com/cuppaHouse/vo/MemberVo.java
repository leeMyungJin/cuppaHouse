package com.cuppaHouse.vo;

public class MemberVo {
	private String id; 	//직원 아이디 
	private String pass; 	//직원 비밀번
	private String name;	//직원 이름 
	private String pnum;	//직원 전화번호 
	private String email; 	//직원 이메
	private String memo;		//메모 
	private boolean activeYn;	//활성화여부 
	private String lateassDt;	//최근접속일
	private String cretDt;		//등록일
	private String cretId;		//등록자 
	private String updtDt;		//수정일 
	private String updtId;		//수정자 
	private String passwordKey; //비밀번호 솔트
	private String position; //직급 
	private String appversion;
	private String auth; //접근권한
	private String dept; //부서
	private String bldgCd; //건물코드
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPnum() {
		return pnum;
	}
	public void setPnum(String pnum) {
		this.pnum = pnum;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
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
	public String getLateassDt() {
		return lateassDt;
	}
	public void setLateassDt(String lateassDt) {
		this.lateassDt = lateassDt;
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
	public String getPasswordKey() {
		return passwordKey;
	}
	public void setPasswordKey(String passwordKey) {
		this.passwordKey = passwordKey;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getAppversion() {
		return appversion;
	}
	public void setAppversion(String appversion) {
		this.appversion = appversion;
	}
	public String getAuth() {
		return auth;
	}
	public void setAuth(String auth) {
		this.auth = auth;
	}
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		this.dept = dept;
	}
	public String getBldgCd() {
		return bldgCd;
	}
	public void setBldgCd(String bldgCd) {
		this.bldgCd = bldgCd;
	}
	@Override
	public String toString() {
		return "MemberVo [id=" + id + ", pass=" + pass + ", name=" + name + ", pnum=" + pnum + ", email=" + email
				+ ", memo=" + memo + ", activeYn=" + activeYn + ", lateassDt=" + lateassDt + ", cretDt=" + cretDt
				+ ", cretId=" + cretId + ", updtDt=" + updtDt + ", updtId=" + updtId + ", passwordKey=" + passwordKey
				+ ", position=" + position + ", appversion=" + appversion + ", auth=" + auth + ", dept=" + dept
				+ ", bldgCd=" + bldgCd + "]";
	}
	
	
	
	

}
