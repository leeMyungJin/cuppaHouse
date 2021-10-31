<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

 <script type="text/javascript">
 
 var mngProductView;
 var mngProductGridPager;
 var mngProductGrid;
 var mngProductColumns;
 var mngProductSelector;
 
 var editGrid;
 var editGridView;
 
 var excelGrid;
 var excelView;
 var excelSelector;
 
 var itemNm;
 var itemCd;
 

 var memberId = "<%=session.getAttribute("id")%>";
 var memberAuth = "<%=session.getAttribute("auth")%>";
 
 function pageLoad(){
 	sessionCheck(memberId, memberAuth, 'mng_product');
 	
 	$('#mng_product').addClass("current");
 	$(".excelDiv").hide();
    $(".mngDiv").show();
 	
 	loadGridList('init');
 	getTotalMngProductCnt();
 }
 

 function enterkey() {
	    if (window.event.keyCode == 13) {
	    	itemCd = $('#con').val();
	    	
	    	//바코드 등록을 선택하여 엔터 칠 경우
	    	//해당 큐알에 부합하는 제품이 있는지 확인하여 제품명, 재고수 표출 
	    	//제품이 있을경우 리스트 조회
	    	//그리드 입력 활성화
	    	if($("input[name='mng']:checked").val() == 'barcode'){
	    		if(itemCd == null || itemCd == ""){
		    		alert("QR코드를 입력하시기 바랍니다.");
		    		clearData();
		    		return false;
		    	}
	    		
	    		getQrInfo();
	    		
	    	//판매일 경우 
	    	//해당 바코드 정보조회하여 라인추가
	    	}else{
	    		if(itemCd == null || itemCd == ""){
		    		alert("바코드를 입력하시기 바랍니다.");
		    		return false;
		    	}
	    		
	    		getBarcodeInfo();
	    	}
	    }
	}

 
