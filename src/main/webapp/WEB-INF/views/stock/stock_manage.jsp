<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

<script type="text/javascript">
var stockView;
var stockGridPager;
var stockGrid;
var stockColumns;
var stockSelector;

var categoryGrid;
var categoryView;
var categoryGridPager;
var categorySelector;
var categoryColumns;

var categoryGrid;
var categoryView;
var categoryGridPager;
var categorySelector;
var categoryColumns;

var partTopGrid;
var partTopView;
var partTopColumns;

var partBottomGrid;
var partBottomView;
var partBottomColumns;

var addGrid;
var editGrid;
var editGridView;

var partExcelGrid;
var partExcelView;
var partExcelSelector;

var excelGrid;
var excelView;
var excelSelector;

var add = false;
var dupCheckItemFlag = false;
var categorySelectCnt = 0;
var typeCdList;

var memberId = "<%=session.getAttribute("id")%>";
var memberAuth = "<%=session.getAttribute("auth")%>";


function pageLoad(){
	sessionCheck(memberId, memberAuth, 'stock');
	
	$('#stock_manage').addClass("current");
	$(".excelDiv").hide();
    $(".stockDiv").show();
	
	loadGridList('init');
	getTotalItemCnt();
}

function enterkey(type) {
    if (window.event.keyCode == 13) {
    	if(type == 'pop'){
    		getPartList();
    		
    	}else{
    		getStockManageList();
    	}
    }
}

