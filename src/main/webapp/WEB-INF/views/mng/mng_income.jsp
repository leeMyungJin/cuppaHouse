<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

<script type="text/javascript">

var mngIncomeView;
var mngIncomeGridPager;
var mngIncomeGrid;
var mngIncomeColumns;
var mngIncomeSelector;

var editGrid;
var editGridView;

var excelGrid;
var excelView;
var excelSelector;

var memberId = "<%=session.getAttribute("id")%>";
var memberAuth = "<%=session.getAttribute("auth")%>";

function pageLoad(){
	sessionCheck(memberId, memberAuth, 'mng_income');
	
	$('#mng_income').addClass("current");
	
	var fromDate = new Date()
	fromDate.setDate(fromDate.getDate() - 7);
	var fromday = _getFormatDate(fromDate);
	var today = _getFormatDate(new Date());
	$('#fromDate').val(fromday);
	$('#toDate').val(today);
	$('#fromDate').attr('max',today);
	$('#toDate').attr('max',today);
	
	$(".excelDiv").hide();
    $(".mngDiv").show();
	
	loadGridList('init');
	getTotalMngIncomeCnt();
}

function enterkey(type) {
    if (window.event.keyCode == 13) {
    	getMngIncomeList();
    }
}

//그리드 초기 셋팅
function loadGridList(type, result){
	  if(type == "init"){
		   mngIncomeView = new wijmo.collections.CollectionView(result, {
		       pageSize: 100
		       ,trackChanges: true
		   });
		    
		   mngIncomeGridPager = new wijmo.input.CollectionViewNavigator('#mngIncomeGridPager', {
		        byPage: true,
		        headerFormat: '{currentPage:n0} / {pageCount:n0}',
		        cv: mngIncomeView
		    });
		   
		   mngIncomeColumns = [
			   { isReadOnly: true, width: 35, align:"center"},
			  { binding: 'incomeSeq', header: 'seq', isReadOnly: true, width: 100, align:"center", visible: false   },
			  { binding: 'sellDt', header: '판매일시', format: 'yyyy-MM-dd H:mm:ss', isReadOnly: false, width: 250, align:"center" },
		      { binding: 'itemNm', header: '물품명', isReadOnly: false, width: 200, align:"center"  },
		      { binding: 'sellAmt', header: '판매가', isReadOnly: false, width: 100, align:"center"   },
		      { binding: 'sellCnt', header: '수량', isReadOnly: false, width: 50, align:"center" },
		      { binding: 'cost', header: '금액', isReadOnly: false, width: 100, align:"center" },
		      { binding: 'custNm', header: '고객명', isReadOnly: false, width: 100, align:"center"},
		      { binding: 'path', header: '발생경로', isReadOnly: false, width: 200, align:"center"},
		      { binding: 'memo', header: '비고', isReadOnly: false, width: 200, align:"center"},
		      { binding: 'cretDt', header: '등록일', isReadOnly: true, width: 100, align:"center" , visible: false },
		      { binding: 'cretId', header: '등록자', isReadOnly: true, width: 100, align:"center" , visible: false},
		      { binding: 'updtDt', header: '수정일', isReadOnly: false, width: 150, align:"center" , visible: false },
		      { binding: 'updtId', header: '수정자', isReadOnly: true, width: 80, align:"center" , visible: false }
		    ];
		   
		   var sellDtEditor = new wijmo.input.InputDateTime(document.createElement("div"));
		   mngIncomeGrid = new wijmo.grid.FlexGrid('#mngIncomeGrid', {
			    autoGenerateColumns: false,
			    alternatingRowStep: 0,
			    columns: mngIncomeColumns,
			    itemsSource: mngIncomeView,
			    beginningEdit: function (s, e) {
			    	s.columns.getColumn("sellDt").editor = sellDtEditor;
	            },
	            cellEditEnding: (s, e) => {
	                let col = s.columns[e.col];
	                let value = s.activeEditor.value;
	                if(col.binding == 'sellAmt' || col.binding == 'cost' || col.binding == 'sellCnt' ){
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
			  
		   mngIncomeGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        }; 
	        
	     // 체크박스 생성
 	        mngIncomeSelector = new wijmo.grid.selector.Selector(mngIncomeGrid);
 	        mngIncomeSelector.column = mngIncomeGrid.columns[0];
	    
		   	_setUserGridLayout('mngIncomeLayout', mngIncomeGrid, mngIncomeColumns);
		   	
		   	editGrid = new wijmo.grid.FlexGrid('#editGrid', {
	            itemsSource: mngIncomeView.itemsEdited,
	            isReadOnly: true
	        });
		   	
		   	//엑셀업로드 그리드
		   	excelGrid = new wijmo.grid.FlexGrid('#excelGrid', {
	            autoGenerateColumns: false,
	            alternatingRowStep: 0,
	            columns : mngIncomeColumns,
	            itemsSource: excelView
	        });

	        excelGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        };
	        
	  }else{
		  mngIncomeView = new wijmo.collections.CollectionView(result, {
		       pageSize: Number($('#mngIncomeGridPageCount').val()),
		       trackChanges: true
		   });
		  mngIncomeGridPager.cv = mngIncomeView;
		  mngIncomeGrid.itemsSource = mngIncomeView;
	  }
	  
	  refreshPaging(mngIncomeGrid.collectionView.totalItemCount, 1, mngIncomeGrid, 'mngIncomeGrid');  // 페이징 초기 셋팅
	  
}

//리스트 조회
function getMngIncomeList(){
	$(".excelDiv").hide();
    $(".mngDiv").show();
	
	var param = {
			con 	: $('#con').val()
			, inq 	: $('#inq').val()
			, fromDate : $('#fromDate').val()
			, toDate : $('#toDate').val()
		};
	
	$.ajax({
     type : 'POST',
     url : '/mng/getMngIncomeList',
     dataType : null,
     data : param,
     success : function(result) {
     	console.log("getMngIncomeList success");
     	loadGridList('search', result);
     	getTotalMngIncomeCnt();
     	getLableMngIncomeCnt();
     },
     error: function(request, status, error) {
     	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

     }
 }); 
}


function getLableMngIncomeCnt(){
	var params = {
			con 	: $('#con').val()
			, inq 	: $('#inq').val()
			, fromDate : $('#fromDate').val()
			, toDate : $('#toDate').val()
		};
	
 	$.ajax({
 	      url : '/mng/getLableMngIncomeCnt',
 	     async : false, // 비동기모드 : true, 동기식모드 : false
         type : 'POST',
         cache : false,
         dataType : null,
         data : params,
 	      success : function(result) {
 	      	$("#lableCost").text(Number(result.lablecost).toLocaleString('ko-KR')+ "원");
 	        $("#lableCnt").text(Number(result.lablecnt).toLocaleString('ko-KR')+ "개");
 	      },
 	      error: function(request, status, error) {
 	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
 	      }
 	  });
 }

function getTotalMngIncomeCnt(){
 	$.ajax({
 	      type : 'POST',
 	      url : '/mng/getTotalMngIncomeCnt',
 	      async : false, // 비동기모드 : true, 동기식모드 : false
 	      dataType : null,
 	      success : function(result) {
 	    	 console.log(result);
 	      	$("#totalCost").text(Number(result.totalcost).toLocaleString('ko-KR')+ "원");
 	        $("#totalCnt").text(Number(result.totalcnt).toLocaleString('ko-KR')+ "개");
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
            var value = wijmo.changeType(excelGrid.collectionView.items[i].판매가, wijmo.DataType.Number, null);
            if(!wijmo.isNumber(value)){
                alert("판매가는 숫자만 입력 가능합니다.");
                return false;
            }
            value = wijmo.changeType(excelGrid.collectionView.items[i].수량, wijmo.DataType.Number, null);
            if(!wijmo.isNumber(value)){
                alert("수량은 숫자만 입력 가능합니다.");
                return false;
            }
            value = wijmo.changeType(excelGrid.collectionView.items[i].금액, wijmo.DataType.Number, null);
            if(!wijmo.isNumber(value)){
                alert("금액은 숫자만 입력 가능합니다.");
                return false;
            }
            var dateRegExp = /^(19|20)\d{2}\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[0-1]) (0[0-9]|1[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/; 
            value = wijmo.changeType(excelGrid.collectionView.items[i].판매일시, wijmo.DataType.String, null);
            if(!dateRegExp.test(value)){
                alert("판매일시는 YYYY/MM/DD HH:MM:SS 형태로 입력하시기 바랍니다.");
                return false;
            } 
            value = excelGrid.collectionView.items[i].물품명;
            if(value == null && value == ''){
                alert("물품명은 필수입력사항입니다.");
                return false;
            }
            value = excelGrid.collectionView.items[i].고객명;
            if(value == null && value == ''){
                alert("고객명은 필수입력사항입니다.");
                return false;
            }
            
            params={
            		sellDt :  excelGrid.collectionView.items[i].판매일시,
            		itemNm : excelGrid.collectionView.items[i].물품명,
            		sellAmt : excelGrid.collectionView.items[i].판매가,
            		sellCnt : excelGrid.collectionView.items[i].수량,
            		cost : excelGrid.collectionView.items[i].금액,
            		path : excelGrid.collectionView.items[i].발생경로,
            		custNm : excelGrid.collectionView.items[i].고객명,
            		memo : excelGrid.collectionView.items[i].비고
             }
             rows.push(params);
            
        }
        if(confirm("저장 하시겠습니까??")){
            $.ajax({
                url : "/mng/saveExcelMngIncome",
                async : false, // 비동기모드 : true, 동기식모드 : false
                type : 'POST',
                contentType: 'application/json',
                data: JSON.stringify(rows),
                success : function(result) {
                    alert(result);
                    getMngIncomeList();
                },
                error : function(request,status,error) {
                    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                }
            });
        }
        
    }else{
		var addItem  = mngIncomeView.itemsAdded;
	    var editItem = mngIncomeView.itemsEdited;
	    var addRows = [];
		var editRows = [];
		var rows = [];
		
		console.log("saveGrid");
		console.log(addItem);
		console.log(editItem);

	    for(var i=0; i< addItem.length; i++){
	    	addRows.push(addItem[i]);
	    	rows.push(addItem[i]);
	    }
		
		for(var i =0; i< editItem.length; i++){
	    	editRows.push(editItem[i]);
	    	rows.push(editItem[i]);
	    }
		
		console.log(rows);
	    
		wijmo.Control.getControl("#editGrid").refresh(true);
	    if(confirm("변경한 내용을 저장 하시겠습니까??")){
	    	$.ajax({
	            url : "/mng/saveMngIncome",
	            async : false, // 비동기모드 : true, 동기식모드 : false
	            type : 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify(addRows),
	            success : function(result) {
	               	console.log('saveMngIncome');
	               	console.log(addRows);
	               	updateMngIncomeGrid(editRows);
	            },
	            error : function(request,status,error) {
	                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	            }
	        });
	    }
	}
    
}

function updateMngIncomeGrid(editRows){
	$.ajax({
        url : "/mng/updateMngIncome",
        async : false, // 비동기모드 : true, 동기식모드 : false
        type : 'POST',
        contentType: 'application/json',
        data: JSON.stringify(editRows),
        success : function(result) {
        	console.log('updateMngIncome');
        	console.log(editRows);
            alert("저장되었습니다.");
            getMngIncomeList();
        },
        error : function(request,status,error) {
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
}

//행 삭제
function deleteGrid(){
	 var item = mngIncomeGrid.rows.filter(r => r.isSelected); 
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
                url : "/mng/deleteMngIncome",
                async : false, // 비동기모드 : true, 동기식모드 : false
                type : 'POST',
                contentType: 'application/json',
                data: JSON.stringify(rows),
                success : function(result) {
                    alert("삭제되었습니다.");
                    getMngIncomeList();
                },
                error : function(request,status,error) {
                    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                }
            });
        }
    }
}

function exportExcel(){
  	var gridView = mngIncomeGrid.collectionView;
  	var oldPgSize = gridView.pageSize;
  	var oldPgIndex = gridView.pageIndex;

   	//전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
  	mngIncomeGrid.beginUpdate();
  	mngIncomeView.pageSize = 0;

   	wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(mngIncomeGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'mngIncomeList.xlsx',
  	      saved => {
  	    	gridView.pageSize = oldPgSize;
  	    	gridView.moveToPage(oldPgIndex);
  	    	mngIncomeGrid.endUpdate();
  	      }, null
  	 );
  }


//이벤트 처리 
$(function(){
	 $("#importFile").on('change', function (params) {
        importExcel();
    });
 
});


//업로드 파일 찾기
function findFile(type){
	$("#importFile").val("");
    document.all.importFile.click();	
}

//엑셀 업로드
function importExcel(type){
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

function downTemplate(type){
	window.location.assign("<%=request.getContextPath()%>" + "/template/매출등록양식.xlsx");
}

//행추가
function addRow(){
	mngIncomeGrid.allowAddNew = true;
}
</script>

<body  onload="pageLoad()">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">매출관리</h2>
                <div class="main_summary half">
                    <dl>
                        <dt>금년매출액</dt>
                        <dd id="totalCost">0원</dd>                                         
                    </dl>
                    <dl>
                        <dt>금년판매제품수</dt>
                        <dd id="totalCnt">0개</dd>
                    </dl>
                </div>
                <div class="main_utility">
                    <form action="#" method="post">
                        <label for="Date">조회일</label>
                        <input type="date" id="fromDate"  onfocusout="_fnisDate(this.value, this.id); _searchDateVal(this.value, toDate.value);" onkeyup="enterkey();">
                        -
                        <input type="date" id="toDate" onfocusout="_fnisDate(this.value, this.id); _searchDateVal(fromDate.value, this.value);" onkeyup="enterkey();">
                    </form>
                    <div class="btn_wrap">
                        <input type="file" class="form-control" style="display:none" id="importFile" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel.sheet.macroEnabled.12" />
                        <button class="btn stroke" id="excelTemplate" name = "excelTemplate" onclick="downTemplate();">엑셀템플릿</button>
                        <button class="btn stroke" id="importExcel" name = "importExcel" onclick="findFile();">엑셀업로드</button>
                        <button class="btn stroke" id="exportExcel" name = "exportExcel" onclick="exportExcel();">엑셀다운로드</button>
                    </div>
                </div>
                 <!-- 필터 영역 main_filter-->
                 <div class="main_filter">
                    <form action="#">
                        <label for="con" id="search_form" name="search_form" onsubmit="return false;">검색조건</label>
                            <select name="con" id="con">
                            <option value="all" selected="selected">전체</option>
                            <option value="itemNm">물품명</option>
                            <option value="custNm">고객명</option>
                        </select>
                        <label for="inq">조회</label>
                            <input id="inq" type="text" placeholder=",로 다중검색 가능" onkeyup="enterkey();">
                            <button type="button" class="main_filter_btn" onClick="getMngIncomeList();"><i>조회</i></button>
                    </form>
                    <div class="summary">
                        <dl>
                            <dt>매출액</dt>
                            <dd id="lableCost">0원</dd>
                        </dl>
                        <dl>
                            <dt>판매제품수</dt>
                            <dd id="lableCnt">0개</dd>
                        </dl>
                    </div>
                </div>
                <!-- 보드 영역 main_dashboard-->
                <div class="main_dashboard">
                    <div class="sub_cont">
                        <button class="btn round mngDiv" onClick="addRow()"><span>+</span> 매출입력</button>
                        <div class="btn_wrap mngDiv">
                            <select id="mngIncomeGridPageCount" id="mngIncomeGridPageCount" onchange="getMngIncomeList">
                                <option value="100">100개씩</option>
                                <option value="50">50개씩</option>
                                <option value="30" selected="selected">30개씩</option>
                            </select>
                            <button type="button" class="btn stroke" onClick="_getUserGridLayout('mngIncomeLayout', mngIncomeGrid);">칼럼위치저장</button>
                            <button type="button" class="btn stroke" onClick="_resetUserGridLayout('mngIncomeLayout', mngIncomeGrid,mngIncomeColumns);">칼럼초기화</button>
                            <button type="button" class="btn" onclick="saveGrid()">저장</button>
                            <button type="button" class="btn" onclick="deleteGrid()">삭제</button>
                        </div>
                        <div class="btn_wrap excelDiv" style="position:relative;">
	                         <button type="button" class="btn" onclick="saveGrid('excel')">저장</button>
	                     </div>
                    </div>
                    <div class="grid_wrap mngDiv" style="position:relative;">
                    	<div id="mngIncomeGrid"></div>
                    	<div id="mngIncomeGridPager" class="pager"></div>
                    </div>
                    <div class="grid_wrap excelDiv" style="position:relative;">
                    	<div id="excelGrid"></div>
                    </div>
                    
                    <div class="sub_cont mngDiv">
                        <div class="btn_wrap" style="position:relative;">
                            <button type="button" class="btn" onclick="saveGrid()">저장</button>
                            <button type="button" class="btn" onclick="deleteGrid()">삭제</button>
                        </div>
                    </div>
                    <div class="sub_cont excelDiv" style="position:relative;">
                         <div class="btn_wrap">
                         <button type="button" class="btn" onclick="saveGrid('excel')">저장</button>
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