<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>


 <script type="text/javascript">
 var entryView;
 var entryGridPager;
 var entryGrid;
 var entryColumns;
 var entrySelector;
 
 var editGrid;
 var editGridView;
 
 var typeCdList;
 var lCategoryList;
 var mCategoryList;
 var itemList;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
 
 var memberId = "<%=session.getAttribute("id")%>";
 var memberAuth = "<%=session.getAttribute("auth")%>";
 

 function pageLoad(){
 	sessionCheck(memberId, memberAuth, 'entry');
 	
 	$('#stock_entry').addClass("current");
 	
 	loadGridList('init');
 	getTotalEntryCnt();
 	getBldgDtl();
 }

 function enterkey() {
     if (window.event.keyCode == 13) {
     	getEntryList();
     }
 }

//그리드 초기 셋팅
function loadGridList(type, result){
	  if(type == "init"){
		   entryView = new wijmo.collections.CollectionView(result, {
		       pageSize: 100
		       ,trackChanges: true
		   });
		    
		   entryGridPager = new wijmo.input.CollectionViewNavigator('#entryGridPager', {
		        byPage: true,
		        headerFormat: '{currentPage:n0} / {pageCount:n0}',
		        cv: entryView
		    });
		   
		   typeCdList = new wijmo.grid.DataMap(getTypeCdList(), 'id', 'name');
		   lCategoryList = new wijmo.grid.DataMap(getLCategoryDtl(), 'id', 'name');
		   mCategoryList = new wijmo.grid.DataMap(getMCategoryDtl(), 'id', 'name');
		   itemList = new wijmo.grid.DataMap(getItemDtl(), 'id', 'name');
		   
		   lCategoryList.getDisplayValues = function (dataItem) {
			    let validItem = getLCategoryDtl().filter(itemCd => itemCd.typeCd == dataItem.typeCd);
			    return validItem.map(itemCd => itemCd.name);
			};
			
			mCategoryList.getDisplayValues = function (dataItem) {
			    let validItem = getMCategoryDtl().filter(itemCd => itemCd.lCategyCd == dataItem.lCategyCd || itemCd.typeCd == dataItem.typeCd);
			    return validItem.map(itemCd => itemCd.name);
			};
			
			itemList.getDisplayValues = function (dataItem) {
			    let validItem = getItemDtl().filter(itemCd => itemCd.mCategyCd == dataItem.mCategyCd || itemCd.lCategyCd == dataItem.lCategyCd || itemCd.typeCd == dataItem.typeCd);
			    return validItem.map(itemCd => itemCd.name);
			};
			
		   entryColumns = [
			   { binding: 'bldgCd', header: '건물코드', isReadOnly: true, width: 100, align:"center", visible: false },
			   { binding: 'classifiCd', header: '입출분류', isReadOnly: true, width: 100, align:"center", visible: false },
			   { binding: 'typeCd', header: '분류', isReadOnly: false, width: 100, align:"center", dataMap: typeCdList, dataMapEditor: 'DropDownList' },
               { binding: 'lCategyCd', header: '대카테고리', isReadOnly: false, width: 120, align:"center", dataMap: lCategoryList, dataMapEditor: 'DropDownList'},
               { binding: 'mCategyCd', header: '중카테고리', isReadOnly: false, width: 120, align:"center", dataMap: mCategoryList, dataMapEditor: 'DropDownList'},
               { binding: 'itemCd', header:'품명', isReadOnly: false, width: 150, align:"center", dataMap: itemList, dataMapEditor: 'DropDownList'},
               { binding: 'itemCd', header: '코드', isReadOnly: true, width: 150, align:"center"},
               { binding: 'cost', header: '원가', isReadOnly: true, width: 100, align:"center"  },
               { binding: 'quantity', header: '재고수량', isReadOnly: true, width: 150, align:"center"},
               { binding: 'quantityCnt', header: '입출수량', isReadOnly: false, width: 80, align:"center"},
               { binding: 'partQuantity', header: '파트수량', isReadOnly: false, width: 80, align:"center"/*, visible: false*/ },
               { binding: 'updtDt', header: '수정일자', isReadOnly: false, width: 80, align:"center"}
		    ];
		  
		   entryGrid = new wijmo.grid.FlexGrid('#entryGrid', {
			    autoGenerateColumns: false,
			    alternatingRowStep: 0,
			    columns: entryColumns,
			    itemsSource: entryView,
			    beginningEdit: function (s, e) {
	                var col = s.columns[e.col];
	                var item = s.rows[e.row].dataItem;
	                if(item.updtDt != undefined){
	                    if (col.binding == 'typeCd' || col.binding == 'lCategyCd' || col.binding == 'mCategyCd' || col.binding == 'itemCd' ) {
	                        e.cancel = true;
	                        alert("신규 행일때만 입력이 가능합니다.");
	                    }
	                }
	            },
			    cellEditEnding: (s, e) => {
	                let col = s.columns[e.col];
	                let value = s.activeEditor.value;
	                if(col.binding == 'quantityCnt' ){
	                	var itemCd = s.getCellData(e.row, 'itemCd');
	                	if(itemCd == null || itemCd == ''){
	                		e.cancel = true;
	                        e.stayInEditMode = false;
	                        alert('입출수량은 품명 선택 후 입력 가능합니다.');
	                        return false;
	                	}
	                	
	                	//숫자여부 확인
	                	var formatValue = wijmo.changeType(s.activeEditor.value, wijmo.DataType.Number, col.format);
	                    if( !wijmo.isNumber(formatValue)){
	                        e.cancel = true;
	                        e.stayInEditMode = false;
	                        alert('숫자로만 입력 가능합니다.');
	                        return false;
	                    }
	                	
	                    //재고수량 계산
	                    var classifiCd = $("input[name='classifi_cd']:checked").val();
	                    var quantity = s.getCellData(e.row, 'quantity');
	                	if(classifiCd == "I" || classifiCd == "CI"){
	                		if(s.getCellData(e.row, e.col) != '' && s.getCellData(e.row, e.col) != null || s.getCellData(e.row, e.col) != 0 ){
	                			s.setCellData(e.row, 'quantity', Number(quantity) - s.getCellData(e.row, e.col) + Number(value));
	                			
	                		}else{
	                			s.setCellData(e.row, 'quantity', Number(quantity) + Number(value));
	                			
	                		}
	                		
	                    }else if(classifiCd == "O" || classifiCd == "CO"){
	                    	if(s.getCellData(e.row, e.col) != '' && s.getCellData(e.row, e.col) != null || s.getCellData(e.row, e.col) != 0){
	                    		s.setCellData(e.row, 'quantity', Number(quantity) + s.getCellData(e.row, e.col) - Number(value));
	                			
	                		}else{
	                			s.setCellData(e.row, 'quantity', Number(quantity) - Number(value));
	                			
	                		}
	                    }
	                	
	                //카테고리 변경시 이하 값 초기화
	                }else if(col.binding == 'typeCd'){
	                	e.getRow().dataItem.bldgCd = $('#bldgNm option:selected').val();
	                	e.getRow().dataItem.classifiCd = $("input[name='classifi_cd']:checked").val();
	                	e.getRow().dataItem.lCategyCd = '';
	                	e.getRow().dataItem.mCategyCd = '';
	                	e.getRow().dataItem.itemCd = '';
	                	e.getRow().dataItem.cost = 0;
	                	e.getRow().dataItem.quantity = 0;
	                	e.getRow().dataItem.quantityCnt = 0;
	                	
	                }else if(col.binding == 'lCategyCd'){
	                	e.getRow().dataItem.mCategyCd = '';
	                	e.getRow().dataItem.itemCd = '';
	                	e.getRow().dataItem.cost = 0;
	                	e.getRow().dataItem.quantity = 0;
	                	e.getRow().dataItem.quantityCnt = 0;
	                	
	                }else if(col.binding == 'mCategyCd'){
	                	e.getRow().dataItem.itemCd = '';
	                	e.getRow().dataItem.cost = 0;
	                	e.getRow().dataItem.quantity = 0;
	                	e.getRow().dataItem.quantityCnt = 0;
	                	
	                }if (col.binding == 'itemCd') {
		                var item = getItemDtl().filter(item => item.name == value);
		                if(item.length > 0){
		                	s.setCellData(e.row, 'cost', Number(item[0].cost));
			                s.setCellData(e.row, 'quantity', Number(item[0].quantity));
		                }
	               
	                }
	              }
			  });
			  
		   entryGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        }; 
	        
	        editGrid = new wijmo.grid.FlexGrid('#editGrid', {
	            itemsSource: entryView.itemsEdited,
	            isReadOnly: true
	        });
	    
		   	_setUserGridLayout('entryLayout', entryGrid, entryColumns);
		   	
		 // 체크박스 생성
	        entrySelector = new wijmo.grid.selector.Selector(entryGrid);
	        entrySelector.column = entryGrid.columns[0];
	        
	  }else{
		  entryView = new wijmo.collections.CollectionView(result, {
		       pageSize: Number($('#entryGridPageCount').val()),
		       trackChanges: true
		   });
		  entryGridPager.cv = entryView;
		  entryGrid.itemsSource = entryView;
	  }
	  
	  refreshPaging(entryGrid.collectionView.totalItemCount, 1, entryGrid, 'entryGrid');  // 페이징 초기 셋팅
	  
}