//그리드 초기 셋팅
function loadGridList(type, result){
    if(type == "init"){
        $("#excelDiv").hide();
        stockView = new wijmo.collections.CollectionView(result, {
            pageSize: 100,
            trackChanges: true
        });
		// 페이지 이동
        stockGridPager = new wijmo.input.CollectionViewNavigator('#stockGridPager', {
            byPage: true,
            headerFormat: '{currentPage:n0} / {pageCount:n0}',
            cv: stockView
        });

        stockColumns =  [
                { binding: 'name', header: '명칭', isReadOnly: false, width: 150, align:"center"},
                { isReadOnly: true, width: 35, align:"center"},
                { binding: 'id', header: '코드', isReadOnly: true, width: 150 },
                { binding: 'level', header: '레벨', isReadOnly: true, visible: false  },
                { binding: 'typeCd', header: '분류', isReadOnly: true, width: 100 , visible: false },
                { binding: 'cost', header: '원가', isReadOnly: true, width: 100, align:"center"  },
                { binding: 'sellPrice', header: '판매가', isReadOnly: false, width: 100, align:"center"  },
                { binding: 'tagQuantity', header: '재고알림수량', isReadOnly: false, width: 150, align:"center"},
                { binding: 'activeYn', header: '활성화', isReadOnly: false, dataType:3 , width: 60, align:"center"},
                { binding: 'edit', header: '파트정보', isReadOnly: true, width: 150, align:"center",
                    cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
                        text: '<b>수정</b>',
                        click: (e, ctx) => {
                            showPop('info_part',e, ctx);
                        }
                        
                    })
                }
  		    ];
		  
        stockGrid = new wijmo.grid.FlexGrid('#stockGrid', {
        	columns : stockColumns,
            itemsSource: stockView,
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
	                if (col.binding == 'edit' ) {
	                    //셀 서식
	                    var html;
	                    var level = s.getCellData(e.row, 'level');
	                    var typeCd = s.getCellData(e.row, 'typeCd');

	                   if(level != 3 || (level == 3 && typeCd != '2' && typeCd != '4')){
	                	   console.log(typeCd);
	                	   html = '';
		                   e.cell.textContent = html;           	
	                    }       
	                }
	            }
		      },
            loadedRows: function (s, e) {
                s.rows.forEach(function (row) {
                    row.isReadOnly = false;
                });
            },
            cellEditEnding: function (s, e) {
                var col = s.columns[e.col];
                var inven = s.columns[e.col - 1];
                var level = s.getCellData(e.row, 'level');
                if(level != 3){
                	e.cancel = true;
                    e.stayInEditMode = false;
                    alert('물품 정보만 수정이 가능합니다.');
                    return false;
                    
                 }else if (col.binding == 'cost' || col.binding == 'sellPrice' || col.binding == 'tagQuantity') {
                    var value = wijmo.changeType(s.activeEditor.value, wijmo.DataType.Number, col.format);
                    if( !wijmo.isNumber(value)){
                        e.cancel = true;
                        e.stayInEditMode = false;
                        alert('숫자로만 입력 가능합니다.');
                        return false;
                    }
                } 
                
                let oldValue = e.data;
                let newValue = s.getCellData(e.row, e.col);
                
                if(oldValue !== newValue){
                	markAsEdited(s, e.getRow().dataItem);
                }
            }
        });

       _setUserGridLayout('stockLayout', stockGrid, stockColumns);

        //행번호 표시하기
         stockGrid.itemFormatter = function (panel, r, c, cell) { 
            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
                cell.textContent = (r + 1).toString();
            }
        }; 

        // 체크박스 생성
         stockSelector = new wijmo.grid.selector.Selector(stockGrid, {
            itemChecked: () => {
            }
        });
        stockSelector.column = stockGrid.columns[1];
 
 
        
        //***********************카테고리 추가용 그리드 설정
        categoryView = new wijmo.collections.CollectionView(result, {});
        
        typeCdList = new wijmo.grid.DataMap(getTypeCdList(), 'id', 'name');
        categoryGrid = new wijmo.grid.FlexGrid('#categoryGrid', {
            autoGenerateColumns: false,
            alternatingRowStep: 0,
            columns: [
            	{ isReadOnly: true, width: 35, align:"center"},
            	{ binding: 'typeCd', header: '분류', isReadOnly: false, width: 100, align:"center", dataMap: typeCdList, dataMapEditor: 'DropDownList' },
                { binding: 'lCategyNm', header: '대카테고리명', isReadOnly: false, width: 100, align:"center"},
                { binding: 'lCategyCd', header: '대카테고리코드', isReadOnly: false, width: 100, align:"center"},
                { binding: 'mCategyNm', header: '중카테고리명', isReadOnly: false, width: 100, align:"center"},
                { binding: 'mCategyCd', header: '중카테고리코드', isReadOnly: false, width: 100, align:"center"},
                { binding: 'cretDt', header: '등록일시', isReadOnly: true, width: 150, align:"center"  }
            ],
            beginningEdit: function (s, e) {
                var col = s.columns[e.col];
                var item = s.rows[e.row].dataItem;
                if(item.cretDt != undefined){
                    if (col.binding == 'lCategyCd' || col.binding == 'mCategyCd') {
                        e.cancel = true;
                        alert("카테고리코드는 신규 행일때만 입력 가능합니다.");
                    }
                }
            },
            cellEditEnding: function (s, e) {
                var col = s.columns[e.col];
                if (col.binding == 'lCategyCd' || col.binding == 'mCategyCd') {
                    var value = wijmo.changeType(s.activeEditor.value, wijmo.DataType.String, col.format);
                    if (value.length != 3) {
                        e.cancel = true;
                        alert('카테고리코드는 3자리 입니다.');
                        return false;
                    }
                    value = wijmo.changeType(s.activeEditor.value, wijmo.DataType.Number, col.format);
                    if( !wijmo.isNumber(value) || value < 0){
                        e.cancel = true;
                        alert('카테고리코드는 숫자로만 입력 가능합니다.');
                        return false;
                    }
                }
            },
            itemsSource: categoryView,
        });
        categorySelector = new wijmo.grid.selector.Selector(categoryGrid);
        categorySelector.column = categoryGrid.columns[0];
        
      //행번호 표시하기
        categoryGrid.itemFormatter = function (panel, r, c, cell) { 
           if (panel.cellType == wijmo.grid.CellType.RowHeader) {
               cell.textContent = (r + 1).toString();
           }
       }; 
        
        editGrid = new wijmo.grid.FlexGrid('#editGrid', {
            itemsSource: categoryView.itemsEdited,
            isReadOnly: true
        });
        
        
        
        //************************ 파트 팝업 상단 그리드
        partTopView = new wijmo.collections.CollectionView(result, {});
        partTopGrid = new wijmo.grid.FlexGrid('#partTopGrid', {
            autoGenerateColumns: false,
            alternatingRowStep: 0,
            columns: [
            	{ binding: 'lCategyNm', header: '대카테고리명', isReadOnly: true, width: 100, align:"center"},
                { binding: 'mCategyNm', header: '중카테고리명', isReadOnly: true, width: 100, align:"center"},
                { binding: 'partNm', header: '품명', isReadOnly: true, width: 100, align:"center"},
                { binding: 'partCd', header: '품목코드', isReadOnly: true, width: 100, align:"center"},
                { binding: 'unit', header: '단위', isReadOnly: true, width: 100, align:"center"},
                { binding: 'cost', header: '원가', isReadOnly: true, width: 100, align:"center"}
            ],
            itemsSource: partTopView
        });
        
        partTopGrid.itemFormatter = function (panel, r, c, cell) { 
           if (panel.cellType == wijmo.grid.CellType.RowHeader) {
               cell.textContent = (r + 1).toString();
           }
       }; 
        
        ////************************ 파트 팝업 하단 그리드
        partBottomView = new wijmo.collections.CollectionView(result, {});
        partBottomGrid = new wijmo.grid.FlexGrid('#partBottomGrid', {
            autoGenerateColumns: false,
            alternatingRowStep: 0,
            allowDelete: true,
            columns: [
            	{ binding: 'itemPartSeq', header: 'seq', isReadOnly: true, width: 100, align:"center", visible: false},
            	{ binding: 'lCategyNm', header: '대카테고리명', isReadOnly: true, width: 100, align:"center"},
                { binding: 'mCategyNm', header: '중카테고리명', isReadOnly: true, width: 100, align:"center"},
                { binding: 'itemCd', header: '제품코드', isReadOnly: true, width: 100, align:"center", visible: false},
                { binding: 'partNm', header: '품명', isReadOnly: true, width: 100, align:"center"},
                { binding: 'partCd', header: '품목코드', isReadOnly: true, width: 100, align:"center"},
                { binding: 'unit', header: '단위', isReadOnly: true, width: 100, align:"center"},
                { binding: 'cost', header: '원가', isReadOnly: true, width: 100, align:"center"},
                { binding: 'partQuantity', header: '파트수량', isReadOnly: false, width: 100, align:"center"}
            ],
            cellEditEnding: function (s, e) {
                var col = s.columns[e.col];
                var inven = s.columns[e.col - 1];
                if (col.binding == 'partQuantity') {
                    var value = wijmo.changeType(s.activeEditor.value, wijmo.DataType.Number, col.format);
                    if( !wijmo.isNumber(value)){
                        e.cancel = true;
                        e.stayInEditMode = false;
                        alert('숫자로만 입력 가능합니다.');
                        return false;
                    }
                } 
            },
            itemsSource: partBottomView
        });
        
        partBottomGrid.itemFormatter = function (panel, r, c, cell) { 
            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
                cell.textContent = (r + 1).toString();
            }
        }; 
        
        
		///////////////////// 물품엑셀업로드 그리드
        excelGrid = new wijmo.grid.FlexGrid('#excelGrid', {
            autoGenerateColumns: false,
            alternatingRowStep: 0,
            columns : stockColumns,
            itemsSource: excelView
        });

        excelGrid.itemFormatter = function (panel, r, c, cell) { 
            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
                cell.textContent = (r + 1).toString();
            }
        };
        
        //////////////////////////파트설정 엑셀업로드 그리드
        partExcelGrid = new wijmo.grid.FlexGrid('#partExcelGrid', {
            autoGenerateColumns: false,
            alternatingRowStep: 0,
            columns : stockColumns,
            itemsSource: partExcelView
        });

        partExcelGrid.itemFormatter = function (panel, r, c, cell) { 
            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
                cell.textContent = (r + 1).toString();
            }
        };
        
    }else if(type == "category"){
        categoryView = new wijmo.collections.CollectionView(result, {
            trackChanges: true
        });
        categoryGrid.itemsSource = categoryView;
        
	}else if(type == "partTop"){
		partTopView = new wijmo.collections.CollectionView(result, {
            trackChanges: true
        });
		partTopGrid.itemsSource = partTopView;
        
	}else if(type == "partBottom"){
		partBottomView = new wijmo.collections.CollectionView(result, {
            trackChanges: true
        });
		partBottomGrid.itemsSource = partBottomView;
		
	}else{
        stockView = new wijmo.collections.CollectionView(result, {
            pageSize: Number($('#stockGridPageCount').val()),
            trackChanges: true
        });
        stockGrid.columns[1].width = 32;
        stockGridPager.cv = stockView;
        stockGrid.itemsSource = stockView;
	  }
      refreshPaging(stockGrid.collectionView.totalItemCount, 1, stockGrid, 'stockGrid');
      refreshPaging(categoryGrid.collectionView.totalItemCount, 1, categoryGrid, 'categoryGrid');
}

