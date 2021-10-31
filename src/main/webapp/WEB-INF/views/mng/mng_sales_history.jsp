<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

 <script type="text/javascript">
 
 var mngHistView;
 var mngHistGridPager;
 var mngHistGrid;
 var mngHistColumns;
 var mngHistSelector;
 
 var editGrid;
 var editGridView;
 
 var memberId = "<%=session.getAttribute("id")%>";
 var memberAuth = "<%=session.getAttribute("auth")%>";
 
 function pageLoad(){
 	sessionCheck(memberId, memberAuth, 'mng_sales_history');
 	
 	$('#mng_sales_history').addClass("current");
 	
 	var fromDate = new Date()
	fromDate.setDate(fromDate.getDate() - 7);
	var fromday = _getFormatDate(fromDate);
	var today = _getFormatDate(new Date());
	$('#fromDate').val(fromday);
	$('#toDate').val(today);
	$('#fromDate').attr('max',today);
	$('#toDate').attr('max',today);
 	
 	loadGridList('init');
 }
 
 function enterkey() {
	    if (window.event.keyCode == 13) {
	    	getMngHistList();
	    }
	}

 
//그리드 초기 셋팅
 function loadGridList(type, result){
 	  if(type == "init"){
 		   mngHistView = new wijmo.collections.CollectionView(result, {
 		       pageSize: 100
 		   });
 		    
 		   mngHistGridPager = new wijmo.input.CollectionViewNavigator('#mngHistGridPager', {
 		        byPage: true,
 		        headerFormat: '{currentPage:n0} / {pageCount:n0}',
 		        cv: mngHistView
 		    });
 		   
 		   mngHistColumns = [
 			   { isReadOnly: true, width: 35, align:"center"},
 		      { binding: 'itemNm', header: '제품명', isReadOnly: true, width: 200, align:"center" },
 		      { binding: 'sellDt', header: '일자', isReadOnly: true, width: 100, align:"center"  },
 		      { binding: 'prodCd', header: '제품코드', isReadOnly: true, width: 100, align:"center"},
 		      { binding: 'partCd', header: '파트코드', isReadOnly: true, width: 100, align:"center" },
 		      { binding: 'colorCd', header: '색상코드', isReadOnly: true, width: 100, align:"center"},
 		      { binding: 'prodSeq', header: '생산순번', isReadOnly: true, width: 100, align:"center"  },
 		      { binding: 'barcode', header: '바코드번호', isReadOnly: false, width: 150, align:"center"  },
 		      { binding: 'barcodeTemp', header: '기존바코드번호', isReadOnly: true, width: 100, align:"center", visible: false }
 		    ];
 		  
 		   mngHistGrid = new wijmo.grid.FlexGrid('#mngHistGrid', {
 			    autoGenerateColumns: false,
 			    alternatingRowStep: 0,
 			    columns: mngHistColumns,
 			    itemsSource: mngHistView
 			  });
 			  
 		   mngHistGrid.itemFormatter = function (panel, r, c, cell) { 
 	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
 	                cell.textContent = (r + 1).toString();
 	            }
 	        }; 
 	        
 	        editGrid = new wijmo.grid.FlexGrid('#editGrid', {
 	            itemsSource: mngHistView.itemsEdited,
 	            isReadOnly: true
 	        });
 	    
 		   	_setUserGridLayout('mngHistLayout', mngHistGrid, mngHistColumns);
 		   	
 		 // 체크박스 생성
 	        mngHistSelector = new wijmo.grid.selector.Selector(mngHistGrid);
 	        mngHistSelector.column = mngHistGrid.columns[0];
 	        
 	  }else{
 		  mngHistView = new wijmo.collections.CollectionView(result, {
 		       pageSize: Number($('#mngHistGridPageCount').val()),
 		       trackChanges: true
 		   });
 		  mngHistGridPager.cv = mngHistView;
 		  mngHistGrid.itemsSource = mngHistView;
 	  }
 	  
 	  refreshPaging(mngHistGrid.collectionView.totalItemCount, 1, mngHistGrid, 'mngHistGrid');  // 페이징 초기 셋팅
 	  
 }
 
//건물 리스트 조회
 function getMngHistList(){
 	var param = {
 		con 	: $('#con').val()
 		, inq 	: $('#inq').val()
 		, fromDate : $('#fromDate').val()
		, toDate : $('#toDate').val()
		, sellYn : 'Y'
 	};
 	
 	$.ajax({
      type : 'POST',
      url : '/mng/getMngHistList',
      dataType : null,
      data : param,
      success : function(result) {
      	console.log("getMngHistList success");
      	loadGridList('search', result);
      },
      error: function(request, status, error) {
      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

      }
  }); 
 }

 function saveGrid(){
	    var editItem = mngHistView.itemsEdited;
	    var rows = [];
	    for(var i =0; i< editItem.length ; i++){
	        if(editItem[i].barcode == "" || editItem[i].barcode== null){
	            alert("바코드번호를 입력하세요.");
	            return false;
	            
	        }
	        rows.push(editItem[i]);
	    }
	    if(confirm("저장하시겠습니까?")){
	    // 기본정보 저장
	        $.ajax({
	            url : "/mng/saveMngHist",
	            async : false, // 비동기모드 : true, 동기식모드 : false
	            type : 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify(rows),
	            success : function(result) {
	                alert(result);
	                getMngHistList();
	            },
	            error : function(request,status,error) {
	                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	            }
	        });
	    }
	}
 
