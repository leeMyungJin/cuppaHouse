<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커파하우스 물품 QR출력</title>
    <link rel="stylesheet" href="../css/reset.css">
    <link rel="icon" type="image/x-icon" href="../image/favicon.ico" >
    <link rel="short icon" type="image/x-icon" href="../image/favicon.ico" >
    <%@ include file="../include/header.jsp" %>
    <style>
        .qr_wrap{width:1500px; max-width:1500px;}
        .btn_wrap{text-align:right; margin:5px 45px;}
        .btn_wrap a{display:inline-block; padding:8px 18px; color:#fff; background-color:#0C1842;}
        .qr_list{display:flex; flex-wrap: wrap;}
        .qr_list li{flex-basis:33.3333%; text-align:center; padding:0 50px 18px;}
        .qr, .txt{border:1px solid #333; border-radius:10px;}
        .qr{margin:auto; width:100px; height:100px; line-height:100px; font-weight: bold; font-size:24px;}
        .txt{margin-top:5px; padding:8px 0;}
        @media print{
            .btn_wrap, .btn_wrap *{display: none;}
        }
        .wj-barcode-codabar {
		    height: 90px;
		}
        
    </style>
</head>

<script type="text/javascript">

var memberId = "<%=session.getAttribute("id")%>";
var memberAuth = "<%=session.getAttribute("auth")%>";

function setStockQr(){
	sessionCheck(memberId, memberAuth, 'stock');
	
	var barcodeList = "${barcodeCnt}";
	console.log(barcodeList);
	 for(var i =1; i<=barcodeList; i++){
		 console.log(i);
		 let barcodeCode = new wijmo.barcode.common.Code128('#barcode_'+i , {
            value : $("#barcode_"+i).attr("cd")
            , autoWidthZoom: 2
	    }); 
	    
	    /* let barcodeCode = new wijmo.barcode.common.Codabar('#barcode' , {
            value : 'A15126893B'
            , autoWidthZoom: 2
	    }); */
	} 
}
</script>

<body onload="setStockQr()">
    <div class="qr_wrap">
        <div class="btn_wrap"><a href="javascript:window.print()">출력하기</a></div>
        <ul class="qr_list" style="clear:both;">
            <c:forEach var="barcodeList" items="${barcodeList}" varStatus="status">
	            <li>
	                <div id="barcode_${status.count}" style="margin:10px;" cd="${barcodeList.barcode}"></div>
	                <p class="txt">${barcodeList.barcode}</p>
	                <p class="txt">${barcodeList.itemNm}</p>
	            </li>
            </c:forEach>
        </ul>
        <div id="barcode"></div>
        <div class="btn_wrap"><a href="javascript:window.print()">출력하기</a></div>
    </div>
</body>
</html>