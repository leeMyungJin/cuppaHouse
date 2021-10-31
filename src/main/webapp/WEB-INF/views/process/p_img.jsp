<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html lang="ko">
<head><meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="keywords" content="커파하우스, cuppahouse, image, 이미지">
    <meta name="description" content="커파하우스">
    <meta property="og:type" content="website">
    <meta property="og:title" content="커파하우스">
    <meta property="og:description" content="커파하우스 컨텐츠 관리 시스템 이미지 보기">
    <meta property="og:image" content="https://contents.sixshop.com/uploadedFiles/99663/default/image_1574307694040.png">
    <title>커파하우스</title>
    <link rel="stylesheet" href="../css/reset.css">
    <link rel="stylesheet" href="../css/common.css">
    <link rel="icon" type="image/x-icon" href="../image/favicon.ico" >
    <link rel="short icon" type="image/x-icon" href="../image/favicon.ico" >
    <script src="https://code.jquery.com/jquery-2.2.4.js" integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI=" crossorigin="anonymous"></script>
    <script src="../js/common.js"></script>
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        $( document ).ready( function() {
            AOS.init();
            
            var imgPath = '${imgPath}'.split(',');
            
            if('${imgPath}' != '' && imgPath.length > 0){
            	for(var i=0; i<imgPath.length; i++){
            		
            		$('#site_img').append('<li class="aos-init aos-animate" data-aos="fade-up" data-aos-duration="1000" data-aos-easing="ease-in-out"><img src="'+imgPath[i]+'" alt="이미지" height="400" width="400"></li>');
            	}
            }
        } );
      </script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400&display=swap');
        body{font-family: 'Montserrat', sans-serif; background-color:#f7f7f7;}
        h2, h3{font-weight:700;}
        .img_content{padding:20px;}
        .img_content li{position:relative; margin:0 0 12px 0; height:300px; box-shadow: 3px 8px 10px rgba(177, 177, 177, 0.2); background-color: #fff; overflow:hidden;}
        .img_content li img{position:absolute; top:0; left:0; right:0; bottom:0; margin:auto; width:auto; max-width:100%; height:auto; max-height:100%;}
        /* tablet */
        @media screen and (min-width:720px) and (max-width:1099px){
            .img_content{padding:40px;}
            .img_content h3{font-size:40px;}
            .img_content .img_img:after{display: block; content:""; clear: both;}
            .img_content .img_img li{float:left; width:calc(50% - 30px); margin:0 12px 24px;}
        }
        /* pc */
        @media screen and (min-width:1100px){
            .img_content h3{margin:100px 0; text-align:center; color:#000; font-size:70px; font-weight:700;} 
            .img_content h3 br{display:none;}
            .img_content .img_img:after{display: block; content:""; clear: both;}
            .img_content .img_img li{float:left; width:calc(50% - 30px); margin:0 15px 30px; height:580px; line-height:580px;}
        }
    </style>
</head>
<body>
    <div class="img_wrap">
        <div class="img_content">
            <ul class="img_img" id="site_img">
             </ul>
        </div>
    </div>
</body>
</html>