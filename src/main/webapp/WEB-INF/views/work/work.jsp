<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

<script type="text/javascript">

var workView;
var workGridPager;
var workGrid;
var workColumns;

var editGrid;
var editGridView;

var buildingList;
var memberList;

var memberId = "<%=session.getAttribute("id")%>";
var memberAuth = "<%=session.getAttribute("auth")%>";

function pageLoad(){
	sessionCheck(memberId, memberAuth, 'work');
	
	$('#work').addClass("current");
	
	var fromDate = new Date()
	fromDate.setDate(fromDate.getDate() - 7);
	var fromday = _getFormatDate(fromDate);
	var today = _getFormatDate(new Date());
	$('#fromDate').val(fromday);
	$('#toDate').val(today);
	$('#fromDate').attr('max',today);
	$('#toDate').attr('max',today);
	
	loadGridList('init');
	
	getWorkList();
	getWorkStTime();
}


function enterkey() {
    if (window.event.keyCode == 13) {
    	getWorkList();
    }
}

//그리드 초기 셋팅
function loadGridList(type, result){
	  if(type == "init"){
		   workView = new wijmo.collections.CollectionView(result, {
		       pageSize: 100
		   });
		    
		   workGridPager = new wijmo.input.CollectionViewNavigator('#workGridPager', {
		        byPage: true,
		        headerFormat: '{currentPage:n0} / {pageCount:n0}',
		        cv: workView
		    });
		   
		   memberList = new wijmo.grid.DataMap(getChooseMemberList('admin,own,mnFact,finFact'), 'id', 'name');
		   buildingList = new wijmo.grid.DataMap(getBuildingList(), 'id', 'name');
		   workColumns = [
		      { binding: 'workStDt', header: '근태일자', isReadOnly: false, width: 120, align:"center" },
		      { binding: 'officerId', header: '담당자', isReadOnly: false, width: 150, align:"center", dataMap: memberList, dataMapEditor: 'DropDownList'  },
		      { binding: 'late', header: '지각여부', isReadOnly: true, width: 80, align:"center"},
		      { binding: 'workInDt',header: '출근일시', format: 'yyyy-MM-dd H:mm:ss', isReadOnly: false, width: 200, align:"center" },
		      { binding: 'compInCd', header: '출근건물', isReadOnly: false, width: 150, align:"center", dataMap: buildingList, dataMapEditor: 'DropDownList'  },
		      { binding: 'memoIn', header: '출근메모', isReadOnly: false, width: 100, align:"center" },
		      { binding: 'postInLocNm', header: '출근위치', isReadOnly: false, width: 200 , align:"center" },
		      { binding: 'workOutDt', header: '퇴근일시', format: 'yyyy-MM-dd H:mm:ss', isReadOnly: false, width: 200, align:"center" },
		      { binding: 'compOutCd', header: '퇴근건물', isReadOnly: false, width: 150, align:"center", dataMap: buildingList, dataMapEditor: 'DropDownList' },
		      { binding: 'postOutLocNm', header: '퇴근위치', isReadOnly: false, width: 200 , align:"center" },
		      { binding: 'memoOut', header: '퇴근메모', isReadOnly: false, width: 100, align:"center" },
		      { binding: 'updtId', header: '수정자' , isReadOnly: true, width: 150 , align:"center" },
		      { binding: 'updtDt', header: '수정일시', isReadOnly: true, width: 100, align:"center" }
		    ];
		  
		   var workStDtEditor = new wijmo.input.InputDate(document.createElement("div"));
		   var theInputDateTime = new wijmo.input.InputDateTime(document.createElement("div"));
		   workGrid = new wijmo.grid.FlexGrid('#workGrid', {
			    autoGenerateColumns: false,
			    alternatingRowStep: 0,
			    columns: workColumns,
			    itemsSource: workView,
			    beginningEdit: function (s, e) {
			    	s.columns.getColumn("workStDt").editor = workStDtEditor;
			    	s.columns.getColumn("workInDt").editor = theInputDateTime;
			    	s.columns.getColumn("workOutDt").editor = theInputDateTime;
	                var col = s.columns[e.col];
	                var item = s.rows[e.row].dataItem;
	                if(item.updtDt != undefined){
	                    if (col.binding != 'memoIn' && col.binding != 'memoOut' && col.binding != 'workInDt' && col.binding != 'workOutDt' ) {
	                        e.cancel = true;
	                        alert("신규 행일때만 입력이 가능합니다.");
	                    }
	                }
	            }
			    
			  });
			  
		   workGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        }; 
		   
		   	_setUserGridLayout('workLayout', workGrid, workColumns);
		   	
		   	editGrid = new wijmo.grid.FlexGrid('#editGrid', {
	            itemsSource: workView.itemsEdited,
	            isReadOnly: true
	        });
			  
	  }else{
		  workView = new wijmo.collections.CollectionView(result, {
		       pageSize: Number($('#workGridPageCount').val())
		       ,trackChanges: true
		   });
		  workGridPager.cv = workView;
		  workGrid.itemsSource = workView;
	  }
	  
	  refreshPaging(workGrid.collectionView.totalItemCount, 1, workGrid, 'workGrid');  // 페이징 초기 셋팅
	  
}

