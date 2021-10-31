package com.cuppaHouse.Service;

import java.util.HashMap;

public interface PushService {
    public String sendPush(HashMap<String,String> params) throws Exception ;
    public String getUserToken(HashMap<String,String> params);
    
}
