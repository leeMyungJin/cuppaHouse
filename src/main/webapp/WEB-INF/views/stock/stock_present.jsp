<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

 <script type="text/javascript">
 var presentView;
 var presentGridPager;
 var presentGrid;
 var presentColumns;
 var presentSelector;
 
 var partPresentView;
 var partPresentGrid;
 var partPresentColumns;
 
 var stockDtlView;
 var stockDtlGrid;
 var stockDtlColumns;
 var stockDtlSelector;
 
 var memberId = "<%=session.getAttribute("id")%>";
 var memberAuth = "<%=session.getAttribute("auth")%>";

 function pageLoad(){
		sessionCheck(memberId, memberAuth, 'stock');
		
		$('#stock_present').addClass("current");
		
		loadGridList('init');
		getTotalPresentAmt();
	}

	function enterkey() {
	    if (window.event.keyCode == 13) {
	    	getPresentList();
	    }
	}
	
	function popEnterkey() {
	    if (window.event.keyCode == 13) {
	    	getPartPresentList();
	    }
	}
 
	//그리드 초기 셋팅
	function loadGridList(type, result){
	    if(type == "init"){
	        presentView = new wijmo.collections.CollectionView(result, {
	            pageSize: 100,
	            trackChanges: true
	        });
			// 페이지 이동
	        presentGridPager = new wijmo.input.CollectionViewNavigator('#presentGridPager', {
	            byPage: true,
	            headerFormat: '{currentPage:n0} / {pageCount:n0}',
	            cv: presentView
	        });

	        presentColumns =  [
	                { binding: 'name', header: '명칭', isReadOnly: true, width: 150, align:"center"},
	                { binding: 'id', header: '코드', isReadOnly: true, width: 150 },
	                { binding: 'itemState', header: '상태', isReadOnly: true, width: 50, align:"center"},
	                { binding: 'level', header: '레벨', isReadOnly: true, visible: false  },
	                { binding: 'typeCd', header: '분류코드', isReadOnly: true, visible: false  },
	                { binding: 'cost', header: '원가', isReadOnly: true, width: 100, align:"center"  },
	                { binding: 'sellPrice', header: '판매가', isReadOnly: true, width: 100, align:"center"  },
	                { binding: 'quantity', header: '재고수량', isReadOnly: true, width: 150, align:"center"},
	                { binding: 'quantituDtl', header: '재고상세', isReadOnly: true, width: '*', align:"center",
	                    cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
	                        text: '<b>보기</b>',
	                        click: (e, ctx) => {
	                            showPop('dtl_stock', e, ctx);
	                        }
	                    })
	                },
	                { binding: 'minStockCnt', header: '생산가능수량', isReadOnly: true, width: 150, align:"center"},
	                { binding: 'partDtl', header: '파트현황', isReadOnly: true, width: '*', align:"center",
	                    cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
	                        text: '<b>보기</b>',
	                        click: (e, ctx) => {
	                            showPop('prs_part', e, ctx);
	                        }
	                        
	                    })
	                }
	  		    ];
			  
	        presentGrid = new wijmo.grid.FlexGrid('#presentGrid', {
	        	columns : presentColumns,
	            itemsSource: presentView,
	            headersVisibility: 'Column',
	            childItemsPath: ['item', 'item', 'item'],
	            autoGenerateColumns: false,
	            formatItem:function(s,e){
			    	if((e.panel.cellType==1)&&(s.activeEditor)){
			        	if((s.editRange.row==e.row)&&(s.editRange.col==e.col)){
			          	return;
			          }
			        }
			    	
			    	if (e.panel == s.cells) {
			            var col = s.columns[e.col];
			            var value = s.getCellData(e.row, e.col);
		                if (col.binding == 'quantituDtl' || col.binding == 'partDtl') {
		                	//셀 서식
		                    var html;
		                    var level = s.getCellData(e.row, 'level');
		                    var typeCd = s.getCellData(e.row, 'typeCd');

		                   if(level != 3 && typeCd != '4'){
		                	   html = '';
			                   e.cell.textContent = html;           	
		                    }       
		                
		                }else if(col.binding == 'itemState' && (value == 'O' || value == 'X')){
		                	var html = '<div class="state"><div class="mark {status}"></div></div>';
		                	
                            if(value == 'O') {
                                html = html.replace('{status}', 'fin');
                            }else if(value == 'X') {
                                html = html.replace('{status}', 'yet');
                            }
                            e.cell.innerHTML = html;        
		                	
		                }
		            }
			      },
			      cellEditEnding: function (s, e) {
		                var col = s.columns[e.col];
		                var inven = s.columns[e.col - 1];
		                
		                let oldValue = e.data;
		                let newValue = s.getCellData(e.row, e.col);
		                
		                if(oldValue !== newValue){
		                	markAsEdited(s, e.getRow().dataItem);
		                }
		            }
	        });

	       _setUserGridLayout('presentLayout', presentGrid, presentColumns);

	        //행번호 표시하기
	         presentGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        }; 
	        
	        
	        // 파트현황 그리드
	        partPresentView = new wijmo.collections.CollectionView(result, {});
	        
	        partPresentGrid = new wijmo.grid.FlexGrid('#partPresentGrid', {
	            autoGenerateColumns: false,
	            alternatingRowStep: 0,
	            columns: [
	            	{ binding: 'lCategyNm', header: '대카테고리명', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'lCategyCd', header: '대카테고리코드', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'mCategyNm', header: '중카테고리명', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'mCategyCd', header: '중카테고리코드', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'itemNm', header: '품명', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'needQuantity', header: '필요수량', isReadOnly: true, width: 80, align:"center"},
	                { binding: 'quantity', header: '재고수량', isReadOnly: true, width: 80, align:"center"},
	                { binding: 'itemState', header: '상태', isReadOnly: true, width: 50, align:"center"}
	            ],
	            formatItem:function(s,e){
			    	if((e.panel.cellType==1)&&(s.activeEditor)){
			        	if((s.editRange.row==e.row)&&(s.editRange.col==e.col)){
			          	return;
			          }
			        }
			    	
			    	if (e.panel == s.cells) {
			            var col = s.columns[e.col];
			            var value = s.getCellData(e.row, e.col);
		                if(col.binding == 'itemState'){
		                	var html = '<div class="state"><div class="mark {status}"></div></div>';
		                	
                            if(value == 'O') {
                                html = html.replace('{status}', 'fin');
                            }else if(value == 'X') {
                                html = html.replace('{status}', 'yet');
                            }
                            e.cell.innerHTML = html;        
		                	
		                }
		            }
			      },
	            itemsSource: partPresentView
	        });
	        
	        partPresentGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        };
	        
	        
	        //재고 상세 그리드
	        stockDtlView = new wijmo.collections.CollectionView(result, {});
	        
	        stockDtlGrid = new wijmo.grid.FlexGrid('#stockDtlGrid', {
	            autoGenerateColumns: false,
	            alternatingRowStep: 0,
	            columns: [
	            	{ isReadOnly: true, width: 35, align:"center"},
	            	{ binding: 'cretDt', header: '일자', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'prodCd', header: '제품코드', isReadOnly: true, width: 80, align:"center"},
	                { binding: 'partCd', header: '파트코드', isReadOnly: true, width: 80, align:"center"},
	                { binding: 'colorCd', header: '색상코드', isReadOnly: true, width: 80, align:"center"},
	                { binding: 'prodSeq', header: '생산순번', isReadOnly: true, width: 80, align:"center"},
	                { binding: 'barcode', header: '바코드번호', isReadOnly: true, width: 150, align:"center"  },
	                { binding: 'sellYn', header: '판매여부', isReadOnly: true, width: 80, align:"center"  }
	            ],
	            formatItem:function(s,e){
			    	if((e.panel.cellType==1)&&(s.activeEditor)){
			        	if((s.editRange.row==e.row)&&(s.editRange.col==e.col)){
			          	return;
			          }
			        }
			    	
			    	if (e.panel == s.cells) {
			            var col = s.columns[e.col];
			            var value = s.getCellData(e.row, e.col);
		                if(col.binding == 'sellYn'){
		                	var html = '<div class="state"><div class="mark {status}"></div></div>';
		                	
                            if(value == 'O') {
                                html = html.replace('{status}', 'fin');
                            }else if(value == 'X') {
                                html = html.replace('{status}', 'yet');
                            }
                            e.cell.innerHTML = html;        
		                	
		                }
		            }
			      },
	            itemsSource: stockDtlView
	        });
	        stockDtlSelector = new wijmo.grid.selector.Selector(stockDtlGrid);
	        stockDtlSelector.column = stockDtlGrid.columns[0];
	        
	        stockDtlGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        };
	        
	    }else if(type == "partPresent"){
	    	partPresentView = new wijmo.collections.CollectionView(result, {});
	        partPresentGrid.itemsSource = partPresentView;
	    	
	    }else if(type == "stockDtl"){
	    	stockDtlView = new wijmo.collections.CollectionView(result, {});
	        stockDtlGrid.itemsSource = stockDtlView;
	        
	    }else{
	        presentView = new wijmo.collections.CollectionView(result, {
	            pageSize: Number($('#presentGridPageCount').val()),
	            trackChanges: true
	        });
	        presentGridPager.cv = presentView;
	        presentGrid.itemsSource = presentView;
	        
		}
	    refreshPaging(presentGrid.collectionView.totalItemCount, 1, presentGrid, 'presentGrid');
	}

	function markAsEdited(grid, item){
		let existionItem = grid.collectionView.itemsEdited.find(
			(_item) => _item === item
		);
		if(!existionItem){
			grid.collectionView.itemsEdited.push(item);
		}
	}	
	