//그리드 초기 셋팅
 function loadGridList(type, result){
 	  if(type == "init"){
 		   mngProductView = new wijmo.collections.CollectionView(result, {
 		       pageSize: 100
 		   });
 		    
 		   mngProductGridPager = new wijmo.input.CollectionViewNavigator('#mngProductGridPager', {
 		        byPage: true,
 		        headerFormat: '{currentPage:n0} / {pageCount:n0}',
 		        cv: mngProductView
 		    });
 		   
 		   mngProductColumns = [
 			  { isReadOnly: true, width: 35, align:"center"},
 			 { binding: 'itemCd', header: '제품코드', isReadOnly: true, width: 200, align:"center", visible: false },
 		      { binding: 'itemNm', header: '제품명', isReadOnly: true, width: 200, align:"center" },
 		      { binding: 'cretDt', header: '등록일자', isReadOnly: true, width: 100, align:"center"  },
 		      { binding: 'sellDt', header: '판매일자', isReadOnly: true, width: 100, align:"center"  },
 		      { binding: 'prodCd', header: '제품코드', isReadOnly: false, width: 100, align:"center"},
 		      { binding: 'partCd', header: '파트코드', isReadOnly: false, width: 100, align:"center" },
 		      { binding: 'colorCd', header: '색상코드', isReadOnly: false, width: 100, align:"center"},
 		      { binding: 'prodSeq', header: '생산순번', isReadOnly: false, width: 100, align:"center"  },
 		      { binding: 'barcode', header: '바코드번호', isReadOnly: true, width: 150, align:"center"  },
 		      { binding: 'barcodeTemp', header: '기존바코드번호', isReadOnly: true, width: 100, align:"center", visible: false },
 		     { binding: 'selectYn', header: '조회여부', isReadOnly: true, width: 100, align:"center", visible: false }
 		    ];
 		  
 		   mngProductGrid = new wijmo.grid.FlexGrid('#mngProductGrid', {
 			    autoGenerateColumns: false,
 			    alternatingRowStep: 0,
 			    columns: mngProductColumns,
 			    itemsSource: mngProductView,
 			    beginningEdit: function (s, e) {
	                var col = s.columns[e.col];
	                var item = s.rows[e.row].dataItem;
	                
	                //바코드 등록 - 신규행은 입력가능, 기저장 된 라인은 수정불가능
	                if($("input[name='mng']:checked").val() == 'barcode'){
		 			  if(item.selectYn == 'Y' 
		 				  && (col.binding == 'prodCd' || col.binding == 'partCd' || col.binding == 'colorCd' || col.binding == 'prodSeq' ) ){
		              	  e.cancel = true;
		                  alert("신규 행일때만 입력이 가능합니다.");
		              }
		 			  
		 			//판매 - 입력불가 
 		   			}else{
 		   				e.cancel = true;
	                  	alert("바코드등록시에만 입력이 가능합니다.");
 		   			}
	            },
	            cellEditEnding: (s, e) => {
	                let col = s.columns[e.col];
	                let value = s.activeEditor.value;
	                if(col.binding == 'prodCd' ){
	                	s.setCellData(e.row, 'itemNm', itemNm);
	                	s.setCellData(e.row, 'itemCd', itemCd);
	                	s.setCellData(e.row, 'cretDt', _getFormatDate(new Date()));
	                }
	                
	                if(col.binding == 'prodSeq' ){
	                	//숫자여부 확인
	                	var formatValue = wijmo.changeType(s.activeEditor.value, wijmo.DataType.Number, col.format);
	                    if( !wijmo.isNumber(formatValue)){
	                        e.cancel = true;
	                        e.stayInEditMode = false;
	                        alert('숫자로만 입력 가능합니다.');
	                        return false;
	                    }
	                }
	            }
 			  });
 			  
 		   mngProductGrid.itemFormatter = function (panel, r, c, cell) { 
 	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
 	                cell.textContent = (r + 1).toString();
 	            }
 	        }; 
 	        
 	        editGrid = new wijmo.grid.FlexGrid('#editGrid', {
 	            itemsSource: mngProductView.itemsEdited,
 	            isReadOnly: true
 	        });
 	    
 		   	_setUserGridLayout('mngProductLayout', mngProductGrid, mngProductColumns);
 		   	
 		 // 체크박스 생성
 	        mngProductSelector = new wijmo.grid.selector.Selector(mngProductGrid);
 	        mngProductSelector.column = mngProductGrid.columns[0];
 	        
			///////////////////// 엑셀업로드 그리드
 	        excelGrid = new wijmo.grid.FlexGrid('#excelGrid', {
 	            autoGenerateColumns: false,
 	            alternatingRowStep: 0,
 	            columns : mngProductColumns,
 	            itemsSource: excelView
 	        });

 	        excelGrid.itemFormatter = function (panel, r, c, cell) { 
 	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
 	                cell.textContent = (r + 1).toString();
 	            }
 	        };
 	        
 	        
 	  }else{
 		  mngProductView = new wijmo.collections.CollectionView(result, {
 		       pageSize: Number($('#mngProductGridPageCount').val()),
 		       trackChanges: true
 		   });
 		  mngProductGridPager.cv = mngProductView;
 		  mngProductGrid.itemsSource = mngProductView;
 	  }
 	  
 	  refreshPaging(mngProductGrid.collectionView.totalItemCount, 1, mngProductGrid, 'mngProductGrid');  // 페이징 초기 셋팅
 	  
 }
 
 function getTotalMngProductCnt(){
		$.ajax({
		      type : 'POST',
		      url : '/mng/getTotalMngProductCnt',
		      async : false, // 비동기모드 : true, 동기식모드 : false
		      dataType : null,
		      success : function(result) {
		      	$("#totalItemCnt").text(Number(result.totalitemcnt).toLocaleString('ko-KR')+ "개");
		        $("#nonBarcodeCnt").text(Number(result.nonbarcodecnt).toLocaleString('ko-KR')+ "개");
		      },
		      error: function(request, status, error) {
		      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		      }
		  });
	}

 
