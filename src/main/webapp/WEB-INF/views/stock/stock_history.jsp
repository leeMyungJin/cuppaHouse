<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

<script type="text/javascript">

var historyView;
var historyGridPager;
var historyGrid;
var historyColumns;

var editGrid;
var editGridView;

var memberId = "<%=session.getAttribute("id")%>";
var memberAuth = "<%=session.getAttribute("auth")%>";


function pageLoad(){
	sessionCheck(memberId, memberAuth, 'history');
	
	$('#stock_history').addClass("current");
	
	var fromDate = new Date()
	fromDate.setDate(fromDate.getDate() - 7);
	var fromday = _getFormatDate(fromDate);
	var today = _getFormatDate(new Date());
	$('#fromDate').val(fromday);
	$('#toDate').val(today);
	$('#fromDate').attr('max',today);
	$('#toDate').attr('max',today);
	
	loadGridList('init');
	
	//getHistoryList();
	getTotalHistoryCnt();
}


function enterkey() {
    if (window.event.keyCode == 13) {
    	getHistoryList();
    }
}

//그리드 초기 셋팅
function loadGridList(type, result){
	  if(type == "init"){
		   historyView = new wijmo.collections.CollectionView(result, {
		       pageSize: 100
		   });
		    
		   historyGridPager = new wijmo.input.CollectionViewNavigator('#historyGridPager', {
		        byPage: true,
		        headerFormat: '{currentPage:n0} / {pageCount:n0}',
		        cv: historyView
		    });
		   
		   historyColumns = [
		      { binding: 'cateSarSeq', header: '순번', isReadOnly: true, width: 120, align:"center", visible: false },
		      { binding: 'groupSeq', header: '이력순번', isReadOnly: true, width: 100, align:"center", allowMerging: true},
		      { binding: 'cretDt', header: '생성일', isReadOnly: true, width: 110, align:"center" },
		      { binding: 'cretNm', header: '생성자이름', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'updtDt', header: '수정일', isReadOnly: true, width: 110, align:"center" },
		      { binding: 'updtNm', header: '수정자이름', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'bldgNm', header: '건물명', isReadOnly: true, width: 150, align:"center" },
		      { binding: 'classifiNm', header: '이력구분', isReadOnly: true, width: 80, align:"center" },
		      { binding: 'classifiCd', header: '이력구분코드', isReadOnly: true, width: 80, align:"center", visible: false  },
		      { binding: 'typeNm', header: '분류', isReadOnly: true, width: 80, align:"center" },
		      { binding: 'lCategyNm', header: '대카테고리명', isReadOnly: true, width: 150, align:"center" },
		      { binding: 'mCategyNm', header: '중카테고리명', isReadOnly: true, width: 150, align:"center" },
		      { binding: 'itemNm', header: '물품명', isReadOnly: true, width: 150, align:"center" },
		      { binding: 'itemCd', header: '물품코드', isReadOnly: true, width: 120, align:"center" },
		      { binding: 'cost', header: '원가', isReadOnly: true, width: 120, align:"center" },
		      { binding: 'sellPrice', header: '판매가', isReadOnly: true, width: 120, align:"center" },
		      { binding: 'sarQuantity', header: '입출수량', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'returnQuantity', header: '반품수량', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'itemActiveYn', header: '활성화', isReadOnly: false, visible: false, width: 100, align:"center" },
		      { binding: 'quantity', header: '재고', isReadOnly: true, width: 120, visible: false, align:"center" }
		    ];
		  
		   historyGrid = new wijmo.grid.FlexGrid('#historyGrid', {
			    autoGenerateColumns: false,
			    alternatingRowStep: 0,
			    columns: historyColumns,
			    itemsSource: historyView,
			    allowMerging: 'Cells',
			    selectionMode: 'Row',
			    selectionChanged: function (s, e) {
			    	selectClassifiCd = s.getCellData(e.row, 'classifiCd');
			    	selectGroupSeq = s.getCellData(e.row, 'groupSeq');
		        },
			    formatItem:function(s,e){
			    	if((e.panel.cellType==1)&&(s.activeEditor)){
			        	if((s.editRange.row==e.row)&&(s.editRange.col==e.col)){
			          	return;
			          }
			        }
			    	
			    	if (e.panel == s.cells) {
			            var col = s.columns[e.col];
		                if (col.binding == 'sarQuantity' || col.binding == 'returnQuantity') {
		                    //셀 서식
		                    var html;
		                    var value = s.getCellData(e.row, e.col);
		                    var classifiCd = s.getCellData(e.row, 'classifiCd');

		                   if(value != undefined && value != null && value > 0){
		                    	if(classifiCd == "I" || classifiCd == "CI"){
			                    	html = '+'+value;
			                        wijmo.addClass(e.cell, "change_plus");
			                    	
			                    }else if(classifiCd == "O" || classifiCd == "CO"){
			                    	html = -value;
			                        wijmo.addClass(e.cell, "change_minus");
			                    }
			                    e.cell.textContent = html;           	
		                    }       
		                }
		            }
			      },
			      beginningEdit: function (s, e) {
			    	  
			    	  	console.log('1');
			    	  
		                var col = s.columns[e.col];
		                var item = s.rows[e.row].dataItem;
		                
		                if (col.binding == 'sarQuantity') {
		                	if(item.itemActiveYn == 'N'){
		                		e.cancel = true;
		                		alert("해당 이력은 물품이 삭제(혹은 비활성화)되어 수정이 불가능합니다.");
		                	}else{
		                		classifiCd = s.getCellData(e.row, 'classifiCd');
			                	if(classifiCd == "CI" || classifiCd == "CO"){
			                		e.cancel = true;
			                		alert("분류가 입고/출고일 경우에만 입력 가능합니다.");
			                	}
		                	}
		                	
		                }else if(col.binding == 'returnQuantity'){
		                	if(item.itemActiveYn == 'N'){
		                		e.cancel = true;
		                		alert("삭제 된 물품의 이력은 수정이 불가능합니다.");
		                	}else{
		                		classifiCd = s.getCellData(e.row, 'classifiCd');
			                	if(classifiCd == "I" || classifiCd == "O"){
			                		e.cancel = true;
			                		alert("분류가 반품입고/반품출고일 경우에만 입력 가능합니다.");
			                	}
		                	}
		                	
		                }
		            },
		            cellEditEnding: (s, e) => {
		                let col = s.columns[e.col];
		                let value = s.activeEditor.value;
		                if(col.binding == 'sarQuantity' || col.binding == 'returnQuantity'){
		                	//숫자여부 확인
		                	var formatValue = wijmo.changeType(s.activeEditor.value, wijmo.DataType.Number, col.format);
		                    if( !wijmo.isNumber(formatValue)){
		                        e.cancel = true;
		                        e.stayInEditMode = false;
		                        alert('숫자로만 입력 가능합니다.');
		                        return false;
		                    }
		                	
		                    //재고수량 계산
		                    var quantity = s.getCellData(e.row, 'quantity');
		                	if(classifiCd == "I" || classifiCd == "CI"){
		                		if(s.getCellData(e.row, e.col) != '' && s.getCellData(e.row, e.col) != null){
		                			s.setCellData(e.row, 'quantity', Number(quantity) - s.getCellData(e.row, e.col) + Number(value));
		                			
		                		}else{
		                			s.setCellData(e.row, 'quantity', Number(quantity) + Number(value));
		                			
		                		}
		                		
		                    }else if(classifiCd == "O" || classifiCd == "CO"){
		                    	if(s.getCellData(e.row, e.col) != '' && s.getCellData(e.row, e.col) != null){
		                    		s.setCellData(e.row, 'quantity', Number(quantity) + s.getCellData(e.row, e.col) - Number(value));
		                			
		                		}else{
		                			s.setCellData(e.row, 'quantity', Number(quantity) - Number(value));
		                			
		                		}
		                    }
		                }
		            }
			  });
			  
		   historyGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        }; 
		   
		   	_setUserGridLayout('historyLayout', historyGrid, historyColumns);
		   	
		   	editGrid = new wijmo.grid.FlexGrid('#editGrid', {
	            itemsSource: historyView.itemsEdited,
	            isReadOnly: true
	        });
			  
	  }else{
		  historyView = new wijmo.collections.CollectionView(result, {
		       pageSize: Number($('#historyGridPageCount').val())
		       ,trackChanges: true
		   });
		  historyGridPager.cv = historyView;
		  historyGrid.itemsSource = historyView;
	  }
	  
	  refreshPaging(historyGrid.collectionView.totalItemCount, 1, historyGrid, 'historyGrid');  // 페이징 초기 셋팅
	  
}