function getTotalEntryCnt(){
	$.ajax({
	      type : 'POST',
	      url : '/stock/getTotalEntryCnt',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      success : function(result) {
	      	$("#totalStockBldg").text(Number(result.totalstockbldg).toLocaleString('ko-KR')+ "개");
	        $("#totalStockItem").text(Number(result.totalstockitem).toLocaleString('ko-KR')+ "개");
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      }
	  });
}


//재고입력 리스트 조회
function getEntryList(){
	console.log($("input[name='classifi_cd']:checked").val());
	
	var param = {
		classifiCd : $("input[name='classifi_cd']:checked").val(),
		bldgCd : $('#bldgNm option:selected').val()
	};
	
	$.ajax({
     type : 'POST',
     url : '/stock/getEntryList',
     dataType : null,
     data : param,
     success : function(result) {
     	loadGridList('search', result);
     	getTotalEntryCnt();	
     },
     error: function(request, status, error) {
     	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

     }
 }); 
}



//행추가
function addRow(){
	console.log($('#bldgNm option:selected').val());
	if($('#bldgNm option:selected').val() == 'all'){
		alert("건물명 선택 후 등록 가능합니다.");
		return false;
	}
	entryGrid.allowAddNew = true;
}

function saveGrid(){
    var editItem = entryView.itemsEdited;
    var addItem  = entryView.itemsAdded;
	var rows = [];
	
	console.log("saveGrid");
	console.log(addItem);
	console.log(editItem);

	for(var i=0; i< addItem.length; i++){
		if(!saveVal(addItem[i])) return false;
		if(addItem[i].quantityCnt > 0){
			rows.push(addItem[i]);
		}
	}
		
	for(var i =0; i< editItem.length; i++){
		if(!saveVal(editItem[i])) return false;
		if(editItem[i].quantityCnt > 0){
			rows.push(editItem[i]);
		}
	}
  
	wijmo.Control.getControl("#editGrid").refresh(true);
  if(confirm("변경한 내용을 저장 하시겠습니까??")){
  	$.ajax({
          url : "/stock/saveEntry",
          async : false, // 비동기모드 : true, 동기식모드 : false
          type : 'POST',
          contentType: 'application/json',
          data: JSON.stringify(rows),
          success : function(result) {
        	  alert("저장되었습니다.");
              getEntryList();
          },
          error : function(request,status,error) {
              alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
          }
      });
  }
}

