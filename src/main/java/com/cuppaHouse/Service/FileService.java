package com.cuppaHouse.Service;

import java.util.HashMap;

import org.springframework.web.multipart.MultipartFile;

public interface FileService {

    public String uploadFile(MultipartFile file, HashMap<String,String>params) throws Exception;
    public String deleteFile(HashMap<String,String>params) throws Exception;
    
}