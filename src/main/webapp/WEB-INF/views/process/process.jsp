<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

<script type="text/javascript">

var processView;
var processGridPager;
var processGrid;
var processColumns;

var partPresentView;
var partPresentGrid;
var partPresentColumns;

var editGrid;
var editGridView;

var bldgList;
var faultyList;

var memberId = "<%=session.getAttribute("id")%>";
var memberAuth = "<%=session.getAttribute("auth")%>";

function pageLoad(){
	sessionCheck(memberId, memberAuth, 'process');
	
	$('#process').addClass("current");
	
	var fromDate = new Date()
	fromDate.setDate(fromDate.getDate() - 7);
	var fromday = _getFormatDate(fromDate);
	var today = _getFormatDate(new Date());
	$('#fromDate').val(fromday);
	$('#toDate').val(today);
	$('#fromDate').attr('max',today);
	$('#toDate').attr('max',today);
	
	loadGridList('init');
	
	getProcessTotal();
	//getProcessList();
}

function enterkey(type) {
    if (window.event.keyCode == 13) {
    	if(type == 'pop'){
    		changeItem();
    		
    	}else{
    		getProcessList();
    	}
    }
}

//그리드 초기 셋팅
function loadGridList(type, result){
	  if(type == "init"){
		   processView = new wijmo.collections.CollectionView(result, {
		       pageSize: 100
		   });
		    
		   processGridPager = new wijmo.input.CollectionViewNavigator('#processGridPager', {
		        byPage: true,
		        headerFormat: '{currentPage:n0} / {pageCount:n0}',
		        cv: processView
		    });
		   
		   faultyList = new wijmo.grid.DataMap([{ id:'N', name: '정상' },{ id:'Y', name: '불량' }], 'id', 'name');
		   processColumns = [
			  { binding: 'processSeq', header: 'seq', isReadOnly: true, width: 100, align:"center", visible: false   },
			  { binding: 'cretDt', header: '일자', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'bldgNm', header: '건물명', isReadOnly: true, width: 200, align:"center"  },
		      { binding: 'bldgCd', header: '건물코드', isReadOnly: true, width: 100, align:"center" , visible: false  },
		      { binding: 'prcCd', header: '공정', isReadOnly: true, width: 50, align:"center" },
		      { binding: 'itemNm', header: '물품명', isReadOnly: true, width: 200, align:"center" },
		      { binding: 'itemCd', header: '물품코드', isReadOnly: true, width: 100, align:"center"},
		      { binding: 'prcStDt', header: '착수예정일', isReadOnly: true, width: 100, align:"center"  },
		      { binding: 'prcEndPDt', header: '완료예정일', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'doneStDt', header: '공정착수일', isReadOnly: false, width: 100, align:"center"  },
		      { binding: 'doneEndDt', header: '공정완료일', isReadOnly: false, width: 100, align:"center"  },
		      { binding: 'dDay', header: '디데이', isReadOnly: true, width: 80, align:"center"  },
		      { binding: 'prcState', header: '상태', isReadOnly: true, width: 50, align:"center"  },
		      { binding: 'prodCnt', header: '생산수량', isReadOnly: true, width: 80, align:"center"  },
		      { binding: 'need', header: '필요자재', width: 80, align:"center",
		    	  cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
		              text: '<b>보기</b>',
		              click: (e, ctx) => {
		            	  showPop('prs_part', e, ctx);
		              }
		              
		    	  })
		      },
		      { binding: 'memo', header: '비고', isReadOnly: false, width: 200, align:"center"  },
		      { binding: 'inYn', header: '자재입고', isReadOnly: true, width: 80, align:"center"  },
		      { binding: 'img', header: '착수이미지', width: 80, align:"center",
		    	  cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
		              text: '<b>보기</b>',
		              click: (e, ctx) => {
		            	  showImgPop(e, ctx, 'start');
		              }
		              
		    	  })
		      },
		      { binding: 'faultyYn', header: '착수불량여부', isReadOnly: false, width: 100, align:"center" , dataMap: faultyList, dataMapEditor: 'DropDownList' },
		      { binding: 'faultyCnt', header: '착수불량수량', isReadOnly: false, width: 100, align:"center"  },
		      { binding: 'prcMemo', header: '착수특이사항', isReadOnly: true, width: 200, align:"center"  },
		      { binding: 'doneImg', header: '완료이미지', width: 80, align:"center",
		    	  cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
		              text: '<b>보기</b>',
		              click: (e, ctx) => {
		            	  showImgPop(e, ctx, 'done');
		              }
		              
		    	  })
		      },
		      { binding: 'doneFaultyYn', header: '완료불량여부', isReadOnly: false, width: 100, align:"center" , dataMap: faultyList, dataMapEditor: 'DropDownList' },
		      { binding: 'doneFaultyCnt', header: '완료불량수량', isReadOnly: false, width: 100, align:"center"  },
		      { binding: 'donePrcMemo', header: '완료특이사항', isReadOnly: true, width: 200, align:"center"  },
		      { binding: 'edit', header: '정보수정', width: 80, align:"center",
		    	  cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
		              text: '<b>수정</b>',
		              click: (e, ctx) => {
		            	  showPop('update_sch', e, ctx);
		              }
		              
		    	  })
		      }
		    ];
		   
		   var dongStDtEditor = new wijmo.input.InputDate(document.createElement("div"));
		   var dongEndDtEditor = new wijmo.input.InputDate(document.createElement("div"));
		   processGrid = new wijmo.grid.FlexGrid('#processGrid', {
			    autoGenerateColumns: false,
			    alternatingRowStep: 0,
			    columns: processColumns,
			    itemsSource: processView,
			    beginningEdit: function (s, e) {
			    	s.columns.getColumn("doneStDt").editor = dongStDtEditor;
			    	s.columns.getColumn("doneEndDt").editor = dongEndDtEditor;
	            },
	            cellEditEnding: (s, e) => {
	                let col = s.columns[e.col];
	                let value = s.activeEditor.value;
	                if(col.binding == 'faultyCnt' || col.binding == 'doneFaultyCnt' ){
	                	//숫자여부 확인
	                	var formatValue = wijmo.changeType(s.activeEditor.value, wijmo.DataType.Number, col.format);
	                    if( !wijmo.isNumber(formatValue)){
	                        e.cancel = true;
	                        e.stayInEditMode = false;
	                        alert('숫자로만 입력 가능합니다.');
	                        return false;
	                    }
	              	}
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
	        
	        editGrid = new wijmo.grid.FlexGrid('#editGrid', {
	            itemsSource: processView.itemsEdited,
	            isReadOnly: true
	        });
	    
		   	_setUserGridLayout('processLayout', processGrid, processColumns);
		   	
	        
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
	            itemsSource: partPresentView
	        });
	        
	        partPresentGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        };
	        
	  }else if(type == "partPresent"){
	    	partPresentView = new wijmo.collections.CollectionView(result, {});
	        partPresentGrid.itemsSource = partPresentView;
	    	
	  }else{
		  processView = new wijmo.collections.CollectionView(result, {
		       pageSize: Number($('#processGridPageCount').val()),
		       trackChanges: true
		   });
		  processGridPager.cv = processView;
		  processGrid.itemsSource = processView;
	  }
	  
	  refreshPaging(processGrid.collectionView.totalItemCount, 1, processGrid, 'processGrid');  // 페이징 초기 셋팅
	  
}

