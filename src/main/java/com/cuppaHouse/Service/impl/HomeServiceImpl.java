package com.cuppaHouse.Service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cuppaHouse.Mappers.HomeMapper;
import com.cuppaHouse.Service.BuildingService;
import com.cuppaHouse.Service.HomeService;

@Service
public class HomeServiceImpl implements HomeService{

	@Autowired
	private HomeMapper homeMapper;
	
	

}