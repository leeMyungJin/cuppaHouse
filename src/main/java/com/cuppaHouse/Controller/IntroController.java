package com.cuppaHouse.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class IntroController {
	
	@RequestMapping(value = "/", method = {RequestMethod.POST , RequestMethod.GET})
    public String intro() {
        return "login/login";
    }
	
	
	@RequestMapping(value = "/index", method = {RequestMethod.POST , RequestMethod.GET})
    public String index() {
        return "index";
    }
}
