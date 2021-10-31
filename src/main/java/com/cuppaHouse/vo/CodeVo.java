package com.cuppaHouse.vo;

public class CodeVo {

	private String cd; 				//코드
	private String nm;     	//대카테고리코드
	public String getCd() {
		return cd;
	}
	public void setCd(String cd) {
		this.cd = cd;
	}
	public String getNm() {
		return nm;
	}
	public void setNm(String nm) {
		this.nm = nm;
	}
	@Override
	public String toString() {
		return "CodeVo [cd=" + cd + ", nm=" + nm + "]";
	}

	

}
