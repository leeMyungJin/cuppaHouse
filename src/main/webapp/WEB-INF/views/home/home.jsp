<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

<script type="text/javascript">
var presentView;
var presentGrid;
var presentColumns;
var presentSelector;

var processView;
var processGrid;
var processColumns;

var partPresentView;
var partPresentGrid;
var partPresentColumns;

var partPresentView2;
var partPresentGrid2;
var partPresentColumns2;

var faultyList;

var memberId = "<%=session.getAttribute("id")%>";
var memberAuth = "<%=session.getAttribute("auth")%>";

function pageLoad(){
	sessionCheck(memberId, memberAuth, 'home');
	
	$('#home').addClass("current");
	
	loadGridList('init');
	getTotalHomeCnt();
	getPresentList();
	getProcessList();
}

function popEnterkey() {
    if (window.event.keyCode == 13) {
    	getPartPresentList();
    }
}

//그리드 초기 셋팅
function loadGridList(type, result){
    if(type == "init"){
        presentView = new wijmo.collections.CollectionView(result, {});

        presentColumns =  [
                { binding: 'name', header: '명칭', isReadOnly: true, width: 150, align:"center"},
                { binding: 'id', header: '코드', isReadOnly: true, width: 150 },
                { binding: 'itemState', header: '상태', isReadOnly: true, width: 50, align:"center"},
                { binding: 'level', header: '레벨', isReadOnly: true, visible: false  },
                { binding: 'typeCd', header: '분류코드', isReadOnly: true, visible: false  },
                { binding: 'cost', header: '원가', isReadOnly: true, width: 150, align:"center"  },
                { binding: 'quantity', header: '재고수량', isReadOnly: true, width: 200, align:"center"},
                { binding: 'minStockCnt', header: '생산가능수량', isReadOnly: true, width: 200, align:"center"},
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
	                if (col.binding == 'partDtl') {
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

        //행번호 표시하기
         presentGrid.itemFormatter = function (panel, r, c, cell) { 
            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
                cell.textContent = (r + 1).toString();
            }
        }; 
        
        
        //공정현황 그리드
        processView = new wijmo.collections.CollectionView(result, {});
		    
		   processColumns = [
			  { binding: 'processSeq', header: 'seq', isReadOnly: true, width: 100, align:"center", visible: false   },
			  { binding: 'cretDt', header: '일자', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'bldgNm', header: '건물명', isReadOnly: true, width: 200, align:"center"  },
		      { binding: 'bldgCd', header: '건물코드', isReadOnly: true, width: 100, align:"center" , visible: false  },
		      { binding: 'prcCd', header: '공정', isReadOnly: true, width: 50, align:"center" },
		      { binding: 'itemNm', header: '물품명', isReadOnly: true, width: 200, align:"center" },
		      { binding: 'itemCd', header: '물품코드', isReadOnly: true, width: 100, align:"center"},
		      { binding: 'prcStDt', header: '시작일', isReadOnly: true, width: 100, align:"center"  },
		      { binding: 'prcEndPDt', header: '마감예정일', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'prcEndDt', header: '공정완료일', isReadOnly: false, width: 150, align:"center"  },
		      { binding: 'dDay', header: '디데이', isReadOnly: true, width: 80, align:"center"  },
		      { binding: 'prcState', header: '상태', isReadOnly: true, width: 50, align:"center"  },
		      { binding: 'prodCnt', header: '생산수량', isReadOnly: true, width: 80, align:"center"  },
		      { binding: 'need', header: '필요자재', width: 80, align:"center",
		    	  cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
		              text: '<b>보기</b>',
		              click: (e, ctx) => {
		            	  showPop('prs_part2', e, ctx);
		              }
		              
		    	  })
		      },
		      { binding: 'memo', header: '비고', isReadOnly: false, width: 200, align:"center"  }
		    ];
		   
		   var prcEndDtEditor = new wijmo.input.InputDate(document.createElement("div"));
		   processGrid = new wijmo.grid.FlexGrid('#processGrid', {
			    autoGenerateColumns: false,
			    alternatingRowStep: 0,
			    columns: processColumns,
			    itemsSource: processView,
			    beginningEdit: function (s, e) {
			    	s.columns.getColumn("prcEndDt").editor = prcEndDtEditor;
	            },
	            formatItem:function(s,e){
			    	if((e.panel.cellType==1)&&(s.activeEditor)){
			        	if((s.editRange.row==e.row)&&(s.editRange.col==e.col)){
			          	return;
			          }
			        }
			    	
			    	if (e.panel == s.cells) {
			            var col = s.columns[e.col];
			            var value = s.getCellData(e.row, e.col);
		                if(col.binding == 'prcState'){
		                	var html = '<div class="state"><div class="mark {status}"></div></div>';
		                	
                         if(value == 'G') { //마감
                             html = html.replace('{status}', '');
                         }else if(value == 'Y') { //진행중
                             html = html.replace('{status}', 'yellow');
                         }else if(value == 'R') { //지연 
                             html = html.replace('{status}', 'red');
                         }
                         e.cell.innerHTML = html;        
		                	
		                }
		            }
			      },
			  });
			  
		   processGrid.itemFormatter = function (panel, r, c, cell) { 
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
        
        
        
	     // 필요자재 그리드
	        partPresentView2 = new wijmo.collections.CollectionView(result, {});
	        
	        partPresentGrid2 = new wijmo.grid.FlexGrid('#partPresentGrid2', {
	            autoGenerateColumns: false,
	            alternatingRowStep: 0,
	            columns: [
	            	{ binding: 'lCategyNm', header: '대카테고리명', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'lCategyCd', header: '대카테고리코드', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'mCategyNm', header: '중카테고리명', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'mCategyCd', header: '중카테고리코드', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'itemNm', header: '품명', isReadOnly: true, width: 100, align:"center"},
	                { binding: 'needQuantity', header: '필요수량', isReadOnly: true, width: 80, align:"center"},
	                { binding: 'sarCount', header: '입고수량', isReadOnly: true, width: 80, align:"center"},
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
	            itemsSource: partPresentView2
	        });
	        
	        partPresentGrid2.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        };
        
        
    }else if(type == "partPresent"){
    	partPresentView = new wijmo.collections.CollectionView(result, {});
        partPresentGrid.itemsSource = partPresentView;
    	
    }else if(type == "partPresent2"){
    	partPresentView2 = new wijmo.collections.CollectionView(result, {});
        partPresentGrid2.itemsSource = partPresentView2;
    	
    }else if(type == "process"){
    	 processView = new wijmo.collections.CollectionView(result, {});
		 processGrid.itemsSource = processView;
    	
    }else{
        presentView = new wijmo.collections.CollectionView(result, {});
        presentGrid.itemsSource = presentView;
        
	}
}

