package com.cuppaHouse.Service;

import java.util.HashMap;

public interface TermService {
    
    public String getTermService();

    public void saveTermService(HashMap<String,String> params, String id);

    public String getTermPrivacy();

    public void saveTermPrivacy(HashMap<String,String> params, String id);
    
    public String getTermLocation();

    public void saveTermLocation(HashMap<String,String> params, String id);
}
