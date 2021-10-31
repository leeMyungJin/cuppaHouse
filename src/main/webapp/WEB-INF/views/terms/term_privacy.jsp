<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" type="image/x-icon" href="../image/favicon.ico">
    <title>커파하우스 개인정보수집약관</title>
    <style>
        html, body, div, span, applet, object, iframe,
        h1, h2, h3, h4, h5, h6, p, blockquote, pre,
        a, abbr, acronym, address, big, cite, code,
        del, dfn, em, img, ins, kbd, q, s, samp,
        small, strike, strong, sub, sup, tt, var,
        b, u, i, center,
        dl, dt, dd, ol, ul, li,
        fieldset, form, label, legend,
        table, caption, tbody, tfoot, thead, tr, th, td,
        article, aside, canvas, details, embed, 
        figure, figcaption, footer, header, hgroup, 
        menu, nav, output, ruby, section, summary,
        time, mark, audio, video {
            margin: 0;
            padding: 0;
            border: 0;
            box-sizing: border-box;
        }
        body{width:100%; line-height: 1.4; color:#333; overflow-x:hidden;}
        ol,ul,li{list-style:none;}
        article{padding:25px; font-size:14px;}
        p{padding:8px 0;}
        h1{margin:-25px -25px 20px; padding:14px 25px; background-color:#eee;}
        section{margin:30px 0; padding:12px;}
        h2{margin:15px 0;padding-top:30px; font-size:1.25em; border-top:1px solid #ddd;}
        h3{padding:12px 0; font-size:1.15em;}
        h4{padding:6px 0;font-weight:500;}
        strong{display:inline-block; margin-top:12px;}
        li{margin-top:10px;}
        ul,ol{margin-left:8px;}
        table{margin-bottom:15px; width:100%; border-collapse: collapse;}
        table th,td{border:solid #ddd; border-width:1px 0; padding:6px 10px;}
        table th{width:30%; background-color:#f5f5f5;}
        @media screen and (max-width:360px){
            .terms_wrp{padding:15px;}
            .terms_tit{margin:-15px -15px 15px; padding:10px 15px;}
        }
    </style>
</head>
<body>
    <article class="terms_wrp">
        <h1 class="terms_tit">개인정보수집약관</h1>
        <%=request.getAttribute("termPrivacy")%>
    </article>
</body>
</html>