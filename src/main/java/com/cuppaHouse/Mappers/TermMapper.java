package com.cuppaHouse.Mappers;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TermMapper {
    
    public String getTermService();
    
	public void saveTermService(HashMap<String,String> params);
    
    public String getTermPrivacy();
    
	public void saveTermPrivacy(HashMap<String,String> params);
	
    public String getTermLocation();
    
	public void saveTermLocation(HashMap<String,String> params);
}