function markAsEdited(grid, item){
	let existionItem = grid.collectionView.itemsEdited.find(
		(_item) => _item === item
	);
	if(!existionItem){
		grid.collectionView.itemsEdited.push(item);
	}
}

//코드 검색
function getStockManageList(){
    $(".excelDiv").hide();
    $(".stockDiv").show();
    var params = {
            inq : $("#inq").val(),
            con : $("#con").val(),
            typeCd : $("#typeCd").val()
            
    	}
    	$.ajax({
            url : "/stock/getStockManageList",
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
                			itemOb.typeCd = result[i].typeCd;
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
            	    getTotalItemCnt();
            	}
            },
            error : function(request,status,error) {
             	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
          });
}

function getTotalItemCnt(){
	$.ajax({
	      type : 'POST',
	      url : '/stock/getTotalItemCnt',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      success : function(result) {
	      	$("#totalItemCnt").text(Number(result).toLocaleString('ko-KR')+ "개");
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      }
	  });
}

function getCategyList(){
     $.ajax({
            url : "/stock/getCategoryList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            success : function(result) {
        	    loadGridList('category', result);

            },
            error : function(request,status,error) {
             	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
          });
}

function getPartList(type){
	 var params = {
			 itemCd : $("#itemCd_pop2").val(),
			 partNm : $("#partNm_pop2").val()
	    	}
	 
	 if($("#itemCd_pop2").val() == 'all' || $("#itemCd_pop2").val() == ''){
		 params = {
				 itemCd : 'X',
				 partNm : 'X'
		    	}
		 
		 if(type != 'init'){
			 alert("물품을 선택해주시기 바랍니다.");
		 }
	 }
	 
	 $.ajax({
         url : "/stock/getPartName",
         async : false, // 비동기모드 : true, 동기식모드 : false
         type : 'POST',
         data : params,
         success : function(result) {
        	 console.log(result);
     	    if(result.length > 0){
     	    	$("#partNm_pop2").val(result[0].itemNm);
     	    	
     	    	console.log("result[0].itemNm : "+result[0].itemNm);
     	    }

         },
         error : function(request,status,error) {
          	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
         }
       });
	 
	  /* 파트 : 제품 , 파트:판재는 n:1관계로 통일한 파트는 각각다른 제품 혹은 판재에 등록되면 안되므로 현재 파트를 등록하려는 물품의 typeCd를 확인하여
		해당 타입에서 사용하지 않은 파트를 파트추가가능 대상으로 조회 함. */
	 //상단 리스트
    $.ajax({
           url : "/stock/getPartFullList",
           async : false, // 비동기모드 : true, 동기식모드 : false
           type : 'POST',
           data : params,
           success : function(result) {
       	    loadGridList('partTop', result);
       	    
           },
           error : function(request,status,error) {
            	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
           }
         });
	 
  	//하단 리스트
    $.ajax({
           url : "/stock/getPartList",
           async : false, // 비동기모드 : true, 동기식모드 : false
           type : 'POST',
           data : params,
           success : function(result) {
       	    loadGridList('partBottom', result);

           },
           error : function(request,status,error) {
            	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
           }
         });
}


//팝업 오픈
function showPop(pop, e, ctx){
	if(pop == "add_category"){
        getCategyList();
        
	}else if(pop == "add_goods"){
        $('#lCategoryCd').empty().append('<option selected="selected" value="all" selected>전체</option>');
         $('#mCategoryCd').empty().append('<option selected="selected" value="all" selected>전체</option>'); 
        
        $("#typeCd_pop").val("1");
        $("#lCategoryCd").val("all");
        $("#mCategoryCd").val("all");
        $("#itemNm").val("");
        $("#itemCd").val("");
        $("#unit").val("");
        $("#cost").val("");
        $("#sell_price").val("");
        $("#tag_quantity").val("");
        
        getLCategoryDtl();
        
	}else if(pop == "set_part"){
		$("#partExcelDiv").hide();
		$("#partAddDiv").show();
		
		$('#trTypeCd_pop2').show(); 
		$('#trLCategyCd_pop2').show(); 
		$('#trMCategyCd_pop2').show(); 
		$('#setPartBtn').show(); 
		$('#infoPartBtn').hide(); 
		
		$('#lCategyCd_pop2').empty().append('<option selected="selected" value="all" selected>전체</option>');
        $('#mCategyCd_pop2').empty().append('<option selected="selected" value="all" selected>전체</option>'); 
        $('#itemCd_pop2').empty().append('<option selected="selected" value="all" selected>전체</option>'); 
       
       $("#itemCd_pop2").attr("disabled", false); 
       $("#typeCd_pop2").val("all");
       $("#lCategyCd_pop2").val("all");
       $("#mCategyCd_pop2").val("all");
       $("#itemCd_pop2").val("all");
       $("#partNm_pop2").val("");
       
		
		getPartList('init');
		getLCategoryDtl('set_part');
		
	}else if(pop == "info_part"){
		pop = "set_part";
		
		$("#partExcelDiv").hide();
		$("#partAddDiv").show();
		
		$('#trTypeCd_pop2').hide(); 
		$('#trLCategyCd_pop2').hide(); 
		$('#trMCategyCd_pop2').hide(); 
		$('#setPartBtn').hide(); 
		$('#infoPartBtn').show();
		
		$('#lCategyCd_pop2').empty().append('<option selected="selected" value="all" selected>전체</option>');
        $('#mCategyCd_pop2').empty().append('<option selected="selected" value="all" selected>전체</option>'); 
        $('#itemCd_pop2').empty().append('<option selected="selected" value="all" selected>전체</option>'); 
       
       getLCategoryDtl('set_part');
       $("#typeCd_pop2").val("all");
       $("#lCategyCd_pop2").val("all");
       $("#mCategyCd_pop2").val("all");
       $("#partNm_pop2").val("");
       $("#itemCd_pop2").attr("disabled", true);
		$("#itemCd_pop2").val(ctx.item["id"]);
		
		getPartList();
		
	}
	 $('#'+pop).addClass('is_on');
    
}

//팝업 종료
function closePop(){
	$('.popup').removeClass('is_on');
    add = false;
    categoryGrid.allowAddNew = add;
    categorySelectCnt = 0;
}
// 행추가
function addRow(type){
    add = true;
    if(type == 'category'){
        categoryGrid.allowAddNew = add;
    }
}

