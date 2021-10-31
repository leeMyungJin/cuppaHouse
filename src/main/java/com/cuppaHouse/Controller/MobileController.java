package com.cuppaHouse.Controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/mobile")
public class MobileController {
    
	// 주소 반환
	@ResponseBody
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/coordsToAddr", method = RequestMethod.GET, produces="application/json;charset=UTF-8")
	public String coordsToAddr(HttpServletRequest request) throws Exception{
		
		String latitude = (String) request.getParameter("la"); //위도 37.36258943634862
		String longitude = (String) request.getParameter("lo"); //경도 127.10448857547912
		
		String clientId = "6zo2j8nima";//애플리케이션 클라이언트 아이디값";
        	String clientSecret = "P1gOH0PfxPMpZwed4jg7otm7BH5Lkm62jWKSSf67";//애플리케이션 클라이언트 시크릿값
        try {
            String coords = longitude+","+latitude; //위도+경도
            String sourcecrs = "epsg:4326"; //좌표시스템
            String orders = "addr"; //법정동, 행정도, 지번, 도로명 조회 선택
            String output = "json"; //데이터 타입
            String apiURL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords="+coords+"&sourcecrs="+sourcecrs+"&orders="+orders+"&output="+output;
            
            /* orders 타입에 따라서 값 다름
             - legalcode: 좌표 to 법정동
			 - admcode: 좌표 to 행정동
			 - addr: 좌표 to 지번 주소
			 - roadaddr: 좌표 to 도로명 주소(새주소)
             * */
            
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setDoOutput(false); //url 서버와 통신시 출력 가능한 상태
            con.setRequestMethod("GET"); 
            con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId); 
            con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
            
			
			int responseCode = con.getResponseCode();
            BufferedReader br;
            String inputLine;
            StringBuffer response = new StringBuffer();
         
            if(responseCode==200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream())); //콘솔에서 버퍼를 입력받음
                
                while ((inputLine = br.readLine()) != null) {
	                response.append(inputLine);
	            }
	            br.close();
	            
	            //json 파싱 
	            JSONParser jsonParse = new JSONParser();
	            JSONObject jsonObj = (JSONObject) jsonParse.parse(response.toString()); //Json형태로 파싱해서 JsonObject에 넣음
	            
	            JSONObject regionObj = (JSONObject) ((JSONObject) ((JSONArray) jsonObj.get("results")).get(0)).get("region");
				JSONObject landObj = (JSONObject) ((JSONObject) ((JSONArray) jsonObj.get("results")).get(0)).get("land");
	            String area1 = (String) ((JSONObject)regionObj.get("area1")).get("name").toString();
	            String area2 = (String) ((JSONObject)regionObj.get("area2")).get("name").toString();
	            String area3 = (String) ((JSONObject)regionObj.get("area3")).get("name").toString();
				String area4 = (String) landObj.get("number1");
				String area5 = (String) landObj.get("number2");


	            JSONObject returnObj = new JSONObject();
	            returnObj.put("area1", area1);
	            returnObj.put("area2", area2);
	            returnObj.put("area3", area3);
	            returnObj.put("area4", area1+" "+area2);
		    returnObj.put("area5", area1+" "+area2+" "+area3);
		    returnObj.put("area6", area1+" "+area2+" "+area3+" "+area4+"-"+area5);
	            returnObj.put("area7", area2+" "+area3+" "+area4+"-"+area5);

	            return returnObj.toString();
                
            } else {  // 오류 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
                
                while ((inputLine = br.readLine()) != null) {
	                response.append(inputLine);
	            }
	            br.close();
	            
	            return response.toString();
            }
          
			
        } catch (Exception e) {
            System.out.println(e);
            return e.toString();
        }
	}
 	
}
