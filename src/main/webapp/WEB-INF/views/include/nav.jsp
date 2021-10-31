<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<aside class="main_sidebar">
    <h1 class="logo logo_nav">로고</h1>
    <ul class="main_nav">
        <li><a id="home" href="/home/" class="dept1 home">홈 화면</a></li>
        <li><a id="member" href="/member/" class="dept1 member">회원관리</a></li>
        <li><a id="building" href="/building/" class="dept1 building">건물관리</a></li>
        <li><a id="work" href="/work/" class="dept1 work">근태관리</a></li>
        <li>
            <a id="stock" href="/stock/manage" class="dept1 stock">재고관리</a>
            <ul class="dept2">
                <li><a id="stock_manage" href="/stock/manage">물품관리</a></li>
                <li><a id="stock_entry" href="/stock/entry">재고입력</a></li>
                <li><a id="stock_present" href="/stock/present">재고현황</a></li>
                <li><a id="stock_history" href="/stock/history">재고이력</a></li>
            </ul>
        </li>
        <li><a id="process" href="/process/" class="dept1 process">공정관리</a></li>
        <li>
            <a id="mng" href="/mng/product" class="dept1 sales">판매관리</a>
            <ul class="dept2">
                <li><a id="mng_product" href="/mng/product">제품관리</a></li>
                <li><a id="mng_sales_history" href="/mng/history">판매이력</a></li>
                <li><a id="mng_income" href="/mng/income">매출관리</a></li>
            </ul>
        </li>
        <li><a id="terms" href="/terms/" class="dept1 terms">약관관리</a></li>
    </ul>
    <a href="javascript:_logOut()" class="main_out" data-hover="exit"><span>관리자모드나가기</span> </a>
</aside>