//행 삭제
function deleteRows(type){
    if(type == 'stock'){
        var item = stockGrid.rows.filter(r => r.isSelected); 
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
                    url : "/stock/deleteItem",
                    async : false, // 비동기모드 : true, 동기식모드 : false
                    type : 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(rows),
                    success : function(result) {
                        alert("삭제되었습니다.");
                        getStockManageList();
                    },
                    error : function(request,status,error) {
                        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                    }
                });
            }
        }
    }else if(type == 'category'){
        var item = categoryGrid.rows.filter(r => r.isSelected);
        var rows = [];
        var params;
         if(item.length == 0){
            alert("선택된 행이 없습니다.");
            return false;
        }else{
            for(var i =0; i< item.length ; i++){
                rows.push(item[i].dataItem);
            }
            if(confirm("선택한 행들을 삭제 하시겠습니까??")){
                $.ajax({
                    url : "/stock/deleteCategory",
                    async : false, // 비동기모드 : true, 동기식모드 : false
                    type : 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(rows),
                    success : function(result) {
                        alert("삭제되었습니다.");
                        getCategyList();
                    },
                    error : function(request,status,error) {
                        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                    }
                });
            }
        }
    }   
}

// 카테고리 동적으로 가져오기
function getLCategoryDtl(type) {
	var id;
	var params;
	if(type == 'set_part'){
		id = 'lCategyCd_pop2';
		params = {
			typeCd : ($("#typeCd_pop2").val() == 'all' ? 'part' : $("#typeCd_pop2").val() )
    	}
	}else {
		id = 'lCategyCd';
		params = {
			typeCd : $("#typeCd_pop").val()
    	}
	}
	console.log($("#typeCd_pop2").val());
	console.log(params);
	
    $.ajax({
            url : "/stock/getLCategoryList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            data : params,
            success : function(result) {
                if(result.length > 0){
                	$('#'+id).empty().append('<option selected="selected" value="all" selected>전체</option>');
                    for(var i =0; i<result.length; i++)
                        $('#'+id).append("<option value='" + result[i].lCategyCd + "'>" + result[i].lCategyNm + "</option>");
                    
                }else{
                	$('#'+id).empty().append('<option selected="selected" value="all" selected>전체</option>');
                }
                
                getMCategoryDtl(type);
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
    });
}

//카테고리 동적으로 가져오기
function getMCategoryDtl(type) {
	var id;
	var params;
	if(type == 'set_part'){
		id = 'mCategyCd_pop2';
		params = {
			typeCd : ($("#typeCd_pop2").val() == 'all' ? 'part' : $("#typeCd_pop2").val() ),
			lCategyCd : $("#lCategyCd_pop2").val()
    	}
	}else {
		id = 'mCategyCd';
		params = {
			typeCd : $("#typeCd_pop").val(),
			lCategyCd : $("#lCategyCd").val()
    	}
	}

	
    $.ajax({
            url : "/stock/getMCategoryList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            data : params,
            success : function(result) {
            	if(result.length > 0){
                	$('#'+id).empty().append('<option selected="selected" value="all" selected>전체</option>'); 
                    for(var i =0; i<result.length; i++)
                        $("#"+id).append("<option value='" + result[i].mCategyCd + "'>" + result[i].mCategyNm + "</option>");
                    
                }else{
                	$('#'+id).empty().append('<option selected="selected" value="all" selected>전체</option>'); 
                	
                }
                
            	if(type == 'set_part') getItemDtl();
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
    });
}

//물품 동적으로 가져오기
function getItemDtl() {
	var params = {
			typeCd : ($("#typeCd_pop2").val() == 'all' ? 'part' : $("#typeCd_pop2").val() ),
			lCategyCd : $("#lCategyCd_pop2").val(),
			mCategyCd : $("#mCategyCd_pop2").val()
    	}

    $.ajax({
            url : "/stock/getItemList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            data : params,
            success : function(result) {
                if(result.length > 0){
                	$('#itemCd_pop2').empty().append('<option selected="selected" value="all" selected>전체</option>'); 
                    for(var i =0; i<result.length; i++)
                        $("#itemCd_pop2").append("<option value='" + result[i].itemCd + "'>" + result[i].itemNm + "</option>");
                    
                }else{
                	$('#itemCd_pop2').empty().append('<option selected="selected" value="all" selected>전체</option>'); 
                	
                }
                
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
    });
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
            	
            	console.log(result);
            	
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

    
//데이터 저장
function saveGrid(type){
	var saveFlag = true;
    if(sessionCheck(memberId, memberAuth, 'stock')){
        if(type == "category"){
            var editItem = categoryView.itemsEdited;
            var addItem  = categoryView.itemsAdded;
            var addRows = [];
        	var editRows = [];
            var rows = [];
            
            for(var i =0; i< editItem.length ; i++){
            	if(!saveVal(type, editItem[i])) return false;
            	editRows.push(editItem[i]);
                rows.push(editItem[i]);
            }
            for(var i=0; i< addItem.length; i++){
            	if(!saveVal(type, addItem[i])) return false;
            	if(dupCategoryChk(addItem[i])) return false;
            	addRows.push(addItem[i]);
                rows.push(addItem[i]);
            }

            wijmo.Control.getControl("#editGrid").refresh(true);
            if(confirm("변경한 내용을 저장 하시겠습니까??")){
                $.ajax({
                    url : "/stock/saveCategory",
                    async : false, // 비동기모드 : true, 동기식모드 : false
                    type : 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(addRows),
                    success : function(result) {
                    	updateCategory(editRows);
                    },
                    error : function(request,status,error) {
                        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                    }
                });
            }
        }else if(type == 'stock'){
            if(stockView.itemCount > 0){
                var editItem = stockView.itemsEdited;
                var rows = [];
                
                console.log(stockView);
                console.log(editItem);
                for(var i =0; i< editItem.length ; i++){
                	if(!saveVal(type, editItem[i])) return false;
                    rows.push(editItem[i]);
                }
                wijmo.Control.getControl("#editGrid").refresh(true);
                if(confirm("저장 하시겠습니까??")){
                    $.ajax({
                        url : "/stock/saveItem",
                        async : false, // 비동기모드 : true, 동기식모드 : false
                        type : 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify(rows),
                        success : function(result) {
                            alert("저장되었습니다.");
                            getStockManageList();
                        },
                        error : function(request,status,error) {
                            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                        }
                    });
                }
            }else{ // 엑셀 업로드 저장하기
                var item  = excelGrid.rows;
                var rows = [];
                var params;
                for(var i=0; i< item.length; i++){
                    var value = wijmo.changeType(excelGrid.collectionView.items[i].원가, wijmo.DataType.Number, null);
                    if(!wijmo.isNumber(value) && (excelGrid.collectionView.items[i].물품명 != undefined && excelGrid.collectionView.items[i].물품코드 != undefined)){
                        alert("원가는 숫자만 입력 가능합니다.");
                        return false;
                    }
                    if(excelGrid.collectionView.items[i].원가 != undefined && excelGrid.collectionView.items[i].물품명 != undefined && excelGrid.collectionView.items[i].물품코드 != undefined){
                        params={
                            lCategyCd :  excelGrid.collectionView.items[i].물품코드.substring(0,3),
                            itemCd : excelGrid.collectionView.items[i].물품코드,
                            itemNm : excelGrid.collectionView.items[i].물품명,
                            cost : excelGrid.collectionView.items[i].원가
                        }
                        rows.push(params);
                    }
                    
                }
                if(confirm("저장 하시겠습니까??")){
                    $.ajax({
                        url : "/stock/saveItem",
                        async : false, // 비동기모드 : true, 동기식모드 : false
                        type : 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify(rows),
                        success : function(result) {
                            alert("총 " + result + "건이 저장되었습니다.");
                            getStockManageList();
                        },
                        error : function(request,status,error) {
                            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                        }
                    });
                }
            }
            
        }else if(type == "partBottom"){
        	if($("#itemCd_pop2").val() == 'all' || $("#itemCd_pop2").val() == ''){
        		alert("물품을 선택해주시기 바랍니다.");
        		return false;
	       	 }
	        	
            var addItem  = partBottomView.itemsAdded;
            var editItem = partBottomView.itemsEdited;
            var removeItem  = partBottomView.itemsRemoved;
            
            console.log(addItem);
            console.log(editItem);
            console.log(removeItem);
            
            var addRows = [];
            var editRows = [];
            var removeRows = [];
            
            for(var i =0; i< addItem.length ; i++){
            	if(!saveVal(type, addItem[i])) return false;
            	addRows.push(addItem[i]);
            }
            for(var i=0; i< editItem.length; i++){
            	if(!saveVal(type, editItem[i])) return false;
            	editRows.push(editItem[i]);
            }
            for(var i =0; i< removeItem.length ; i++){
            	removeRows.push(removeItem[i]);
            }

            if(confirm("변경한 내용을 저장 하시겠습니까??")){
                $.ajax({
                    url : "/stock/savePart",
                    async : false, // 비동기모드 : true, 동기식모드 : false
                    type : 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(addRows),
                    success : function(result) {
                    	updatePartGrid(editRows, removeRows);
                    },
                    error : function(request,status,error) {
                        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                    }
                });
            }
        }else if(type == 'excel'){
        	var item  = excelGrid.rows;
            var rows = [];
            var params;
            
            for(var i=0; i< item.length; i++){
                var value = wijmo.changeType(excelGrid.collectionView.items[i].원가, wijmo.DataType.Number, null);
                if(!wijmo.isNumber(value)){
                    alert("원가는 숫자만 입력 가능합니다.");
                    return false;
                }
                
                var value = wijmo.changeType(excelGrid.collectionView.items[i].판매가, wijmo.DataType.Number, null);
                if(!wijmo.isNumber(value)){
                    alert("판매가는 숫자만 입력 가능합니다.");
                    return false;
                }
                
                var value = wijmo.changeType(excelGrid.collectionView.items[i].재고알림수량, wijmo.DataType.Number, null);
                if(!wijmo.isNumber(value)){
                    alert("재고알림수량은 숫자만 입력 가능합니다.");
                    return false;
                }
                
                params={
                	itemCd : excelGrid.collectionView.items[i].물품코드
	               	, itemNm : excelGrid.collectionView.items[i].물품명
	               	, unit : excelGrid.collectionView.items[i].단위
	               	, cost : excelGrid.collectionView.items[i].원가
	               	, sellPrice : excelGrid.collectionView.items[i].판매가
	               	, tagQuantity : excelGrid.collectionView.items[i].재고알림수량
                }
                rows.push(params);
            }
            if(confirm("저장 하시겠습니까?")){
                $.ajax({
                    url : "/stock/saveExcelGrid",
                    async : false, // 비동기모드 : true, 동기식모드 : false
                    type : 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(rows),
                    success : function(result) {
                        alert(result);
                        getStockManageList();
                    },
                    error : function(request,status,error) {
                        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                    }
                });
            }
        	
        }else if(type == 'partExcel'){
        	var item  = partExcelGrid.rows;
            var rows = [];
            var params;
            
            for(var i=0; i< item.length; i++){
           	 	var value = wijmo.changeType(partExcelGrid.collectionView.items[i].파트수량, wijmo.DataType.Number, null);
                if(!wijmo.isNumber(value)){
                    alert("파트수량은 숫자만 입력 가능합니다.");
                    return false;
                }
                
                params={
                	itemCd : partExcelGrid.collectionView.items[i].물품코드
	               	 , partCd : partExcelGrid.collectionView.items[i].품목코드
	               	 , partQuantity : partExcelGrid.collectionView.items[i].파트수량
                }
                rows.push(params);
            }
            if(confirm("저장 하시겠습니까?")){
                $.ajax({
                    url : "/stock/savePartExcelGrid",
                    async : false, // 비동기모드 : true, 동기식모드 : false
                    type : 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(rows),
                    success : function(result) {
                        alert(result);
                        closePop('set_part');
                    },
                    error : function(request,status,error) {
                        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                    }
                });
            }
        }
    }
}

function updateCategory(editRows){
	$.ajax({
        url : "/stock/updateCategory",
        async : false, // 비동기모드 : true, 동기식모드 : false
        type : 'POST',
        contentType: 'application/json',
        data: JSON.stringify(editRows),
        success : function(result) {
        	console.log('updateCategory');
            alert("저장되었습니다.");
            getCategyList();
        },
        error : function(request,status,error) {
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
}


function updatePartGrid(editRows, removeRows){
	$.ajax({
        url : "/stock/updatePart",
        async : false, // 비동기모드 : true, 동기식모드 : false
        type : 'POST',
        contentType: 'application/json',
        data: JSON.stringify(editRows),
        success : function(result) {
        	removePartGrid(removeRows);
        },
        error : function(request,status,error) {
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
}

function removePartGrid(removeRows){
	$.ajax({
        url : "/stock/deletePart",
        async : false, // 비동기모드 : true, 동기식모드 : false
        type : 'POST',
        contentType: 'application/json',
        data: JSON.stringify(removeRows),
        success : function(result) {
        	alert("저장되었습니다.");
        	getPartList();
        },
        error : function(request,status,error) {
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
}

function dupCategoryChk(item){
	console.log(item);
	var returnVal;
	var params = {
			typeCd : item.typeCd,
            lCategyCd : item.lCategyCd,
            mCategyCd : item.mCategyCd
        };
        $.ajax({
            url : "/stock/dupCategoryChk",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            data : params,
            success : function(result) {
            		if(result.length > 0){
            			alert("중복 카테고리코드가 존재합니다. ( "+ result[0].lCategyNm+ " - "+ result[0].mCategyNm +" )");
            			returnVal = true;
            		}else{
            			returnVal = false;
            		}
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                returnVal = true;
            }
        });
        
        return returnVal;
}

function saveVal(type, item){
	if(type == "category"){
		if(item.typeCd == '' || item.typeCd == undefined ){
            alert("분류를 입력해주세요.");
            return false;
            
        }else if(item.lCategyCd == '' || item.lCategyCd == undefined ){
            alert("대카테고리코드를 입력해주세요.");
            return false;
            
        }else if(item.lCategyNm == '' || item.lCategyNm == undefined){
            alert("대카테고리명을 입력해주세요.");
            return false;
            
        }else if(item.mCategyCd == '' || item.mCategyCd == undefined){
            alert("중카테고리코드를 입력해주세요.");
            return false;
            
        }else if(item.mCategyNm == '' || item.lCategyNm == undefined){
            alert("중카테고리명을 입력해주세요.");
            return false;
        }
		
	}else if(type == "stock"){
		if(item.cost == '' || item.cost == undefined ){
            alert("원가를 입력해주세요.");
            return false;
            
        }else if(item.sellPrice == '' || item.sellPrice == undefined ){
            alert("판매가를 입력해주세요.");
            return false;
            
        }else if(item.tagQuantity == '' || item.tagQuantity == undefined ){
            alert("재고알림수량을 입력해주세요.");
            return false;
            
        }
		
	}else if(type == "partBottom"){
		if(item.partQuantity == '' || item.partQuantity == undefined ){
            alert("파트수량을 입력해주세요.");
            return false;
            
        }
	}
	
	return true;
	
}

//물품 추가하기
function addItem(){
	if($("#typeCd_pop").val() == ""){
		alert("분류를 선택하시기 바랍니다.");
        return false;
        
	}else if($("#lCategyCd").val() == "all"){
		alert("대카테고리를 선택하시기 바랍니다.");
        return false;
        
	}else if($("#mCategyCd").val() == "all"){
		alert("중카테고리를 선택하시기 바랍니다.");
        return false;
        
	}else if($("#itemNm").val() == ""){
		alert("품명를 입력하시기 바랍니다.");
        return false;
        
	}else if($("#unit").val() == ""){
		alert("상품단위를 입력하시기 바랍니다.");
        return false;
        
	}else if($("#cost").val() == ""){
		alert("원가를 입력하시기 바랍니다.");
        return false;
        
	}else if($("#tagQuantity").val() == ""){
		alert("재고알림수량을 입력하시기 바랍니다.");
        return false;
        
	}
	
	var params = {
			typeCd : $("#typeCd_pop").val(),
            lCategyCd : $("#lCategyCd").val(),
            mCategyCd : $("#mCategyCd").val(),
            itemNm : $("#itemNm").val(),
            unit : $("#unit").val(),
            cost : $("#cost").val(),
            sellPrice : $("#sellPrice").val(),
            tagQuantity : $("#tagQuantity").val()
        };
        $.ajax({
            url : "/stock/addItem",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            contentType: 'application/json',
            data: JSON.stringify(params),
            success : function(result) {
                    alert("등록 되었습니다.");
                    closePop();
                    getStockManageList();
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
}
//엑셀 다운로드
function exportExcel(){
	
	var gridView = stockGrid.collectionView;
	var oldPgSize = gridView.pageSize;
	var oldPgIndex = gridView.pageIndex;

    //전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
    stockGrid.beginUpdate();
    stockView.pageSize = 0;

    wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(stockGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'stockList.xlsx',
	      saved => {
	    	gridView.pageSize = oldPgSize;
	    	gridView.moveToPage(oldPgIndex);
	    	bldgGrid.endUpdate();
	      }, null
	 );
}

function popStockQrList(){
	var item = stockGrid.rows.filter(r => r.isSelected);
	var selectStock;
	
	console.log(item);
	
	if(item.length == 0){
        alert("선택된 행이 없습니다.");
        return false;
    }else{
    	selectStock = item[0].dataItem.id;
    	for(var i =1; i< item.length ; i++){
    		selectStock += ','+item[i].dataItem.id;
        }
    	
    	var win = window.open("/stock/getStockQrList?selectStock="+selectStock, "PopupWin", "width=1000,height=600");

    }

}


function getError(item,prop){
    if( prop == "lCategyCd"){
        const curDong = item[prop];
        const src = categoryView.sourceCollection;
        let allSameDong = src.filter((c)=>c.lCategyCd == curDong);
        if(allSameDong.length > 1){
            alert("동일한 카테고리코드가 존재합니다.");
            return "동일한 카테고리코드가 존재합니다.";
        }
        return "";
    }
}

function removePart(){
	partBottomView.remove(partBottomView.currentItem);
	//console.log(partBottomGrid.collectionView.itemsRemoved);
	
}

function addPart(){
	//선택 된 상단 그리드
	let item = partTopGrid.collectionView.currentItem;
	
	//하단 그리드 추가 내역에 현재 추가하려는 내역이 있는지 확인
    let existionItem = partBottomGrid.collectionView.itemsAdded.filter(
    		addItem => addItem.partCd == item.partCd
   	);
	
	//추가 내역에 동일한 항목이 없으면 데이터 추가 및 커밋 
    if( existionItem.length == 0){
		//하단 그리드 라인추가
	    partBottomGrid.collectionView.addNew();
	    //하단 그리드 추가 된 라인 추출 및 데이터 적재
		let cur = partBottomGrid.collectionView.currentItem;
	
		cur.itemCd = $("#itemCd_pop2").val();
	    cur.lCategyNm = item.lCategyNm;
	    cur.mCategyNm = item.mCategyNm;
	    cur.partNm = item.partNm;
	    cur.partCd = item.partCd;
	    cur.unit = item.unit;
	    cur.cost = item.cost;
	
   		partBottomGrid.collectionView.commitEdit();
   	    partBottomGrid.collectionView.commitNew();
   	    
   	}else{
   		alert("기 추가 된 항목입니다.");
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
function findFile(type){
	if(type == 'part'){
		$("#partImportFile").val("");
	    document.all.partImportFile.click();
	    
	}else{
		$("#importFile").val("");
	    document.all.importFile.click();	
	}
}

//엑셀 업로드
function importExcel(type){
	if(type == 'part'){
		$("#partExcelDiv").show();
		$("#partAddDiv").hide();

	     var inputEle =  document.querySelector('#partImportFile');
	     if (inputEle.files[0]) {
	        wijmo.grid.xlsx.FlexGridXlsxConverter.loadAsync(partExcelGrid, inputEle.files[0],{includeColumnHeaders: true}, (w) => {
	        // 데이터 바인딩할 함수 호출
	        bindImportedDataIntoModel(partExcelGrid);
	        partExcelGrid.columns.forEach(col => {
	          col.width = 180,
	          col.align = "center",
	          col.dataType = 1
	        })
	      });
	    }
	        
	}else {
		$(".excelDiv").show();
		$(".stockDiv").hide();

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
}

function downTemplate(type){
    if(type == 'part'){
    	window.location.assign("<%=request.getContextPath()%>" + "/template/파트설정양식.xlsx");
    	
	}else{
    	window.location.assign("<%=request.getContextPath()%>" + "/template/물품관리양식.xlsx");
    	
	}
}

</script>


<body onload="pageLoad()">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">물품관리</h2>
                <div class="main_summary">
                    <dl>
                        <dt>총 품목수</dt>
                        <dd id ="totalItemCnt">0개</dd>
                    </dl>
                    <a href="javascript:void(0);" onclick="showPop('add_category');"><i></i>카테고리추가</a>
                    <a href="javascript:void(0);" onclick="showPop('add_goods');">물품추가</a>
                    <a href="javascript:void(0);" class="set" onclick="showPop('set_part');">파트설정</a>
                </div>
                <div class="main_utility">
                    <div class="btn_wrap">
                        <input type="file" class="form-control" style="display:none" id="importFile" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel.sheet.macroEnabled.12" />
                        <button class="btn stroke" id="excelTemplate" name = "excelTemplate" onclick="downTemplate();">엑셀템플릿</button>
                        <button class="btn stroke" id="importExcel" name = "importExcel" onclick="findFile();">엑셀업로드</button>
                        <button class="btn stroke" id="exportExcel" name = "exportExcel" onclick="exportExcel();">엑셀다운로드</button>
                    </div>
                </div>
                <div class="main_content">
                    <!-- 필터 영역 main_filter-->
                    <div class="main_filter">
                        <form action="#">
                            <label for="con" id="search_form" name="search_form" onsubmit="return false;">검색조건</label>
                            <select name="con" id="con">
                                <option value="all" selected="selected">전체</option>
                                <option value="cgNanme">카테고리명</option>
                                <option value="pdName">품명</option>
                                <option value="pdCode">물품코드</option>
                            </select>
                            <label for="inq">조회</label>
                            <input id="inq" type="text" placeholder=",로 다중검색 가능" onkeyup="enterkey();">
                            <button type="button" class="main_filter_btn" onClick="getStockManageList();"><i>조회</i></button>
                        </form>
                    </div>
                    <!-- 보드 영역 main_dashboard-->
                    <div class="main_dashboard">
                        <div class="sub_cont stockDiv">
                            <select name="typeCd" id="typeCd">
                                <option value="all">전체</option>
                                <option value="1">소모품</option>
                                <option value="2">판재</option>
                                <option value="3">파트</option>
                                <option value="4">제품</option>
                            </select>
                            <button class="btn arr" onClick="getStockManageList();">보기</button>
                            <div class="btn_wrap" >
                                <select id="stockGridPageCount" id="stockGridPageCount" onchange="getStockManageList()">
                                    <option value="100">100개씩</option>
                                    <option value="50">50개씩</option>
                                    <option value="30" selected="selected">30개씩</option>
                                </select>
                                <button type="button" class="btn stroke" onClick="_getUserGridLayout('stockLayout', stockGrid);">칼럼위치저장</button>
                                <button type="button" class="btn stroke" onClick="_resetUserGridLayout('stockLayout', stockGrid,stockColumns);">칼럼초기화</button>
                                <button type="button" class="btn" onClick="popStockQrList();">QR출력</button>
                                <button type="button" class="btn" onclick="saveGrid('stock')">저장</button>
                                <button type="button" class="btn" onclick="deleteRows('stock')">삭제</button>
                            </div>
                        </div>
                        <div class="sub_cont excelDiv">
                        	<div class="btn_wrap" >
                        		<button type="button" class="btn" onclick="saveGrid('excel')">저장</button>
                        	</div>
                        </div>
                        <div class="grid_wrap stockDiv" style="position:relative;">
                        	<div id="stockGrid"></div>
                        	<div id="stockGridPager" class="pager"></div>
                        </div>
                        <div class="grid_wrap excelDiv" style="position:relative;">
                        	<div id="excelGrid"></div>
                        </div>
                        <div class="sub_cont stockDiv">
                            <div class="btn_wrap">
                            <button type="button" class="btn" onclick="saveGrid('stock')">저장</button>
                            <button type="button" class="btn" onclick="deleteRows('stock')">삭제</button>
                            </div>
                        </div>
                        <div class="sub_cont excelDiv">
                            <div class="btn_wrap">
                            <button type="button" class="btn" onclick="saveGrid('excel')">저장</button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
     <!-- 팝업 : 카테고리 추가 -->
     <div class="popup" id="add_category">
        <div class="popup_container">
            <div class="popup_head">
                <p class="popup_title">카테고리 추가</p>
                <button type="button" class="popup_close" onClick="closePop();">x</button>
            </div>
            <div class="popup_inner">
                <div class="sub_cont">
                    <button class="btn round" onclick="addRow('category');"><span>+</span>행 추가</button>
                    <div class="btn_wrap">
                        <button type="button" class="btn" onclick="deleteRows('category');">삭제</button>
                        <button type="button" class="btn" onclick="saveGrid('category');">저장</button>
                    </div>
                </div>
                <div class="popup_grid">
                    <div class="grid_wrap">
                    	<div id="categoryGrid"></div>
                    </div>
                </div>
                <div class="sub_cont">
                    <div class="btn_wrap">
                        <button type="button" class="btn" onclick="deleteRows('category');">삭제</button>
                        <button type="button" class="btn" onclick="saveGrid('category');">저장</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 카테고리추가 팝업 영역 끝-->
    <!-- 팝업 : 물품추가 -->
    <div class="popup" id="add_goods">
        <div class="popup_container">
            <div class="popup_head">
                <p class="popup_title">물품추가</p>
                <button type="button" class="popup_close" onClick="closePop();">x</button>
            </div>
            <div class="popup_inner">
                <dfn>필수항목<i>*</i></dfn>
                <form action="#" method="post">
                    <table>
                        <tbody>
                            <tr>
                                <th>분류<i>*</i></th>
                                <td>
                                    <select name="typeCd_pop" id="typeCd_pop" onChange="getLCategoryDtl()">
                                        <option value="1">소모품</option>
                                        <option value="2">판재</option>
                                        <option value="3">파트</option>
                                        <option value="4">제품</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>대카테고리<i>*</i></th>
                                <td>
                                    <select name="lCategyCd" id="lCategyCd" onChange="getMCategoryDtl()">
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>중카테고리<i>*</i></th>
                                <td>
                                    <select name="mCategyCd" id="mCategyCd">
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>품명<i>*</i></th>
                                <td>
                                    <input type="text" id="itemNm" name="itemNm">
                                </td>
                            </tr>
                           <!--  <tr>
                                <th>상품코드<i>*</i></th>
                                <td>
                                    <input type="text" id="itemCd" name="itemCd">
                                </td>
                            </tr> -->
                            <tr>
                                <th>상품단위<i>*</i></th>
                                <td>
                                    <input type="text" id="unit" name="unit">
                                </td>
                            </tr>
                            <tr>
                                <th>원가<i>*</i></th>
                                <td>
                                    <input type="number" class="tr" id="cost" name="cost" >
                               </td>
                            </tr>
                            <tr>
                                <th>판매가</th>
                                <td>
                                    <input type="number" class="tr" id="sellPrice" name="sellPrice" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');">
                                </td>
                            </tr>
                            <tr>
                                <th>재고알림수량<i>*</i></th>
                                <td>
                                    <input type="number" class="nar" id="tagQuantity" name="tagQuantity">개
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
                <div class="popup_btn_area">
                    <button type="button" class="btn confirm" onclick = "addItem();">추가</button>
                </div>
            </div>
        </div>
    </div>
    <!--물품추가 팝업 영역 끝-->
    <!-- 팝업 : 파트설정 -->
    <div class="popup" id="set_part">
        <div class="popup_container">
            <div class="popup_head">
                <p class="popup_title">파트설정</p>
                <button type="button" class="popup_close" onClick="closePop()">x</button>
            </div>
            <div class="popup_inner">
            	<form id="setPartForm" onsubmit="return false;">
                	<div class="util">
                        <table>
	                        <tbody>
	                            <tr id="trTypeCd_pop2">
	                                <th>분류</th>
	                                <td>
	                                    <select name="typeCd_pop2" id="typeCd_pop2" onChange="getLCategoryDtl('set_part')">
	                                    	<option selected="selected" value="all">전체</option>
	                                        <option value="2">판재</option>
	                                        <option value="4">제품</option>
	                                    </select>
	                                </td>
	                            </tr>
	                            <tr id="trLCategyCd_pop2">
	                                <th>대카테고리</th>
	                                <td>
	                                    <select name="lCategyCd_pop2" id="lCategyCd_pop2" onChange="getMCategoryDtl('set_part')">
	                                    </select>
	                                </td>
	                            </tr>
	                            <tr id="trMCategyCd_pop2">
	                                <th>중카테고리</th>
	                                <td>
	                                    <select name="mCategyCd_pop2" id="mCategyCd_pop2" onChange="getItemDtl()">
	                                    </select>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th>물품<i>*</i></th>
	                                <td>
	                                    <select name="itemCd_pop2" id="itemCd_pop2">
	                                    </select>
	                                </td>
	                            </tr>
	                            <tr>
	                                <th>생산/필요파트</th>
	                                <td>
	                                    <div class="sform">
				                            <input type="text" id="partNm_pop2" placeholder="파트명(QR코드 사용)"  onkeyup="enterkey('pop');">
				                            <button type="button" class="btn_srch" onClick="getPartList();"><i>조회</i></button>
					                    </div>
					                    <input type="file" class="form-control" style="display:none" id="partImportFile" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel.sheet.macroEnabled.12" />
					                    <button type="button" class="btn stroke" onClick="downTemplate('part');">엑셀템플릿</button>
	                   					<button type="button" class="btn stroke" onClick="findFile('part');">엑셀업로드</button>
	                                </td>
	                            </tr>
	                        </tbody>
	                    </table>
	                </div>
	            </form>
	            <div id = "partAddDiv">
	                <div class="popup_grid">
	                    <div class="grid_wrap">
	                    	<div id="partTopGrid" ></div>
	                    </div>
	                </div>
	                <div class="btn_area">
	                    <button class="btn" onClick="addPart();">추가</button>
	                    <button class="btn" onClick="removePart();">삭제</button>
	                </div>
	                <div class="popup_grid">
	                    <div class="grid_wrap">
	                    	<div id="partBottomGrid" ></div>
	                    </div>
	                </div>
	                <div id="setPartBtn" class="popup_btn_area">
	                    <button type="button" class="btn confirm" onClick="saveGrid('partBottom');">저장</button>
	                </div>
	                <div id="infoPartBtn" class="popup_btn_area">
	                    <button type="button" class="btn stroke" onClick="closePop()">취소</button>
	                    <button type="button" class="btn fill" onClick="saveGrid('partBottom');">수정</button>
	                </div>
                </div>
                <div id="partExcelDiv" class="popup_grid" style="display:none;">
                    <div class="grid_wrap">
                    	<div id="partExcelGrid" ></div>
                    </div>
                    <div class="popup_btn_area">
	                    <button type="button" class="btn confirm" onClick="saveGrid('partExcel')">저장</button>
	                </div>
                </div>
            </div>
        </div>
    </div>
    <!--파트설정 팝업 영역 끝-->
    
   <!--물품추가 팝업 영역 끝-->
    <!-- 추가된 행 / 수정된 행 처리용 그리드 -->
<div class="grid_wrap" id="editDiv" style="display:none;">
    <div id="editGrid"></div>
</div>
</body>
</html>