//리스트 조회
 function getMngProductList(){
	 $(".excelDiv").hide();
	 $(".mngDiv").show();
	
 	var param = {
 		con 	: 'pdCd'
 		, inq 	: $('#con').val()
 	};
 	
 	$.ajax({
      type : 'POST',
      url : '/mng/getMngHistList',
      dataType : null,
      data : param,
      success : function(result) {
      	console.log("getMngHistList success");
      	loadGridList('search', result);
      	if($("input[name='mng']:checked").val() == 'barcode'){
      		//$("#barcodeCnt").val(result.length+'개');
      	}else{
      		$("#barcodeCnt").val('개');
      	}
      },
      error: function(request, status, error) {
      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

      }
  }); 
 }
 
//바코드등록 - 큐알조회 
 function getQrInfo(){
	 $(".excelDiv").hide();
	 $(".mngDiv").show();
	
 	var param = {
 		con 	: $('#con').val()
 	};
 	
 	$.ajax({
      type : 'POST',
      url : '/mng/getQrInfo',
      dataType : null,
      data : param,
      success : function(result) {
      	console.log("getQrInfo success");
      	console.log(result);
      	
      	if(result == ""){
      		alert("존재하지않는 QR코드입니다.");
      		loadGridList('clear');
      		itemNm = '';
      		itemCd = '';
      		$("#barcodeCnt").val('개');
      		mngProductGrid.allowAddNew = false;
      		
      	}else{
      		getMngProductList();
      		itemNm = result.item_nm;
      		itemCd = result.item_cd;
	        $("#barcodeCnt").val(Number(result.barcode_cnt).toLocaleString('ko-KR')+'개');
	        mngProductGrid.allowAddNew = true;
      	}
      },
      error: function(request, status, error) {
      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

      }
  }); 
 }


//판매 - 바코드정보 조회
 function getBarcodeInfo(){
 	var param = {
 		con 	: $('#con').val()
 	};
 	
 	$.ajax({
      type : 'POST',
      url : '/mng/getBarcodeInfo',
      dataType : null,
      data : param,
      success : function(result) {
    	console.log(result);
    	
      	if(result.length == 0){
      		alert("존재하지않는 바코드번호입니다.");
      		
      	}else if(result.sellYn == "Y"){
      		alert("기 판매된 바코드번호입니다.");
      		
      	}else{
      		//그리드 추가 내역에 현재 추가하려는 내역이 있는지 확인
            let existionItem = mngProductGrid.collectionView.itemsAdded.filter(
            		addItem => addItem.barcode == result.barcode
           	);
      		
            if( existionItem.length > 0){
            	alert("기 추가 된 바코드입니다.");
            	return false;
            }
      		
      		//하단 그리드 라인추가
    	    mngProductGrid.collectionView.addNew();
    	    //하단 그리드 추가 된 라인 추출 및 데이터 적재
    		let cur = mngProductGrid.collectionView.currentItem;
    	
    		cur.itemCd = result.itemCd;
    		cur.itemNm = result.itemNm;
    		cur.cretDt = result.cretDt;
    	    cur.sellDt = result.sellDt;
    	    cur.prodCd = result.prodCd;
    	    cur.partCd = result.partCd;
    	    cur.colorCd = result.colorCd;
    	    cur.prodSeq = result.prodSeq;
    	    cur.barcode = result.barcode;
    	    cur.barcodeTemp = result.barcode;
    	    cur.selectYn = 'N';
    	    
    	    mngProductGrid.collectionView.commitEdit();
    	    mngProductGrid.collectionView.commitNew();
      	}
      },
      error: function(request, status, error) {
      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

      }
  }); 
 }