//멤버 리스트 조회
function getHistoryList(){
	var param = {
		con 	: $('#con').val()
		, inq 	: $('#inq').val()
		, fromDate : $('#fromDate').val()
		, toDate : $('#toDate').val()
	};
	
	$.ajax({
	   type : 'POST',
	   url : '/stock/getHistoryList',
	   dataType : null,
	   data : param,
	   success : function(result) {
	   	console.log("getHistoryList success");
	   	
	   	loadGridList('search', result);
	   	getTotalHistoryCnt();
	   },
	   error: function(request, status, error) {
	   	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	
	   }
	}); 
}

function getTotalHistoryCnt(){
	var param = {
			con 	: $('#con').val()
			, inq 	: $('#inq').val()
			, fromDate : $('#fromDate').val()
			, toDate : $('#toDate').val()
		};
	
	$.ajax({
	      type : 'POST',
	      url : '/stock/getTotalHistoryCnt',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      data : param,
	      success : function(result) {
	      	console.log(result);
	      	$("#ICount").text(Number(result.icount).toLocaleString('ko-KR')+ "개");
	        $("#OCount").text(Number(result.ocount).toLocaleString('ko-KR')+ "개");
	        $("#CICount").text(Number(result.cicount).toLocaleString('ko-KR')+ "개");
	        $("#COCount").text(Number(result.cocount).toLocaleString('ko-KR')+ "개");
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      }
	  });
}