//행 삭제
 function deleteGrid(){
	 var item = mngHistGrid.rows.filter(r => r.isSelected); 
     var rows = [];
     var params;
      if(item.length == 0){
         alert("선택된 행이 없습니다.");
         return false;
     }else{
         for(var i =0; i< item.length ; i++){
             rows.push(item[i].dataItem);
         }
         
         console.log(rows);
         
         if(confirm("선택한 행들을 삭제 하시겠습니까??")){
             $.ajax({
                 url : "/mng/deleteMngHist",
                 async : false, // 비동기모드 : true, 동기식모드 : false
                 type : 'POST',
                 contentType: 'application/json',
                 data: JSON.stringify(rows),
                 success : function(result) {
                     alert("삭제되었습니다.");
                     getMngHistList();
                 },
                 error : function(request,status,error) {
                     alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                 }
             });
         }
     }
 }

 
 function exportExcel(){
	  	var gridView = mngHistGrid.collectionView;
	  	var oldPgSize = gridView.pageSize;
	  	var oldPgIndex = gridView.pageIndex;

	   	//전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
	  	mngHistGrid.beginUpdate();
	  	mngHistView.pageSize = 0;

	   	wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(mngHistGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'mngHistList.xlsx',
	  	      saved => {
	  	    	gridView.pageSize = oldPgSize;
	  	    	gridView.moveToPage(oldPgIndex);
	  	    	mngHistGrid.endUpdate();
	  	      }, null
	  	 );
	  }

 
 </script>
 
 

<body onload="pageLoad();">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">판매이력</h2>
                <div class="main_utility">
                    <form action="#" method="post">
                        <label for="Date">조회일</label>
                        <input type="date" id="fromDate"  onfocusout="_fnisDate(this.value, this.id); _searchDateVal(this.value, toDate.value);" onkeyup="enterkey();">
                        -
                        <input type="date" id="toDate" onfocusout="_fnisDate(this.value, this.id); _searchDateVal(fromDate.value, this.value);" onkeyup="enterkey();">
                    </form>
                    <div class="btn_wrap">
                        <button class="btn stroke" onClick="exportExcel();">엑셀다운로드</button>
                    </div>
                </div>
                 <!-- 필터 영역 main_filter-->
                 <div class="main_filter">
                    <form action="#" id="search_form" name="search_form" onsubmit="return false;">
                        <label for="con">검색조건</label>
                        <select name="con" id="con">
                            <option value="all" selected="selected">전체</option>
                            <option value="pdName">제품명</option>
                            <option value="codeNum">바코드번호</option>
                        </select>
                        <label for="inq" onkeyup="enterkey();">조회</label>
                        <input id="inq" type="text" placeholder=",로 다중검색 가능" onkeyup="enterkey();">
                        <button type="button" class="main_filter_btn" onClick="getMngHistList();"><i>조회</i></button>
                    </form>
                </div>
                <!-- 보드 영역 main_dashboard-->
                <div class="main_dashboard">
                    <div class="sub_cont">
                        <div class="btn_wrap">
                            <select id="mngHistGridPageCount" onchange="getMngHistList()">
                                <option value="100">100개씩</option>
                                <option value="50">50개씩</option>
                                <option value="30" selected="selected">30개씩</option>
                            </select>
                            <button type="button" class="btn stroke" onClick="_getUserGridLayout('mngHistLayout', mngHistGrid);">칼럼위치저장</button>
                            <button type="button" class="btn stroke" onClick="_resetUserGridLayout('mngHistLayout', mngHistGrid, mngHistColumns);">칼럼초기화</button>
                            <button type="button" class="btn" onClick="saveGrid();">저장</button>
                            <button type="button" class="btn" onClick="deleteGrid();">삭제</button>
                        </div>
                    </div>
                    <div class="grid_wrap" style="position:relative;">
                    	<div id="mngHistGrid" ></div>
                        <div id="mngHistGridPager" class="pager"></div>
                    </div>
                    <div class="sub_cont">
                        <div class="btn_wrap">
                            <button type="button" class="btn" onClick="saveGrid();">저장</button>
                            <button type="button" class="btn" onClick="deleteGrid();">삭제</button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
    
    <div class="grid_wrap" id="editDiv" style="display:none;">
        <div id="editGrid" ></div>
    </div>
</body>
</html>