function saveGrid(type){
	if(type == 'excel'){
		 var item  = excelGrid.rows;
         var rows = [];
         var params;
         for(var i=0; i< item.length; i++){
        	 console.log(excelGrid.collectionView.items[i]);
        	 
             var value = wijmo.changeType(excelGrid.collectionView.items[i].생산순번, wijmo.DataType.Number, null);
             if(!wijmo.isNumber(value)){
                 alert("생산순번은 숫자만 입력 가능합니다.");
                 return false;
             }
             value = excelGrid.collectionView.items[i].qr코드;
             if(value == null && value == ''){
                 alert("QR코드는 필수입력사항입니다.");
                 return false;
             }
             value = excelGrid.collectionView.items[i].제품코드;
             if(value == null && value == ''){
                 alert("제품코드는 필수입력사항입니다.");
                 return false;
             }
             value = excelGrid.collectionView.items[i].파트코드;
             if(value == null && value == ''){
                 alert("파트코드는 필수입력사항입니다.");
                 return false;
             }
             value = excelGrid.collectionView.items[i].색상코드;
             if(value == null && value == ''){
                 alert("색상코드는 필수입력사항입니다.");
                 return false;
             }
             value = excelGrid.collectionView.items[i].생산순번;
             if(value == null && value == ''){
                 alert("생산순번은 필수입력사항입니다.");
                 return false;
             }
             
             params={
            	itemCd : excelGrid.collectionView.items[i].qr코드,
            	prodSeq : excelGrid.collectionView.items[i].생산순번,
            	prodCd : excelGrid.collectionView.items[i].제품코드,
            	partCd : excelGrid.collectionView.items[i].파트코드,
            	colorCd: excelGrid.collectionView.items[i].색상코드
             }
             rows.push(params);
             
         }
         
         console.log(rows);
         
         if(confirm("저장 하시겠습니까??")){
             $.ajax({
                 url : "/mng/saveMngExcelProduct",
                 async : false, // 비동기모드 : true, 동기식모드 : false
                 type : 'POST',
                 contentType: 'application/json',
                 data: JSON.stringify(rows),
                 success : function(result) {
                     alert(result);
                     //getMngProductList();
                     clearData();
                 },
                 error : function(request,status,error) {
                     alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                 }
             });
         }
	}else{
		//바코드 등록 - insert
	     if($("input[name='mng']:checked").val() == 'barcode'){
	    	var editItem = mngProductView.itemsAdded;
	 	    var rows = [];
	 	    for(var i =0; i< editItem.length ; i++){
	 	        if(editItem[i].prodCd == "" || editItem[i].prodCd== null){
	 	            alert("제품코드를 입력하세요.");
	 	            return false;
	 	            
	 	        }else if(editItem[i].partCd == "" || editItem[i].partCd== null){
	 	            alert("파트코드를 입력하세요.");
	 	            return false;
	 	            
	 	        }else if(editItem[i].colorCd == "" || editItem[i].colorCd== null){
	 	            alert("색상코드를 입력하세요.");
	 	            return false;
	 	            
	 	        }else if(editItem[i].prodSeq == "" || editItem[i].prodSeq== null){
	 	            alert("생산순번을 입력하세요.");
	 	            return false;
	 	            
	 	        }
	 	        rows.push(editItem[i]);
	 	    }
	 	    
	 	    if(confirm("저장하시겠습니까?")){
	 	    // 기본정보 저장
	 	        $.ajax({
	 	            url : "/mng/saveMngProduct",
	 	            async : false, // 비동기모드 : true, 동기식모드 : false
	 	            type : 'POST',
	 	            contentType: 'application/json',
	 	            data: JSON.stringify(rows),
	 	            success : function(result) {
	 	                alert(result);
	 	                getMngProductList();
	 	            },
	 	            error : function(request,status,error) {
	 	                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	 	            }
	 	        });
	 	    }
	    	 
	    	 
		 //판매 - 판매여부, 판매일자 update
		 }else{
			var editItem = mngProductView.itemsAdded;
	 	    var rows = [];
	 	    for(var i =0; i< editItem.length ; i++){
	 	        rows.push(editItem[i]);
	 	    }
	 	    
	 	    if(confirm("저장하시겠습니까?")){
	 	    // 기본정보 저장
	 	        $.ajax({
	 	            url : "/mng/sellMngProduct",
	 	            async : false, // 비동기모드 : true, 동기식모드 : false
	 	            type : 'POST',
	 	            contentType: 'application/json',
	 	            data: JSON.stringify(rows),
	 	            success : function(result) {
	 	                alert("저장되었습니다.");
	 	                getMngProductList();
	 	            },
	 	            error : function(request,status,error) {
	 	                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	 	            }
	 	        });
	 	    }
			 
		 }
	}
}
 