//건물 리스트 조회
function getProcessList(){
	var param = {
			con 	: $('#con').val()
			, inq 	: $('#inq').val()
			, fromDate : $('#fromDate').val()
			, toDate : $('#toDate').val()
			, prcState : $('#prcState option:selected').val()
		};
	
	$.ajax({
     type : 'POST',
     url : '/process/getProcessList',
     dataType : null,
     data : param,
     success : function(result) {
     	console.log("getProcessList success");
     	loadGridList('search', result);
     	getProcessTotal();
     	getProcessLable();
     },
     error: function(request, status, error) {
     	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

     }
 }); 
}


function getProcessLable(){
	var params = {
			con 	: $('#con').val()
			, inq 	: $('#inq').val()
			, fromDate : $('#fromDate').val()
			, toDate : $('#toDate').val()
			, prcState : $('#prcState option:selected').val()
		};
	
 	$.ajax({
 	      url : '/process/getProcessLable',
 	     async : false, // 비동기모드 : true, 동기식모드 : false
         type : 'POST',
         cache : false,
         dataType : null,
         data : params,
 	      success : function(result) {
 	      	$("#faultyCnt").text(Number(result.faultycnt).toLocaleString('ko-KR')+ "개");
 	        $("#faultyPersent").text(Number(result.faultypersent).toLocaleString('ko-KR')+ "%");
 	      },
 	      error: function(request, status, error) {
 	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
 	      }
 	  });
 }

