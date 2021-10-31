<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
    
<script type="text/javascript">

<%
Cookie[] cookies = request.getCookies();
if(cookies !=null){
    for(Cookie tempCookie : cookies){
        if(tempCookie.getName().equals("id")){
            //쿠키값으로 대신 로그인 처리함
            %>
            $.ajax({
                  url : '<%=request.getContextPath()%>/login/autoLogin',
                  async : false, // 비동기모드 : true, 동기식모드 : false
                  type : 'POST', 
                  cache : false,
                  dataType : 'text',
                  data : {id : "<%=tempCookie.getValue()%>"},
                  success : function(data) {
                    location.href="/home/";
                  },
                  error : function(request,status,error) {
                    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                  }
            });
            <%
        }
    }
}
%>

function autoLoginCheck(){
  if($('#auto-login').val() =='off'){
    $('#auto-login').val('on');
  }else{
    $('#auto-login').val('off');
  }
}

function login(){
    if(!login_form.id.value){
        alert("아이디를 입력하세요");
        login_form.id.focus();
        return false;
    
    }else if(!login_form.password.value){
        alert("비밀번호를 입력하세요");
        login_form.password.focus();
        return false;
    }
    
    var params = {
    	id 	: login_form.id.value
   		,pass	: login_form.password.value
   		,autoLogin : $('#auto-login').val()
   	}
   	
   	$.ajax({
        url : "/login/login",
        async : true, // 비동기모드(화면전환 X) : true, 동기식모드 : false
        type : 'POST',
        cache : false,
        dataType : 'text',
        data : params,
        success : function(data) {
        	if(data == "/home/")
        		location.href = data; 
        	else 
        		alert(data);
        },
        error : function(request,status,error) {
         	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
}

function enterkey() {
    if (window.event.keyCode == 13) {
    	login();
    }
}


</script>
</head>
<body>
    <div class="login_wrap">
        <!--로그인 영역-->
        <div class="login_box">
            <h2>sign in</h2>
            <form action="#" id="login_form" method="post" name="login_form">
                <fieldset class="login_fld">
                    <legend class="blind">로그인</legend>
                    <input type="text" class="icon" id="id" name="id" placeholder="아이디를 입력하세요"  onkeyup="enterkey();">
                    <input type="password" class="icon" id="pass" name="password" placeholder="비밀번호를 입력하세요"  onkeyup="enterkey();">
                    <div class="login_check">
                        <input type="checkbox" id="auto-login" name="auto-login">
                        <label for="auto-login">자동 로그인</label>
                    </div>
                    <button type="button" class="login_btn" onClick="login()">
                        <span class="front">go to home</span><em></em>
                    </button>
                </fieldset>
            </form>
            <p class="find_area">ID와 비밀번호 찾기는 관리자에게 문의바랍니다</p>
        </div>
        <div class="login_area">
            <div class="terms_area">
                <a href="/terms/service">이용약관</a>
                <a href="/terms/privacy">개인정보처리방침</a>
               <!--  <a href="/terms/location">위치정보이용약관</a> -->
            </div>
            <h1 class="logo"></h1>
        </div>
    </div>
</body>
</html>