//행 삭제
 function deleteGrid(){
	//바코드 등록 - insert
     if($("input[name='mng']:checked").val() == 'barcode'){
    	 var item = mngProductGrid.rows.filter(r => r.isSelected); 
         var rows = [];
         var params;
          if(item.length == 0){
             alert("선택된 행이 없습니다.");
             return false;
         }else{
             for(var i=0; i< item.length ; i++){
            	 if(item[i].dataItem.sellDt != undefined){
      	            alert("판매되지 않은 바코드만 삭제 가능합니다.");
      	            return false;
      	            
      	        }
                 rows.push(item[i].dataItem);
             }
             
             console.log(rows);
             
             if(confirm("선택한 행들을 삭제 하시겠습니까??")){
                 $.ajax({
                     url : "/mng/deleteMngProduct",
                     async : false, // 비동기모드 : true, 동기식모드 : false
                     type : 'POST',
                     contentType: 'application/json',
                     data: JSON.stringify(rows),
                     success : function(result) {
                         alert("삭제되었습니다.");
                         getMngProductList();
                     },
                     error : function(request,status,error) {
                         alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                     }
                 });
             }
         }
    	 
     }else{
    	 var item = mngProductGrid.rows.filter(r => r.isSelected); 
         var rows = [];
         var params;
          if(item.length == 0){
             alert("선택된 행이 없습니다.");
             return false;
         }else{
             for(var i=0; i< item.length ; i++){
            	 mngProductView.remove(item[i].dataItem);
             }
         }
     }
 }

 function exportExcel(){
	  	var gridView = mngProductGrid.collectionView;
	  	var oldPgSize = gridView.pageSize;
	  	var oldPgIndex = gridView.pageIndex;

	   	//전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
	  	mngProductGrid.beginUpdate();
	  	mngProductView.pageSize = 0;

	   	wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(mngProductGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'mngProductList.xlsx',
	  	      saved => {
	  	    	gridView.pageSize = oldPgSize;
	  	    	gridView.moveToPage(oldPgIndex);
	  	    	mngProductGrid.endUpdate();
	  	      }, null
	  	 );
	  }
 
 
 function clearData(){
	 loadGridList('clear');
	 $(".excelDiv").hide();
	 $(".mngDiv").show();
	 
	 $("#barcodeCnt").val('개');
	 $("#con").val('');
	 mngProductGrid.allowAddNew = false;
	 
	 if($("input[name='mng']:checked").val() == 'barcode'){
		 $('#excel_btn').css("display","block"); 
	 }else{
		 $('#excel_btn').css("display","none");
	 }
 }

//이벤트 처리 
 $(function(){
     $("#partImportFile").on('change', function (params) {
         importExcel('part');
     });
     
     $("#importFile").on('change', function (params) {
         importExcel();
     });
  
 });


 //업로드 파일 찾기
 function findFile(){
	 $("#importFile").val("");
	 document.all.importFile.click();	
 }

 //엑셀 업로드
 function importExcel(){
	$(".excelDiv").show();
	$(".mngDiv").hide();

     var inputEle =  document.querySelector('#importFile');
     if (inputEle.files[0]) {
        wijmo.grid.xlsx.FlexGridXlsxConverter.loadAsync(excelGrid, inputEle.files[0],{includeColumnHeaders: true}, (w) => {
        // 데이터 바인딩할 함수 호출
        bindImportedDataIntoModel(excelGrid);
        excelGrid.columns.forEach(col => {
          col.width = 180,
          col.align = "center",
          col.dataType = 1
        })
      });
    }
 }

 function downTemplate(){
	 window.location.assign("<%=request.getContextPath()%>" + "/template/바코드등록양식.xlsx");
 }
 
 </script>