function getTotalPresentAmt(){
 	$.ajax({
 	      type : 'POST',
 	      url : '/stock/getTotalPresentAmt',
 	      async : false, // 비동기모드 : true, 동기식모드 : false
 	      dataType : null,
 	      success : function(result) {
 	      	$("#inNeedItemCnt").text(Number(result.inneeditemcnt).toLocaleString('ko-KR')+ "개");
 	        $("#woodStockAmt").text(Number(result.woodstockamt).toLocaleString('ko-KR')+ "원");
 	       	$("#prodStockAmt").text(Number(result.prodstockamt).toLocaleString('ko-KR')+ "원");
 	      	$("#exProdSales").text(Number(result.exprodsales).toLocaleString('ko-KR')+ "원");
 	      },
 	      error: function(request, status, error) {
 	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
 	      }
 	  });
 }

//코드 검색
function getPresentList(){
    var params = {
            inq : $("#inq").val(),
            con : $("#con").val(),
            typeCd : $("#typeCd").val(),
            slct : $("#slct").is(':checked')   
    	}
    
    	$.ajax({
            url : "/stock/getPresentList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            data : params,
            success : function(result) {
            	if(result.length > 0){
            		let itemArr = new Array();
            		let mCArr = new Array();
            		let lCArr = new Array();
            		let typeArr = new Array();
                	
                	for(var i =0; i<result.length; i++){
                		if(result[i].level == 3){
                			
                			let itemOb = new Object();
                			itemOb.id = result[i].id;
                			itemOb.name = result[i].name;
                			itemOb.level = result[i].level;
                			itemOb.unit = result[i].unit;
                			itemOb.cost = result[i].cost;
                			itemOb.sellPrice = result[i].sellPrice;
                			itemOb.tagQuantity = result[i].tagQuantity;
                			itemOb.quantity = result[i].quantity;
                			itemOb.prodQuantity = result[i].prodQuantity;
                			itemOb.activeYn = Boolean(result[i].activeYn);
                			itemOb.cretDt = result[i].cretDt;
                			itemOb.cretId = result[i].cretId;
                			itemOb.updtDt = result[i].updtDt;
                			itemOb.updtId = result[i].updtId;
                			itemOb.itemState = result[i].itemState;
                			itemOb.minStockCnt = result[i].minStockCnt;
                			itemArr.push(itemOb);
                			
                		}else if(result[i].level == 2){
                			let mCOb = new Object();
                			mCOb.id = result[i].id;
                			mCOb.name = result[i].name;
                			mCOb.item = itemArr;
                			
                			mCArr.push(mCOb);
                			itemArr = [];
                			
                		}else if(result[i].level == 1){
                			let lCOb = new Object();
                			lCOb.id = result[i].id;
                			lCOb.name = result[i].name;
                			lCOb.item = mCArr;
                			
                			lCArr.push(lCOb);
                			mCArr = [];
                			
                		}else if(result[i].level == 0){
                			let typeOb = new Object();
                			typeOb.id = result[i].id;
                			typeOb.name = result[i].name;
                			typeOb.item = lCArr;
                			
                			typeArr.push(typeOb);
                			lCArr = [];
                		}
                	}
                	
                	console.log(typeArr);
                	loadGridList('search', typeArr);
            	}
            },
            error : function(request,status,error) {
             	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
          });
}


//팝업 오픈
function showPop(pop, e, ctx){
	if(pop == "prs_part"){
		prsPartForm.itemCd1.value = ctx.item["id"];
		prsPartForm.itemNm1.value = ctx.item["name"];
		prsPartForm.prdtNum.value = ctx.item["minStockCnt"];
		
		getPartPresentList();
      
	}else if(pop == "dtl_stock"){
		dtlStockForm.itemCd2.value = ctx.item["id"];
		dtlStockForm.itemNm2.value = ctx.item["name"];
		dtlStockForm.stockNum.value = ctx.item["quantity"];
      
      	getStockDtlList();
	}
	
	 $('#'+pop).addClass('is_on');
  
}

//팝업 종료
function closePop(){
	$('.popup').removeClass('is_on');
}

//엑셀 다운로드
function exportExcel(){
	
	var gridView = presentGrid.collectionView;
	var oldPgSize = gridView.pageSize;
	var oldPgIndex = gridView.pageIndex;

    //전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
    presentGrid.beginUpdate();
    presentView.pageSize = 0;

    wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(presentGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'presentList.xlsx',
	      saved => {
	    	gridView.pageSize = oldPgSize;
	    	gridView.moveToPage(oldPgIndex);
	    	presentGrid.endUpdate();
	      }, null
	 );
}

function popStockBarcodeList(){
	var item = stockDtlGrid.rows.filter(r => r.isSelected);
	var selectBarcode;
	
	if(item.length == 0){
        alert("선택된 행이 없습니다.");
        return false;
    }else{
    	selectBarcode = item[0].dataItem.barcode;
    	for(var i =1; i< item.length ; i++){
    		selectBarcode += ','+item[i].dataItem.barcode;
        }
    	
    	var win = window.open("/stock/getStockBarcodeList?selectBarcode="+selectBarcode, "PopupWin", "width=1400,height=600");

    }

}

function getPartPresentList(){
	var param = {
		itemCd 	: $('#itemCd1').val(),
		needNum : $('#needNum').val()
	};
	
	$.ajax({
     type : 'POST',
     url : '/stock/getPartPresentList',
     dataType : null,
     data : param,
     success : function(result) {
     	console.log("getPartPresentList success");
     	loadGridList('partPresent', result);
     },
     error: function(request, status, error) {
     	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

     }
 }); 
}

function getStockDtlList(){
	var param = {
		itemCd 	: $('#itemCd2').val()
	};
	
	$.ajax({
     type : 'POST',
     url : '/stock/getStockDtl',
     dataType : null,
     data : param,
     success : function(result) {
     	console.log("getStockDtl success");
     	loadGridList('stockDtl', result);
     },
     error: function(request, status, error) {
     	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

     }
 }); 
}

 </script>

<body onload="pageLoad()">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">재고현황</h2>
                <div class="main_summary">
                    <dl>
                        <dt>추가입고 필요항목</dt>
                        <dd id="inNeedItemCnt">0개</dd>
                    </dl>
                    <dl>
                        <dt>판재재고자산</dt>
                        <dd id="woodStockAmt">0원</dd>
                    </dl>
                    <dl>
                        <dt>제품재고자산</dt>
                        <dd id="prodStockAmt">0원</dd>
                    </dl>
                    <dl>
                        <dt>예상제품매출</dt>
                        <dd id="exProdSales">0원</dd>
                    </dl>
                </div>
                <div class="main_utility">
                    <div class="btn_wrap">
                        <button class="btn stroke" onclick="exportExcel();">엑셀다운로드</button>
                    </div>
                </div>
                <div class="main_content">
                    <!-- 필터 영역 main_filter-->
                    <div class="main_filter">
                        <form action="#">
                            <label for="con" id="search_form" name="search_form" onsubmit="return false;">검색조건</label>
                            <select name="con" id="con">
                                <option value="all" selected="selected">전체</option>
                                <option value="sortName">분류명</option>
                                <option value="cgNanme">카테고리명</option>
                                <option value="pdName">물품명</option>
                                <option value="pdCode">물품코드</option>
                            </select>
                            <label for="inq">조회</label>
                            <input id="inq" type="text" placeholder=",로 다중검색 가능" onkeyup="enterkey();">
                            <button type="button" class="main_filter_btn" onClick="getPresentList();"><i>조회</i></button>
                        </form>
                        <input type="checkbox" id="slct" onChange="getPresentList();" checked>
                        <label for="slct">추가입고 필요항목만 보기</label>
                    </div>
                    <!-- 보드 영역 main_dashboard-->
                    <div class="main_dashboard">
                        <div class="sub_cont">
                            <select name="typeCd" id="typeCd">
                                <option value="all">전체</option>
                                <option value="1">소모품</option>
                                <option value="2">판재</option>
                                <option value="3">파트</option>
                                <option value="4">제품</option>
                            </select>
                            <button class="btn" onClick="getPresentList();">보기</button>
                            <div class="state">
                                <span><dfn class="mark fin"></dfn>충분</span>
                                <span><dfn class="mark yet"></dfn>부족</span>
                            </div>
                            <div class="btn_wrap">
                                <select id="presentGridPageCount" id="presentGridPageCount" onchange="getPresentList();">
                                    <option value="100">100개씩</option>
                                    <option value="50">50개씩</option>
                                    <option value="30" selected="selected">30개씩</option>
                                </select>
                                <button type="button" class="btn stroke" onClick="_getUserGridLayout('presentLayout', presentGrid);">칼럼위치저장</button>
                                <button type="button" class="btn stroke" onClick="_resetUserGridLayout('presentLayout', presentGrid,presentColumns);">칼럼초기화</button>

                            </div>
                        </div>
                        <div class="grid_wrap" id="presentDiv" style="position:relative;">
                        	<div id="presentGrid"></div>
                        	<div id="presentGridPager" class="pager"></div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <!-- 팝업 -->
        <!-- 팝업 : 파트현황 -->
        <div class="popup" id="prs_part">
            <div class="popup_container">
                <div class="popup_head">
                    <p class="popup_title">파트현황</p>
                    <button type="button" class="popup_close" onClick="closePop()">x</button>
                </div>
                <div class="popup_inner">
                	<form id="prsPartForm" onsubmit="return false;">
	                    <div class="util">
	                        <label for="prdtName">제품명</label>
	                        <input type="text" id="itemNm1" name="itemNm1" onfocus="this.blur()" readonly>
	                        <input type="text" id="itemCd1" name="itemCd1" style="display:none;">
	                    </div>
	                    <div class="util">
	                        <label for="prdtNum">생산가능수량</label>
	                        <input type="text" class="nar" id="prdtNum" name="prdtNum" readonly>
	                        <label for="needNum">필요생산수량</label>
	                        <input type="text"  class="nar" id="needNum" name="needNum" onkeyup="popEnterkey();">
	                    </div>
	                    <div class="popup_grid">
	                        <div class="state">
	                            <span><i class="mark fin"></i>충분</span>
	                            <span><i class="mark yet"></i>부족</span>
	                        </div>
	                        <div class="grid_wrap" style="width:500px;">
	                        	<div id="partPresentGrid" ></div>
	                        </div>
	                    </div>
	                 </form>
                </div>
            </div>
        </div>
        <!-- 파트현황 팝업 영역 끝 -->
        <!-- 팝업 : 재고상세 -->
        <div class="popup" id="dtl_stock">
            <div class="popup_container">
                <div class="popup_head">
                    <p class="popup_title">재고상세</p>
                    <button type="button" class="popup_close" onClick="closePop();">x</button>
                </div>
                <div class="popup_inner">
                	<form id="dtlStockForm" onsubmit="return false;">
	                    <div class="util">
	                        <label for="prdtName">제품명</label>
	                        <input type="text" id="itemNm2" name="itemNm2" onfocus="this.blur()" readonly>
	                        <input type="text" id="itemCd2" name="itemCd2" style="display:none;">
	                        <label for="stockNum">재고수량</label>
	                        <input type="text"  class="nar" id="stockNum" name="stockNum">
	                    </div>
	                    <div class="popup_grid">
	                        <div class="sub_cont">
	                            <div class="btn_wrap">
	                                <button class="btn blck" onClick="popStockBarcodeList();">바코드출력</button>
	                            </div>
	                        </div>
	                        <div class="grid_wrap" style="width:500px;">
	                        	<div id="stockDtlGrid" ></div>
	                        </div>
	                    </div>
                   </form>
                </div>
            </div>
        </div>
        <!-- 재고상세 팝업 영역 끝 -->
    </div>
</body>
</html>