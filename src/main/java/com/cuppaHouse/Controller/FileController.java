package com.cuppaHouse.Controller;

import java.util.HashMap;

import com.cuppaHouse.Service.FileService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping(value = "/file")
public class FileController {
    
    @Autowired
    FileService fileService;

    @RequestMapping(value = "/uploadFile")
    @ResponseBody
    public String uploadFile( MultipartFile file , @RequestParam HashMap<String,String> params) throws Exception{
        return fileService.uploadFile(file, params);
    }

    @RequestMapping(value = "/deleteFile")
    @ResponseBody
    public String deleteFile(@RequestParam HashMap<String,String> params) throws Exception{
        return fileService.deleteFile(params);
    }
}