<body onload="pageLoad();">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">제품관리</li>
                </h2>
                <div class="main_summary half">
                    <dl>
                        <dt>총 제품 수</dt>
                        <dd id="totalItemCnt">0개</dd>
                    </dl>
                    <dl>
                        <dt>바코드미등록</dt>
                        <dd id="nonBarcodeCnt">0개</dd>
                    </dl>
                </div>
                <div class="main_utility">
                    <div class="btn_wrap" id="excel_btn">
                        <input type="file" class="form-control" style="display:none" id="importFile" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel.sheet.macroEnabled.12" />
                        <button class="btn stroke" id="excelTemplate" name = "excelTemplate" onclick="downTemplate();">엑셀템플릿</button>
                        <button class="btn stroke" id="importExcel" name = "importExcel" onclick="findFile();">엑셀업로드</button>
                    </div>
                </div>
                <div class="main_content">
                    <!-- 필터 영역 main_filter-->
                    <div class="main_filter">
                        <form action="#" id="search_form" name="search_form" onsubmit="return false;">
                            <label for="con">QR / 바코드</label>
                            <input name="con" id="con" type="text" class="wide" onkeyup="enterkey();">
                        </form>
                        <div class="fr">
                            <input type="radio" id="barcode" name="mng" checked value="barcode" onClick="clearData();">
                            <label for="barcode">바코드등록</label>
                            <input type="radio" id="sales" name="mng" value="sales" onClick="clearData();">
                            <label for="sales">판매</label>
                        </div>
                    </div>
                    <!-- 보드 영역 main_dashboard-->
                    <div class="main_dashboard">
                        <div class="sub_cont mngDiv">
                            <label for="stockNum">재고수량</label>
                            <input type="text" id="barcodeCnt" class="nar" value="개" readonly>
                            <div class="btn_wrap">
                                <select id="mngProductGridPageCount" onchange="getMngProductList()">
                                <option value="100">100개씩</option>
                                <option value="50">50개씩</option>
                                <option value="30" selected="selected">30개씩</option>
                            </select>
                               	<button type="button" class="btn stroke" onClick="_getUserGridLayout('mngProductLayout', mngProductGrid);">칼럼위치저장</button>
                            	<button type="button" class="btn stroke" onClick="_resetUserGridLayout('mngProductLayout', mngProductGrid, mngProductColumns);">칼럼초기화</button>
                            	<button type="button" class="btn" onClick="saveGrid();">저장</button>
                            	<button type="button" class="btn" onClick="deleteGrid();">삭제</button>
                            </div>
                        </div>
                        <div class="sub_cont excelDiv">
                            <div class="btn_wrap">
                                <button type="button" class="btn" onClick="saveGrid('excel');">저장</button>
                            </div>
                        </div>
                        <div class="grid_wrap mngDiv">
                        	<div id="mngProductGrid" ></div>
                        	<div id="mngProductGridPager" class="pager"></div>
                        </div>
                        <div class="grid_wrap excelDiv" style="position:relative;">
                        	<div id="excelGrid"></div>
                        </div>
                        <div class="sub_cont mngDiv">
                            <div class="btn_wrap">
                                <button type="button" class="btn" onClick="saveGrid();">저장</button>
                            	<button type="button" class="btn" onClick="deleteGrid();">삭제</button>
                            </div>
                        </div>
                        <div class="sub_cont excelDiv">
                            <div class="btn_wrap">
                                <button type="button" class="btn" onClick="saveGrid('excel');">저장</button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
    
<div class="grid_wrap" id="editDiv" style="display:none;">
    <div id="editGrid"></div>
</div>
</body>
</html>