//동적으로 가져오기
function getChooseMemberList(typeList) {
	var returnVal;
	var param = {
			type : typeList
		};
	
    $.ajax({
            url : "/member/getChooseMemberList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            data : param,
            success : function(result) {
            	
            	console.log(result);
            	
            	memberList = [];
                if(result.length > 0){
                	
                	for(var i =0; i<result.length; i++){
                		memberList[i] = { id: result[i].id, name: result[i].name};	
                	}
                	
                }else{
                	memberList[0] = { id: null, name: null };	
                }
                returnVal = memberList;
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
    });
    
    return returnVal;
}

//동적으로 가져오기
function getBuildingList() {
	var returnVal;
	var param = {
			con 	: null
			, inq 	: null
			, active : true
		};
	
    $.ajax({
            url : "/building/getBuildingList",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            data : param,
            success : function(result) {
            	
            	console.log(result);
            	
            	var buildingList = [];
                if(result.length > 0){
                	
                	for(var i =0; i<result.length; i++){
                		buildingList[i] = { id: result[i].bldgCd, name: result[i].bldgNm };	
                	}
                	
                }else{
                	buildingList[0] = { id: null, name: null };	
                }
                returnVal = buildingList;
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
    });
    
    return returnVal;
}

//멤버 리스트 조회
function getWorkList(){
	var param = {
		con 	: $('#con').val()
		, inq 	: $('#inq').val()
		, fromDate : $('#fromDate').val()
		, toDate : $('#toDate').val()
	};
	
	$.ajax({
	   type : 'POST',
	   url : '/work/getWorkList',
	   dataType : null,
	   data : param,
	   success : function(result) {
	   	console.log("getWorkList success");
	   	
	   	loadGridList('search', result);
	   	getWorkLable();
	   },
	   error: function(request, status, error) {
	   	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	
	   }
	}); 
}

function getWorkLable(){
	var param = {
			con 	: $('#con').val()
			, inq 	: $('#inq').val()
			, fromDate : $('#fromDate').val()
			, toDate : $('#toDate').val()
		};
	
	$.ajax({
	      type : 'POST',
	      url : '/work/getWorkLable',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      data : param,
	      success : function(result) {
	      	console.log(result);
	      	$("#workingDay").text(Number(result.working_day).toLocaleString('ko-KR')+ "일");
	        $("#workHour").text(Number(result.work_hour).toLocaleString('ko-KR')+ "시간");
	        $("#lateCnt").text(Number(result.late_cnt).toLocaleString('ko-KR')+ "회");
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      }
	  });
}

//행추가
function addRow(){
	workGrid.allowAddNew = true;
}

function saveGrid(){
    var addItem  = workView.itemsAdded;
    var editItem = workView.itemsEdited;
    var addRows = [];
	var editRows = [];
	var rows = [];
	
	console.log("saveGrid");
	console.log(addItem);
	console.log(editItem);

    for(var i=0; i< addItem.length; i++){
    	if(!saveVal(addItem[i])) return false;
    	
    	addRows.push(addItem[i]);
    	rows.push(addItem[i]);
    }
	
	for(var i =0; i< editItem.length; i++){
		//if(!saveVal(editItem[i])) return false;
		
    	editRows.push(editItem[i]);
    	rows.push(editItem[i]);
    }
	
	console.log(rows);
    
	wijmo.Control.getControl("#editGrid").refresh(true);
    if(confirm("변경한 내용을 저장 하시겠습니까??")){
    	$.ajax({
            url : "/work/saveWorkGrid",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            contentType: 'application/json',
            data: JSON.stringify(addRows),
            success : function(result) {
               	console.log('saveWorkGrid');
               	console.log(addRows);
               	updateWorkGrid(editRows);
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
    }
}

function saveVal(item){
	var param = {
			officerId 	: item.officerId
			, workStDt 	: item.workStDt
		};
	
	var returnVal;
	
	$.ajax({
	      type : 'POST',
	      url : '/work/chkWorkDup',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      data : param,
	      success : function(result) {
	      	console.log(result);
	      	
	      	if(result.length > 0){
	      		alert("등록된 근태일자가 존재합니다.");
	      		returnVal = false;
	      	}else{
	      		returnVal = true;
	      	}
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      	returnVal = false;
	      }
	  });
	
	return returnVal;
}


function updateWorkGrid(editRows){
	$.ajax({
        url : "/work/updateWorkGrid",
        async : false, // 비동기모드 : true, 동기식모드 : false
        type : 'POST',
        contentType: 'application/json',
        data: JSON.stringify(editRows),
        success : function(result) {
        	console.log('updateWorkGrid');
        	console.log(editRows);
            alert("저장되었습니다.");
            getWorkList();
        },
        error : function(request,status,error) {
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
}

function saveWorkStTime(){
	var param = {
			workStInTime : $('#hour').val() + ':' + $('#minute').val() + ':00'
		};
	
	$.ajax({
	      type : 'POST',
	      url : '/work/saveWorkStTime',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      data : param,
	      success : function(result) {
	      	console.log(result);
	      	alert("출근시각이 정상적으로 저장되었습니다.");
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      }
	  });
}

function getWorkStTime(){
	$.ajax({
	      type : 'POST',
	      url : '/work/getWorkStTime',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      success : function(result) {
	    	  console.log(result);
	      		$("#hour").val(result.hour);
	        	$("#minute").val(result.minute);
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      }
	  });
}



function exportExcel(){
	var gridView = workGrid.collectionView;
	var oldPgSize = gridView.pageSize;
	var oldPgIndex = gridView.pageIndex;

    //전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
    workGrid.beginUpdate();
    workView.pageSize = 0;

    wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(workGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'workList.xlsx',
	      saved => {
	    	gridView.pageSize = oldPgSize;
	    	gridView.moveToPage(oldPgIndex);
	    	workGrid.endUpdate();
	      }, null
	 );
}

</script>



<body onload="pageLoad();">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">근태관리</h2>
                <div class="main_utility">
                    <form action="#" method="post">
                        <label for="Date">조회일</label>
                        <input type="date" id="fromDate"  onfocusout="_fnisDate(this.value, this.id); _searchDateVal(this.value, toDate.value, );" onkeyup="enterkey();">
                        -
                        <input type="date" id="toDate" onfocusout="_fnisDate(this.value, this.id); _searchDateVal(fromDate.value, this.value);" onkeyup="enterkey();">
                    </form>
                    <div class="btn_wrap">
                        <label for="">출근시각</label>
                        <input type="text" class="nar" id="hour" onchange="saveWorkStTime()">:
                        <input type="text" class="nar" id="minute" onchange="saveWorkStTime()">
                        <button class="btn stroke" onClick="exportExcel();">엑셀다운로드</button>
                    </div>
                </div>
                 <!-- 필터 영역 main_filter-->
                 <div class="main_filter">
                    <form action="#" id="search_form" name="search_form" onsubmit="return false;">
                        <label for="con">검색조건</label>
                        <select name="con" id="con">
                            <option value="all" selected="selected">전체</option>
                            <option value="staffName">담당자명</option>
                            <option value="bldgName">건물명</option>
                        </select>
                        <label for="inq" onkeyup="enterkey();">조회</label>
                        <input id="inq" type="text" placeholder=",로 다중검색 가능" onkeyup="enterkey();">
                        <button type="button" class="main_filter_btn" onClick="getWorkList();"><i>조회</i></button>
                    </form>
                    <div class="summary">
                        <dl>
                            <dt>근로일수</dt>
                            <dd id='workingDay'>0일</dd>
                        </dl>
                        <dl>
                            <dt>근무시간</dt>
                            <dd id='workHour'>0시간</dd>
                        </dl>
                        <dl>
                            <dt>지각횟수</dt>
                            <dd id='lateCnt'>0회</dd>
                        </dl>
                    </div>
                </div>
                <!-- 보드 영역 main_dashboard-->
                <div class="main_dashboard">
                    <div class="sub_cont">
                        <button type="button" class="btn round" onClick="addRow()"><span>+</span> 근태추가</button>
                        <div class="btn_wrap">
                            <select id="workGridPageCount" onchange="getWorkList()">
                                <option value="100">100개씩</option>
                                <option value="50">50개씩</option>
                                <option value="30" selected="selected">30개씩</option>
                            </select>
                            <button type="button" class="btn stroke" onClick="_getUserGridLayout('workLayout', workGrid);">칼럼위치저장</button>
                            <button type="button" class="btn stroke" onClick="_resetUserGridLayout('workLayout', workGrid, workColumns);">칼럼초기화</button>
                            <button type="button" class="btn" onClick="saveGrid();">저장</button>
                        </div>
                    </div>
                    <div class="grid_wrap" style="position:relative;">
                    	<div id="workGrid" ></div>
                        <div id="workGridPager" class="pager"></div>
                    </div>
                    <div class="sub_cont">
                        <div class="btn_wrap">
                            <button type="button" class="btn" onClick="saveGrid();">저장</button>
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