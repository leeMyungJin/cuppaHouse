package com.cuppaHouse.Service.impl;

import java.util.HashMap;

import com.cuppaHouse.Mappers.TermMapper;
import com.cuppaHouse.Service.TermService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TermServiceImpl implements TermService{

    @Autowired
    TermMapper termMappper;

    @Override
    public String getTermService() {
        return termMappper.getTermService();
    }

    @Override
    public void saveTermService(HashMap<String, String> params, String id) {
        params.put("updtId", id);
        termMappper.saveTermService(params);
    }

    @Override
    public String getTermPrivacy() {
        return termMappper.getTermPrivacy();
    }

    @Override
    public void saveTermPrivacy(HashMap<String, String> params, String id) {
        params.put("updtId", id);
        termMappper.saveTermPrivacy(params);
    }
    
    @Override
    public String getTermLocation() {
        return termMappper.getTermLocation();
    }

    @Override
    public void saveTermLocation(HashMap<String, String> params, String id) {
        params.put("updtId", id);
        termMappper.saveTermLocation(params);
    }
    
}