function getProcessTotal(){
 	$.ajax({
 	      type : 'POST',
 	      url : '/process/getProcessTotal',
 	      async : false, // 비동기모드 : true, 동기식모드 : false
 	      dataType : null,
 	      success : function(result) {
 	    	 console.log(result);
 	    	console.log(result.finprc);
 	      	$("#finPrc").text(Number(result.finprc).toLocaleString('ko-KR')+ "개");
 	        $("#proPrc").text(Number(result.proprc).toLocaleString('ko-KR')+ "개");
 	       	$("#delayPrc").text(Number(result.delayprc).toLocaleString('ko-KR')+ "개");
 	      },
 	      error: function(request, status, error) {
 	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
 	      }
 	  });
 }
 
function showImgPop(e, ctx, type){
	var url = ctx.item["processSeq"];
	var win = window.open("/process/getShowImgPop?processSeq="+url+"&type="+type, "PopupWin", "width=1000,height=600");

} 
 
//팝업 오픈
function showPop(pop, e, ctx){
	if(pop == "prs_part"){
		prsPartForm.itemNm2.value = ctx.item["itemNm"];
		prsPartForm.itemCd2.value = ctx.item["itemCd"];
		prsPartForm.prodCnt2.value = ctx.item["prodCnt"];
		prsPartForm.processSeq2.value = ctx.item["processSeq"];
		
		getNeedMaterList();
      
	}else if(pop == "add_sch"){
		//건물 셀렉트박스 셋팅, bldgCd에 셋팅
		getBldgDtl();
		$("#bldgCd").val('all').prop("selected", true);
		addSchForm.prcCd.value = '';
		addSchForm.itemNm.value = '';
		addSchForm.itemCd.value = '';
		addSchForm.prodCnt.value = '';
		addSchForm.prcStDt.value = '';
		addSchForm.prcEndPDt.value = '';
		addSchForm.memo.value = '';
		addSchForm.processSeq.value = '';
		
		$('#addProcess').css('display', 'block');
		$('#updateProcess').css('display', 'none');
		$('#popTitle').text('일정추가');
	
	}else if(pop == "update_sch"){
		getBldgDtl();
		$("#bldgCd").val(ctx.item["bldgCd"]).prop("selected", true);
		addSchForm.prcCd.value = ctx.item["prcCd"];
		addSchForm.itemNm.value = ctx.item["itemNm"];
		addSchForm.itemCd.value = ctx.item["itemCd"];
		addSchForm.prodCnt.value = ctx.item["prodCnt"];
		addSchForm.prcStDt.value = ctx.item["prcStDt"];
		addSchForm.prcEndPDt.value = ctx.item["prcEndPDt"];
		addSchForm.memo.value = ctx.item["memo"];
		addSchForm.processSeq.value = ctx.item["processSeq"];
		
		$('#addProcess').css('display', 'none');
		$('#updateProcess').css('display', 'block');
		$('#popTitle').text('일정수정');
		
		pop = 'add_sch';
	}
	
	 $('#'+pop).addClass('is_on');
  
}

//건물 리스트 조회
function getNeedMaterList(){
	var param = {
			prodCnt 	: prsPartForm.prodCnt2.value
			, itemCd 	: prsPartForm.itemCd2.value
			, processSeq 	: prsPartForm.processSeq2.value
		};
	
	$.ajax({
     type : 'POST',
     url : '/process/getNeedMaterList',
     dataType : null,
     data : param,
     success : function(result) {
     	console.log("getNeedMaterList success");
     	loadGridList('partPresent', result);
     },
     error: function(request, status, error) {
     	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

     }
 }); 
}