function markAsEdited(grid, item){
	let existionItem = grid.collectionView.itemsEdited.find(
		(_item) => _item === item
	);
	if(!existionItem){
		grid.collectionView.itemsEdited.push(item);
	}
}	

function getTotalHomeCnt(){
	$.ajax({
	      type : 'POST',
	      url : '/stock/getTotalHomeCnt',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      success : function(result) {
	      	$("#proPrc").text(Number(result.proprc).toLocaleString('ko-KR')+ "개");
	        $("#proCnt").text(Number(result.procnt).toLocaleString('ko-KR')+ "개");
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      }
	  });
}

//코드 검색
function getPresentList(){
var params = {
        inq : '',
        con : '',
        typeCd : '',
        slct : ''  
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


//공정정보 조회
function getProcessList(){
	var param = {
			con 	: ''
			, inq 	: ''
		//	, fromDate : null
		//	, toDate : null
			, prcState : ''
		};
	
	$.ajax({
     type : 'POST',
     url : '/process/getProcessList',
     dataType : null,
     data : param,
     success : function(result) {
     	console.log("getProcessList success");
     	loadGridList('process', result);
     },
     error: function(request, status, error) {
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
	  
	}else if(pop == "prs_part2"){
		prsPartForm2.itemNm2.value = ctx.item["itemNm"];
		prsPartForm2.itemCd2.value = ctx.item["itemCd"];
		prsPartForm2.prodCnt2.value = ctx.item["prodCnt"];
		prsPartForm2.processSeq2.value = ctx.item["processSeq"];
		
		getNeedMaterList();
      
	}
	
	 $('#'+pop).addClass('is_on');

}

//건물 리스트 조회
function getNeedMaterList(){
	var param = {
			prodCnt 	: prsPartForm2.prodCnt2.value
			, itemCd 	: prsPartForm2.itemCd2.value
			, processSeq 	: prsPartForm2.processSeq2.value
		};
	
	$.ajax({
     type : 'POST',
     url : '/process/getNeedMaterList',
     dataType : null,
     data : param,
     success : function(result) {
     	console.log("getNeedMaterList success");
     	loadGridList('partPresent2', result);
     },
     error: function(request, status, error) {
     	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

     }
 }); 
}

//팝업 종료
function closePop(){
	$('.popup').removeClass('is_on');
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

</script>

<body onload="pageLoad()">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">홈 화면</h2>
                <div class="main_summary half">
                    <dl>
                        <dt>생산중인 제품</dt>
                        <dd id="proCnt">0개</dd>
                    </dl>
                    <dl>
                        <dt>진행중인 공정</dt>
                        <dd id="proPrc">0개</dd>
                    </dl>
                </div>
                <div class="main_box">
                    <div class="sub_cont">
                        <h3>공정정보</h3>
                        <button class="btn blck" onclick="location.href='/process/'">자세히보기<i></i></button>
                    </div>
                    <div class="cont">
                    	<div id="processGrid" style="max-height:300px;"></div>
                    </div>
                </div>
                <div class="main_box" style="margin-top:45px;">
                    <div class="sub_cont">
                        <h3>재고현황</h3>
                        <button class="btn blck" onclick="location.href='/stock/present'">자세히보기<i></i></button>
                    </div>
                    <div class="cont">
                    	<div id="presentGrid" style="max-height:300px;"></div>
                    </div>
                </div>
            </section>
        </div>
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
        
        <!-- 팝업 : 필요자재 -->
        <div class="popup" id="prs_part2">
        	<form id="prsPartForm2" onsubmit="return false;">
	            <div class="popup_container">
	                <div class="popup_head">
	                    <p class="popup_title">필요자재</p>
	                    <button type="button" class="popup_close" onClick="closePop()">x</button>
	                </div>
	                <div class="popup_inner">
	                    <div class="util">
	                        <label for="mnfPd">생산제품</label>
	                        <input type="text" class="nar" id="itemNm2" onfocus="this.blur();" readonly>
	                        <label for="mnfNum">생산수량</label>
	                        <input type="text"  class="nar" id="prodCnt2" onfocus="this.blur();" readonly>
	                        <input type="hidden" id="itemCd2">
	                        <input type="hidden" id="processSeq2">
	                    </div>
	                    <div class="popup_grid">
	                        <div class="state">
	                            <span><i class="mark fin"></i>충분</span>
	                            <span><i class="mark yet"></i>부족</span>
	                        </div>
	                        <div class="grid_wrap">
	                        	<div id="partPresentGrid2" ></div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </form>
        </div>
        <!-- 필요자재 팝업 영역 끝 -->
</body>
</html>