function saveGrid(){
    var editItem = historyView.itemsEdited;
	var rows = [];
	
	console.log("saveGrid");
	console.log(editItem);
	
	for(var i =0; i< editItem.length; i++){
    	rows.push(editItem[i]);
    }
	
	wijmo.Control.getControl("#editGrid").refresh(true);
    if(confirm("변경한 내용을 저장 하시겠습니까??")){
    	$.ajax({
            url : "/stock/saveHistory",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            contentType: 'application/json',
            data: JSON.stringify(rows),
            success : function(result) {
               	console.log('saveHistory');
               	alert("저장되었습니다.");
               	getHistoryList();
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
    }
}

function exportExcel(){
	var gridView = historyGrid.collectionView;
	var oldPgSize = gridView.pageSize;
	var oldPgIndex = gridView.pageIndex;

    //전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
    historyGrid.beginUpdate();
    historyView.pageSize = 0;

    wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(historyGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'historyList.xlsx',
	      saved => {
	    	gridView.pageSize = oldPgSize;
	    	gridView.moveToPage(oldPgIndex);
	    	historyGrid.endUpdate();
	      }, null
	 );
}


var selectClassifiCd = "";
var selectGroupSeq = "";
function deleteGrid(){
	console.log(selectClassifiCd);
	console.log(selectGroupSeq);
	
	if(selectClassifiCd == ""){
        alert("선택된 행이 없습니다.");
        return false;
    }else{
    	var param = {
    			groupSeq 	: selectGroupSeq
    			, classifiCd 	: selectClassifiCd
    		};
    	
    	if(confirm("삭제하시겠습니까?")){
    		$.ajax({
	    	     type : 'POST',
	    	     url : '/stock/deleteHistory',
	    	     dataType : null,
	    	     data : param,
	    	     success : function(result) {
	    	    	alert("정상적으로 삭제되었습니다.");
					getHistoryList();
					getTotalHistoryCnt();
	    	     },
	    	     error: function(request, status, error) {
	    	     	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	
	    	     }
	    	})
    	}
    } 
}


</script>


<body onload="pageLoad();">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">재고이력</h2>
                <div class="main_summary">
                    <dl>
                        <dt>금일 입고수량</dt>
                        <dd id="ICount">0개</dd>
                    </dl>
                    <dl>
                        <dt>금일 출고수량</dt>
                        <dd id="OCount">0개</dd>
                    </dl>
                    <dl>
                        <dt>금일 반품입고수량</dt>
                        <dd id="CICount">0개</dd>
                    </dl>
                    <dl>
                        <dt>금일 반품출고수량</dt>
                        <dd id="COCount">0개</dd>
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
                        <button class="btn stroke" onClick="exportExcel();">엑셀다운로드</button>
                    </div>
                </div>
                 <!-- 필터 영역 main_filter-->
                 <div class="main_filter">
                    <form action="#" id="search_form" name="search_form" onsubmit="return false;">
                        <label for="con">검색조건</label>
                        <select name="con" id="con">
                            <option value="all" selected="selected">전체</option>
                            <option value="staffName">직원명</option>
                            <option value="bldgName">건물명</option>
                            <option value="sortName">분류명</option>
                            <option value="separate">이력구분</option>
                            <option value="cgNanme">카테고리명</option>
                            <option value="pdName">물품명</option>
                            <option value="pdCode">물품코드</option>
                        </select>
                        <label for="inq" onkeyup="enterkey();">조회</label>
                        <input id="inq" type="text" placeholder=",로 다중검색 가능" onkeyup="enterkey();">
                        <button type="button" class="main_filter_btn" onClick="getHistoryList();"><i>조회</i></button>
                    </form>
                </div>
                <!-- 보드 영역 main_dashboard-->
                <div class="main_dashboard">
                    <div class="sub_cont">
                        <div class="btn_wrap">
                            <select id="historyGridPageCount" id="historyGridPageCount" onchange="getHistoryList()">
                                <option value="100">100개씩</option>
                                <option value="50">50개씩</option>
                                <option value="30" selected="selected">30개씩</option>
                            </select>
                            <button type="button" class="btn stroke" onClick="_getUserGridLayout('historyLayout', historyGrid);">칼럼위치저장</button>
                            <button type="button" class="btn stroke" onClick="_resetUserGridLayout('historyLayout', historyGrid, historyColumns);">칼럼초기화</button>
                            <button type="button" class="btn" onClick="saveGrid();">저장</button>
                            <button type="button" class="btn" onClick="deleteGrid();">삭제</button>
                        </div>
                    </div>
                    <div class="grid_wrap" style="position:relative;">
                    	<div id="historyGrid" ></div>
                        <div id="historyGridPager" class="pager"></div>
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