function getBldgDtl() {
  $.ajax({
          url : "/stock/getBldgList",
          async : false, // 비동기모드 : true, 동기식모드 : false
          type : 'POST',
        //  data : params,
          success : function(result) {
        	  if(result.length > 0){
        		bldgList = result;
              	$('#bldgCd').empty().append('<option selected="selected" value="all" selected>전체</option>');
                  for(var i =0; i<result.length; i++)
                      $("#bldgCd").append("<option value='" + result[i].bldgCd + "'>" + result[i].bldgNm + "</option>");
                  
              }else{
              	$('#bldgCd').empty().append('<option selected="selected" value="all" selected>전체</option>');
              	
              }
          },
          error : function(request,status,error) {
              alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
          }
  });
 
}

//선택 된 건물의 공정 값 공정필드에 저장
function getBldgPrcCd(){
	console.log(bldgList);
	if(bldgList.length > 0){
		var bldgItem = bldgList.filter(bldg => bldg.bldgCd == $('#bldgCd option:selected').val());
		
		console.log($('#bldgCd option:selected').val());
		console.log(bldgItem);
		if(bldgItem.length > 0) {
			if(bldgItem[0].auth == 'mnFact'){
				addSchForm.prcCd.value = '가공';	
				
			}else if(bldgItem[0].auth == 'finFact'){
				addSchForm.prcCd.value = '마감';
				
			}else{
				addSchForm.prcCd.value = '자사';
			}
		}
	}
}

