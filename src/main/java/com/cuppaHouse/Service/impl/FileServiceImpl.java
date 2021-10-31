package com.cuppaHouse.Service.impl;

import java.io.File;
import java.util.HashMap;

import com.cuppaHouse.Service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FileServiceImpl implements FileService{

    @Override
    public String uploadFile(MultipartFile file, HashMap<String, String> params) throws Exception {
        String filePath = "/var/upload" + params.get("filePath"); // 파일경로 (upload가 기본 경로). 파일경로는 docker-tomcat에 볼륨 지정된 경로로 해야 한다.
        String fileName = params.get("fileName"); // 저장할 파일명
        String result = ""; // 결과 메세지
        try{
            File dest = new File(filePath ,fileName);
            if(!dest.exists()) // 해당 경로가 없을 경우 
                dest.mkdirs();  // 폴더 생성
            file.transferTo(dest);
            result = "success";
        }catch (Exception e){ // 실패시 예외
            e.printStackTrace(); 
            result = "fail";
        }
        return result;
    }

    @Override
    public String deleteFile(HashMap<String, String> params) throws Exception {
        String filePath = "/var/upload" + params.get("filePath");  // 삭제할 파일 경로
        String fileName = params.get("fileName"); // 삭제할 파일명
        String result ; // 결과 메세지
        try{
            File dest = new File(filePath ,fileName);
            if(dest.exists()){   // 파일이 존재하는 경우
                dest.delete();
                result = "file delete success";
            }else{  // 파일이 존재하지 않는 경우
                result = "file is not exist";
            }
        }catch (Exception e){ // 실패시 예외처리
            e.printStackTrace();
            result = "file delete fail";
        }
        return result;
    }
    
}