function saveVal(item){
    if(item.typeCd == null || item.typeCd == ''){
		alert("분류를 선택해주세요.");
		return false;
	
	}else if(item.lCategyCd == null || item.lCategyCd == ''){
		alert("대카테고리를 선택해주세요.");
		return false;
		
	}else if(item.mCategyCd == null || item.mCategyCd == ''){
		alert("중카테고리를 선택해주세요.");
		return false;
		
	}else if(item.itemCd == null || item.itemCd == ''){
		alert("품명을 선택해주세요.");
		return false;
		
	}else if(item.itemCd == null || item.itemCd == ''){
		alert("품명을 선택해주세요.");
		return false;
		
	}else if(item.quantityCnt == 0){
		alert("입출수량을 입력해주세요.");
		return false;
		
	}
	
	return true;
}


//분류 동적으로 가져오기
function getTypeCdList() {
	var returnVal;
	var param = {
			cd 	: 'stockType'
		};
	
    $.ajax({
            url : "/code/getCodeList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            data : param,
            success : function(result) {
            	
            	var typeCdList = [];
                if(result.length > 0){
                	
                	for(var i =0; i<result.length; i++){
                		typeCdList[i] = { id: result[i].cd, name: result[i].nm };	
                	}
                	
                }else{
                	typeCdList[0] = { id: null, name: null };	
                }
                returnVal = typeCdList;
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
    });
    
    return returnVal;
}

//카테고리 동적으로 가져오기
function getLCategoryDtl() {
	var returnVal;
	
	/* var params = {
			typeCd : $("#typeCd_pop").val()
    	} */
    $.ajax({
            url : "/stock/getLCategoryList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
          //  data : params,
            success : function(result) {
            	var gategory = [];
            	
                if(result.length > 0){
                	
                	for(var i =0; i<result.length; i++){
                		gategory[i] = { id: result[i].lCategyCd, name: result[i].lCategyNm, typeCd: result[i].typeCd };	
                	}
                	
                }else{
                	gategory[0] = { id: null, name: null, typeCd: null };	
                }
                returnVal = gategory;
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
    });
	
    return returnVal;
}

//카테고리 동적으로 가져오기
function getMCategoryDtl() {
	var returnVal;
	/* var params = {
			typeCd : $("#typeCd_pop").val(),
			lCategyCd : $("#lCategyCd").val()
    	}
	 */
    $.ajax({
            url : "/stock/getMCategoryList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
           // data : params,
            success : function(result) {
            	
            	var gategory = [];
                if(result.length > 0){
                	
                	for(var i =0; i<result.length; i++){
                		gategory[i] = { id: result[i].mCategyCd, name: result[i].mCategyNm, lCategyCd: result[i].lCategyCd };	
                	}
                	
                }else{
                	gategory[0] = { id: null, name: null, lCategyCd: null };	
                }
                returnVal = gategory;
            	
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
    });
	
    return returnVal;
}

//카테고리 동적으로 가져오기
function getItemDtl() {
	var returnVal;
 	var params = {
			typeCd : $("#typeCd").val(),
			lCategyCd : $("#lCategyCd").val(),
			mCategyCd : $("#mCategyCd").val()
    	}
	 
    $.ajax({
            url : "/stock/getItemList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
          //  data : params,
            success : function(result) {
            	var item = [];
                if(result.length > 0){
                	for(var i =0; i<result.length; i++){
                		item[i] = { id: result[i].itemCd, name: result[i].itemNm, mCategyCd: result[i].mCategyCd, cost: result[i].cost, quantity: result[i].quantity };	
                	}
                	
                }else{
                	item[0] = { id: null, name: null, mCategyCd: null, cost: null, quantity: null};	
                }
                returnVal = item;
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
    });
    
    return returnVal;
}


//건물 동적으로 가져오기
function getBldgDtl() {
  $.ajax({
          url : "/stock/getBldgList",
          async : false, // 비동기모드 : true, 동기식모드 : false
          type : 'POST',
        //  data : params,
          success : function(result) {
        	  
        	  if(result.length > 0){
              	$('#bldgNm').empty().append('<option selected="selected" value="all" selected>전체</option>');
                  for(var i =0; i<result.length; i++)
                      $("#bldgNm").append("<option value='" + result[i].bldgCd + "'>" + result[i].bldgNm + "</option>");
                  
              }else{
              	$('#bldgNm').empty().append('<option selected="selected" value="all" selected>전체</option>');
              	
              }
          },
          error : function(request,status,error) {
              alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
          }
  });
 
}



function exportExcel(){
	var gridView = entryGrid.collectionView;
	var oldPgSize = gridView.pageSize;
	var oldPgIndex = gridView.pageIndex;

    //전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
    entryGrid.beginUpdate();
    entryView.pageSize = 0;

    wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(entryGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'entryList.xlsx',
	      saved => {
	    	gridView.pageSize = oldPgSize;
	    	gridView.moveToPage(oldPgIndex);
	    	entryGrid.endUpdate();
	      }, null
	 );
}
 
 </script>
 
 

<body onload="pageLoad();">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">재고입력</h2>
                <div class="main_summary half">
                    <dl>
                        <dt>자재필요건물</dt>
                        <dd id="totalStockBldg">0개</dd>
                    </dl>
                    <dl>
                        <dt>필요자재품목</dt>
                        <dd id="totalStockItem">0개</dd>
                    </dl>
                </div>
                <div class="main_utility">
                    <label for="bldgNm">건물명</label>
                    <select name="bldgNm" id="bldgNm" style="width:150px;" onchange="getEntryList()">
                    </select>
                    <div class="btn_wrap">
                        <button class="btn stroke" onClick="exportExcel();">엑셀다운로드</button>
                    </div>
                </div>
                <div class="main_content">
                    <!-- 필터 영역 main_filter-->
                    <div class="main_filter">
                        <div class="fr">
                            <input type="radio" id="in" name="classifi_cd" value="I" checked onClick="getEntryList()">
                            <label for="in">입고</label>
                            <input type="radio" id="out" name="classifi_cd" value="O" onClick="getEntryList()" >
                            <label for="out">출고</label>
                            <input type="radio" id="carryIn" name="classifi_cd" value="CI" onClick="getEntryList()" >
                            <label for="carryIn">반입</label>
                            <input type="radio" id="carryOut" name="classifi_cd" value="CO" onClick="getEntryList()">
                            <label for="carryOut">반출</label>
                        </div>
                    </div>
                    <!-- 보드 영역 main_dashboard-->
                    <div class="main_dashboard">
                        <div class="sub_cont">
                       		<button type="button" class="btn round" onClick="addRow()"><span>+</span>행추가</button>
                            <div class="btn_wrap">
                                <select id="entryGridPageCount" id="entryGridPageCount" onchange="getEntryList()">
                                    <option value="100">100개씩</option>
                                    <option value="50">50개씩</option>
                                    <option value="30" selected="selected">30개씩</option>
                                </select>
                                <button type="button" class="btn stroke" onClick="_getUserGridLayout('entryLayout', entryGrid);">칼럼위치저장</button>
                                <button type="button" class="btn stroke" onClick="_resetUserGridLayout('entryLayout', entryGrid, entryColumns);">칼럼초기화</button>
                                <button type="button" class="btn" onClick="saveGrid();">저장</button>
                            </div>
                        </div>
                        <div class="grid_wrap" style="position:relative;">
                        	<div id="entryGrid"></div>
                        	<div id="entryGridPager" class="pager"></div>
                        </div>
                        <div class="sub_cont">
                            <div class="btn_wrap">
                                <button type="button" class="btn" onClick="saveGrid();">저장</button>
                            </div>
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