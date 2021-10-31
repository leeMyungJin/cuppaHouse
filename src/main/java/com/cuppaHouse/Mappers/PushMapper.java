package com.cuppaHouse.Mappers;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PushMapper  {
    public String getUserToken(HashMap<String, String> params);
}