function saveGrid(){
    var editItem = processView.itemsEdited;
    var rows = [];
    for(var i =0; i< editItem.length ; i++){
        rows.push(editItem[i]);
    }
    if(confirm("저장하시겠습니까?")){
    // 기본정보 저장
        $.ajax({
            url : "/process/saveProcessGrid",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            contentType: 'application/json',
            data: JSON.stringify(rows),
            success : function(result) {
                alert("저장되었습니다.");
                getProcessList();
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
    }
}

//팝업 종료
function closePop(){
	$('.popup').removeClass('is_on');
}

//공정 추가 
function addProcess(){
  	//필수값 체크
	if($('#bldgCd option:selected').val() == 'all'){
        alert("건물명을 선택해주세요.");
        return false;
        
    }else if(addSchForm.itemCd.value == ""){
      	alert("생산제품을 입력해주세요.");
      	addSchForm.itemCd.focus();
         return false;
          
      }else if(addSchForm.prodCnt.value == ""){
      	alert("생산수량을 입력해주세요.");
      	addSchForm.prodCnt.focus();
          return false;
          
      }else if(addSchForm.prcStDt.value == ""){
       	alert("착수예정일을 선택해주세요.");
       	addSchForm.prcStDt.focus();
           return false;
           
      }else if(addSchForm.prcEndPDt.value == ""){
         alert("완료예정일을 선택해주세요.");
         addSchForm.prcEndPDt.focus();
           return false;
           
      }
      
	var params = {
			bldgCd 		:	addSchForm.bldgCd.value
      		,itemCd		:	addSchForm.itemCd.value
      		,prcStDt	:	addSchForm.prcStDt.value
      		,prcEndPDt	:	addSchForm.prcEndPDt.value
      		,prodCnt	:	addSchForm.prodCnt.value
      		,memo 		: 	addSchForm.memo.value
      	}
      	
      	$.ajax({
              url : "/process/saveProcess",
              async : false, // 비동기모드 : true, 동기식모드 : false
              type : 'POST',
              cache : false,
              dataType : 'text',
              data : params,
              success : function(data) {
                  alert("공정 추가가 완료되었습니다.");
                  closePop();
                  getProcessList();
              },
              error : function(request,status,error) {
               	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
              }
        });
  }

  function deleteProcess(){
  	if(confirm("삭제하시겠습니까?")){
  		var params = {
  			processSeq : addSchForm.processSeq.value
     	};
  		
  		$.ajax({
           url : '/process/deleteProcess',
           async : false, // 비동기모드 : true, 동기식모드 : false
           type : 'POST',
           cache : false,
           dataType : null,
           data : params,
           success : function(data) {
           	alert('정상적으로 삭제되었습니다.');
           	closePop();
           	getProcessList();
           },
           error : function(request,status,error) {
             alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
           }
     });
  	}
  }

  function updateProcess(){
	//필수값 체크
		if($('#bldgCd option:selected').val() == 'all'){
	        alert("건물명을 선택해주세요.");
	        return false;
	        
	    }else if(addSchForm.itemCd.value == ""){
	      	alert("생산제품을 입력해주세요.");
	      	addSchForm.itemCd.focus();
	         return false;
	          
	      }else if(addSchForm.prodCnt.value == ""){
	      	alert("생산수량을 입력해주세요.");
	      	addSchForm.prodCnt.focus();
	          return false;
	          
	      }else if(addSchForm.prcStDt.value == ""){
	       	alert("착수예정일을 선택해주세요.");
	       	addSchForm.prcStDt.focus();
	           return false;
	           
	      }else if(addSchForm.prcEndPDt.value == ""){
	         alert("완료예정일을 선택해주세요.");
	         addSchForm.prcEndPDt.focus();
	           return false;
	           
	      }
	      
		var params = {
				bldgCd 		:	addSchForm.bldgCd.value
	      		,itemCd		:	addSchForm.itemCd.value
	      		,prcStDt	:	addSchForm.prcStDt.value
	      		,prcEndPDt	:	addSchForm.prcEndPDt.value
	      		,prodCnt	:	addSchForm.prodCnt.value
	      		,memo 		: 	addSchForm.memo.value
	      		,processSeq : 	addSchForm.processSeq.value
	      	}
	      	
	      	$.ajax({
	              url : "/process/updateProcess",
	              async : false, // 비동기모드 : true, 동기식모드 : false
	              type : 'POST',
	              cache : false,
	              dataType : 'text',
	              data : params,
	              success : function(data) {
	                  alert("공정 수정이 완료되었습니다.");
	                  closePop();
	                  getProcessList();
	              },
	              error : function(request,status,error) {
	               	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	              }
	        });
  }
  
  function changeItem(){
	  var params = {
			partNm : $("#itemNm").val()
	   }
	  
	  $.ajax({
	         url : "/stock/getPartName",
	         async : false, // 비동기모드 : true, 동기식모드 : false
	         type : 'POST',
	         data : params,
	         success : function(result) {
	        	 console.log(result);
	     	    if(result.length > 0){
	     	    	$("#itemNm").val(result[0].itemNm);
	     	    	$("#itemCd").val(result[0].itemCd);
	     	    }else{
	     	    	$("#itemCd").val('');
	     	    }

	         },
	         error : function(request,status,error) {
	          	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	         }
	       });
  }
  

  function exportExcel(){
	  	var gridView = processGrid.collectionView;
	  	var oldPgSize = gridView.pageSize;
	  	var oldPgIndex = gridView.pageIndex;

	   	//전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
	  	processGrid.beginUpdate();
	  	processView.pageSize = 0;

	   	wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(processGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'ProcessrList.xlsx',
	  	      saved => {
	  	    	gridView.pageSize = oldPgSize;
	  	    	gridView.moveToPage(oldPgIndex);
	  	    	processGrid.endUpdate();
	  	      }, null
	  	 );
	  }
  

</script>


<body onload="pageLoad();">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">공정관리</h2>
                <div class="main_summary quarter">
                    <dl>
                        <dt>마감된 공정</dt>
                        <dd id='finPrc'>0개</dd>
                    </dl>
                    <dl>
                        <dt>진행중인 공정</dt>
                        <dd id='proPrc'>0개</dd>
                    </dl>
                    <dl>
                        <dt>지연중인 공정</dt>
                        <dd id='delayPrc'>0개</dd>
                    </dl>
                    <a href="javascript:void(0);" class="popup_trigger" onclick="showPop('add_sch');"><i></i>일정추가</a>
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
                            <option value="bldgName">건물명</option>
                            <option value="process">공정</option>
                            <option value="pdName">물품명</option>
                            <option value="pdCode">물품코드</option>
                        </select>
                        <label for="inq" onkeyup="enterkey();">조회</label>
                            <input id="inq" type="text" placeholder=",로 다중검색 가능" onkeyup="enterkey();">
                            <button type="button" class="main_filter_btn" onClick="getProcessList();"><i>조회</i></button>
                    </form>
                    <div class="summary">
                        <dl>
                            <dt>불량수량</dt>
                            <dd id='faultyCnt'>0개</dd>
                        </dl>
                        <dl>
                            <dt>불량률</dt>
                            <dd id='faultyPersent'>0%</dd>
                        </dl>
                    </div>
                </div>
                <!-- 보드 영역 main_dashboard-->
                <div class="main_dashboard">
                    <div class="sub_cont">
                        <select name="prcState" id="prcState">
                            <option value="all">전체</option>
                            <option value="G">작업마감</option>
                            <option value="Y">진행중</option>
                            <option value="R">지연</option>
                        </select>
                        <button class="btn" onClick="getProcessList();">보기</button>
                        <div class="state">
                            <span><dfn class="mark"></dfn>작업마감</span>
                            <span><dfn class="mark yellow"></dfn>진행중</span>
                            <span><dfn class="mark red"></dfn>작업지연</span>
                        </div>
                        <div class="btn_wrap">
                            <select id="processGridPageCount" id="processGridPageCount" onchange="getProcessList()">
                                <option value="100">100개씩</option>
                                <option value="50">50개씩</option>
                                <option value="30">30개씩</option>
                            </select>
                            <button type="button" class="btn stroke" onClick="_getUserGridLayout('processLayout', processGrid);">칼럼위치저장</button>
                            <button type="button" class="btn stroke" onClick="_resetUserGridLayout('processLayout', processGrid, processColumns);">칼럼초기화</button>
                            <button type="button" class="btn" onClick="saveGrid();">저장</button>
                        </div>
                    </div>
                    <div class="grid_wrap">
                       	<div id="processGrid" ></div>
                       	<div id="processGridPager" class="pager"></div>
                    </div>
                    <div class="sub_cont">
                        <div class="btn_wrap">
                            <button type="button" class="btn" onClick="saveGrid();">저장</button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <!-- 팝업 -->
        <!-- 팝업 : 일정추가 -->
        <div class="popup" id="add_sch">
            <div class="popup_container">
                <div class="popup_head">
                    <p id = "popTitle" class="popup_title">일정추가</p>
                    <button type="button" class="popup_close" onClick="closePop();">x</button>
                </div>
                <div class="popup_inner">
                    <dfn>필수항목<i>*</i></dfn>
                    <form id="addSchForm" onsubmit="return false;">
                        <table>
                            <tbody>
                                <tr>
                                    <th>건물명<i>*</i></th>
                                    <td>
                                        <select name="bldgCd" id="bldgCd" onChange="getBldgPrcCd()">
                                    	</select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>공정<i>*</i></th>
                                    <td>
                                        <input type="text" id="prcCd" name="prcCd" onfocus="this.blur();" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <th>생산제품<i>*</i></th>
                                    <td>
                                        <input type="text" id="itemNm" name="itemNm" placeholder="QR코드" onChange="changeItem()" onkeyup="enterkey('pop');">
                                       <input type="text" id="itemCd" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <th>생산수량<i>*</i></th>
                                    <td>
                                        <input type="number" class="nar" id="prodCnt" name="prodCnt" value="개">
                                    </td>
                                </tr>
                                <tr>
                                    <th>착수예정일<i>*</i></th>
                                    <td>
                                        <input type="date" id="prcStDt" name="prcStDt">
                                    </td>
                                </tr>
                                <tr>
                                    <th>완료예정일<i>*</i></th>
                                    <td>
                                        <input type="date" id="prcEndPDt" name="prcEndPDt">
                                    </td>
                                </tr>
                                <tr>
                                    <th>비고</th>
                                    <td>
                                        <textarea name="memo" id="memo" cols="30" rows="5"></textarea>
                                    </td>
                                </tr>
                                
                            </tbody>
                        </table>
                        <input type="hidden" id="processSeq">
                    </form>
                    <div id="addProcess" class="popup_btn_area">
                        <button type="button" class="btn confirm" onclick = "addProcess();">추가</button>
                    </div>
                    <div id="updateProcess" class="popup_btn_area">
                        <button type="button" class="btn stroke" onclick = "updateProcess();">수정</button>
                        <button type="button" class="btn fill" onclick = "deleteProcess();">삭제</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- 일정추가 팝업 영역 끝-->
        <!-- 팝업 : 필요자재 -->
        <div class="popup" id="prs_part">
        	<form id="prsPartForm" onsubmit="return false;">
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
	                        	<div id="partPresentGrid" ></div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </form>
        </div>
        <!-- 필요자재 팝업 영역 끝 -->
    </div>
    
<div class="grid_wrap" id="editDiv" style="display:none;">
   <div id="editGrid"></div>
</div> 
    
</body>
</html>