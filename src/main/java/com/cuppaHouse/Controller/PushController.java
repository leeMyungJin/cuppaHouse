package com.cuppaHouse.Controller;

import java.util.HashMap;

import com.cuppaHouse.Service.PushService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/push")
public class PushController {

    @Autowired
    PushService pushService;

    @Autowired
    Environment environment;

    /**
     * DB에서 사용자 토큰을 가져와서 각 사용자별로 FCM Push 발송처리
     * @param params
     * @return 성공여부
     * @throws Exception
     */
    @RequestMapping(value="/send")
    @ResponseBody
    public String sendPush(@RequestParam HashMap<String,String> params ) throws Exception {

        String userToken = pushService.getUserToken(params); // DB에서 사용자 토큰 가져오기
        String result ="fail";
        if(userToken.length() > 0){ // 토큰이 존재하는 경우에만 처리
                params.put("userToken",pushService.getUserToken(params)); // 사용자 토큰 추가 
                params.put("firebaseKeyPath",environment.getProperty("firebase.path.key")); // key파일 path 가져오기
                result = pushService.sendPush(params);
        }
        return result;
    }
    
}