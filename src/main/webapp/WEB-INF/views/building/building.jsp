<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

 <script type="text/javascript">
 
 var buildingView;
 var buildingGridPager;
 var buildingGrid;
 var buildingColumns;
 var buildingSelector;
 
 var editGrid;
 var editGridView;
 
 var memberId = "<%=session.getAttribute("id")%>";
 var memberAuth = "<%=session.getAttribute("auth")%>";
 var dupCheck = false;
 var authList;

 function pageLoad(){
 	sessionCheck(memberId, memberAuth, 'building');
 	
 	$('#building').addClass("current");
 	
 	loadGridList('init');
 	getBuildingTotal();
 }

 function enterkey() {
     if (window.event.keyCode == 13) {
     	getBuildingList();
     }
 }

//그리드 초기 셋팅
function loadGridList(type, result){
	  if(type == "init"){
		   buildingView = new wijmo.collections.CollectionView(result, {
		       pageSize: 100
		   });
		    
		   buildingGridPager = new wijmo.input.CollectionViewNavigator('#buildingGridPager', {
		        byPage: true,
		        headerFormat: '{currentPage:n0} / {pageCount:n0}',
		        cv: buildingView
		    });
		   
		   authList = new wijmo.grid.DataMap(getAuthList(), 'id', 'name');
		   buildingColumns = [
			   { isReadOnly: true, width: 35, align:"center"},
		      { binding: 'areaNm', header: '지역', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'bldgNm', header: '건물명', isReadOnly: false, width: 200, align:"center"  },
		      { binding: 'auth', header: '건물분류', isReadOnly: false, width: 150, align:"center", dataMap: authList, dataMapEditor: 'DropDownList' },
		      { binding: 'bldgCd', header: '건물코드', isReadOnly: true, width: 200, align:"center" , visible: false },
		      { binding: 'dtlAddr', header: '상세주소', isReadOnly: true, width: 400, align:"center"},
		      { binding: 'memo', header: '메모', isReadOnly: false, width: '*', align:"center"  },
		      { binding: 'activeYn', header: '활성화', isReadOnly: false, width: 60 },
		      { binding: 'cretDt', header: '생성일', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'edit', header: '정보수정', width: 100, align:"center",
		    	  cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
		              text: '<b>수정</b>',
		              click: (e, ctx) => {
		            	  showPop('modify_building');
		              }
		              
		    	  })
		      }
		    ];
		  
		   buildingGrid = new wijmo.grid.FlexGrid('#buildingGrid', {
			    autoGenerateColumns: false,
			    alternatingRowStep: 0,
			    columns: buildingColumns,
			    itemsSource: buildingView
			  });
			  
		   buildingGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        }; 
	        
	        editGrid = new wijmo.grid.FlexGrid('#editGrid', {
	            itemsSource: buildingView.itemsEdited,
	            isReadOnly: true
	        });
	    
		   	_setUserGridLayout('buildingLayout', buildingGrid, buildingColumns);
		   	
		 // 체크박스 생성
	        buildingSelector = new wijmo.grid.selector.Selector(buildingGrid);
	        buildingSelector.column = buildingGrid.columns[0];
	        
	  }else{
		  buildingView = new wijmo.collections.CollectionView(result, {
		       pageSize: Number($('#buildingGridPageCount').val()),
		       trackChanges: true
		   });
		  buildingGridPager.cv = buildingView;
		  buildingGrid.itemsSource = buildingView;
	  }
	  
	  refreshPaging(buildingGrid.collectionView.totalItemCount, 1, buildingGrid, 'buildingGrid');  // 페이징 초기 셋팅
	  
}

function getBuildingTotal(){
	$.ajax({
	      type : 'POST',
	      url : '/building/getBuildingTotal',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      success : function(result) {
	      	console.log(result);
	      	$("#bldgTotalOwn").text(Number(result.bldgtotalown).toLocaleString('ko-KR')+ "개");
	        $("#bldgTotalMnFact").text(Number(result.bldgtotalmnfact).toLocaleString('ko-KR')+ "개");
	        $("#bldgTotalFinFact").text(Number(result.bldgtotalfinfact).toLocaleString('ko-KR')+ "개");
	       
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      }
	  });
}


//건물 리스트 조회
function getBuildingList(){
	var param = {
		con 	: $('#con').val()
		, inq 	: $('#inq').val()
	};
	
	$.ajax({
     type : 'POST',
     url : '/building/getBuildingList',
     dataType : null,
     data : param,
     success : function(result) {
     	console.log("getBuildingList success");
     	loadGridList('search', result);
     	getBuildingTotal();
     },
     error: function(request, status, error) {
     	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

     }
 }); 
}

function popBuildingQrList(){
	var item = buildingGrid.rows.filter(r => r.isSelected);
	var selectBldg;
	
	if(item.length == 0){
        alert("선택된 행이 없습니다.");
        return false;
    }else{
    	selectBldg = item[0].dataItem.bldgCd;
    	for(var i =1; i< item.length ; i++){
    		selectBldg += ','+item[i].dataItem.bldgCd;
        }
    	
    	var win = window.open("/building/getBuildingQrList?selectBldg="+selectBldg, "PopupWin", "width=1000,height=600");

    }
}

function saveGrid(){
    var editItem = buildingView.itemsEdited;
    var rows = [];
    for(var i =0; i< editItem.length ; i++){
        if(editItem[i].bldgNm == "" || editItem[i].bldgNm== null){
            alert("건물명을 입력하세요.");
            return false;
            
        }
        rows.push(editItem[i]);
    }
    if(confirm("저장하시겠습니까?")){
    // 기본정보 저장
        $.ajax({
            url : "/building/updateBuildingGrid",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            contentType: 'application/json',
            data: JSON.stringify(rows),
            success : function(result) {
                alert("저장되었습니다.");
                getBuildingList();
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
    }
}


//팝업 오픈
function showPop(pop){
	if(pop == "new_building"){
		dupCheck = false;
		
		newBuildingForm.areaNm.value = "";
		newBuildingForm.areaCd.value = "";
		newBuildingForm.dtlAddr.value = "";
		newBuildingForm.bldgNm.value = "";
		newBuildingForm.memo.value = "";
		//$("input:radio[name='newAuth']").prop('checked', false);
		
		$.ajax({
            url : "/building/getNewBldgCd",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            cache : false,
            dataType : 'text',
            success : function(data) {
            	console.log(data);
            	newBuildingForm.bldgCd.value = data;
            },
            error : function(request,status,error) {
             	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
          });
		
	}else if(pop == "modify_building"){
		dupCheck = true;
		
		updateBuildingForm.active.checked = (buildingGrid.collectionView.currentItem["activeYn"] == true ? true : false );
		updateBuildingForm.areaNm.value = buildingGrid.collectionView.currentItem["areaNm"];
		updateBuildingForm.areaCd.value = buildingGrid.collectionView.currentItem["areaCd"];
		updateBuildingForm.dtlAddr.value = buildingGrid.collectionView.currentItem["dtlAddr"];
		updateBuildingForm.bldgNm.value = buildingGrid.collectionView.currentItem["bldgNm"];
		updateBuildingForm.bldgCd.value = buildingGrid.collectionView.currentItem["bldgCd"];
		updateBuildingForm.memo.value = buildingGrid.collectionView.currentItem["memo"];
		$("input:radio[name='modifyAuth']:radio[value='"+buildingGrid.collectionView.currentItem["auth"]+"']").prop('checked', true); 
		console.log(buildingGrid.collectionView.currentItem["auth"]);
	}
	
	$('#'+pop).addClass('is_on');
}

//팝업 종료
function closePop(){
	$('.popup').removeClass('is_on');
}

function dupBuildingCheck(type){
    var form;
    if(type=="new"){
        form = newBuildingForm;
    }else if(type == 'modify'){
        form = updateBuildingForm;
    }
    if(form.areaCd.value == "" ){
        alert("지역검색을 먼저 하시기 바랍니다.");
        return false;
        
    }else if(form.dtlAddr.value == "" ){
        alert("상세주소를 입력 하시기 바랍니다.");
        return false;
    }
    var params = {
            areaCd : form.areaCd.value,
            dtlAddr : form.dtlAddr.value
    	}
    	$.ajax({
            url : "/building/dupCheckBuilding",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            data : params,
            success : function(result) {
        	    if(result == "true"){
                    alert("이미 존재하는 주소입니다.");
                    dupCheck = false;
                    return false;
                }else{
                    alert("등록 가능합니다.");
                    dupCheck = true;
                }
            },
            error : function(request,status,error) {
             	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
}

function findAddr(){
    var pop = window.open("/building/p_addr","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}

var jusoCallBack = function(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr,jibunAdddr,zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn,buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo){     
    newBuildingForm.areaCd.value = admCd.substring(0,2);
    newBuildingForm.areaNm.value = siNm;
    newBuildingForm.dtlAddr.value = roadAddrPart1 + " " + addrDetail;
    
    updateBuildingForm.areaCd.value = admCd.substring(0,2);
    updateBuildingForm.areaNm.value = siNm;
    updateBuildingForm.dtlAddr.value = roadAddrPart1 + " " + addrDetail;
}


//건물 추가 
function saveBuilding(){
  	//필수값 체크
	if($(':radio[name="newAuth"]:checked').length < 1){
        alert("건물분류를 선택해주세요.");
        return false;
        
    }else if(newBuildingForm.areaCd.value == ""){
          alert("지역 검색을 해주세요.");
          newBuildingForm.areaCd.focus();
          return false;
          
      }else if(newBuildingForm.dtlAddr.value == ""){
      	alert("상세주소를 입력해주세요.");
          newBuildingForm.dtlAddr.focus();
          return false;
          
      }else if(newBuildingForm.bldgNm.value == ""){
      	alert("건물명을 입력해주세요.");
          newBuildingForm.bldgNm.focus();
          return false;
          
      }
      
      //중복확인 
      if(!dupCheck){
      	alert('중복확인을 해주세요.');
      	return false;
      	
      }else{
      	var params = {
      		areaNm 		:	newBuildingForm.areaNm.value
      		,areaCd:	newBuildingForm.areaCd.value
      		,dtlAddr	:	newBuildingForm.dtlAddr.value
      		,bldgNm:	newBuildingForm.bldgNm.value
      		,bldgCd	:	newBuildingForm.bldgCd.value
      		,memo : newBuildingForm.memo.value
      		,auth 	: $('input[name="newAuth"]:checked').val()
      	}
      	
      	$.ajax({
              url : "/building/saveBuilding",
              async : false, // 비동기모드 : true, 동기식모드 : false
              type : 'POST',
              cache : false,
              dataType : 'text',
              data : params,
              success : function(data) {
                  alert("건물 추가가 완료되었습니다.");
                  closePop();
                  getBuildingList();
              },
              error : function(request,status,error) {
               	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
              }
            });
      }
  }

  function deleteBuilding(){
  	if(confirm("삭제하시겠습니까?")){
  		var params = {
         	id : updateBuildingForm.bldgCd.value
     	};
  		
  		$.ajax({
           url : '/building/deleteBuilding',
           async : false, // 비동기모드 : true, 동기식모드 : false
           type : 'POST',
           cache : false,
           dataType : null,
           data : params,
           success : function(data) {
           	alert('정상적으로 삭제되었습니다.');
           	closePop();
           	getBuildingList();
           },
           error : function(request,status,error) {
             alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
           }
     });
  	}
  }

  function updateBuilding(){
  	//필수값 체크
	  if($(':radio[name="modifyAuth"]:checked').length < 1){
	        alert("건물분류를 선택해주세요.");
	        return false;
	        
	    }else if(updateBuildingForm.areaCd.value == ""){
          alert("지역 검색을 해주세요.");
          updateBuildingForm.areaCd.focus();
          return false;
          
      }else if(updateBuildingForm.dtlAddr.value == ""){
      	alert("상세주소를 입력해주세요.");
      	updateBuildingForm.dtlAddr.focus();
          return false;
          
      }else if(updateBuildingForm.bldgNm.value == ""){
      	alert("건물명을 입력해주세요.");
      	updateBuildingForm.bldgNm.focus();
          return false;
          
      }
  	
	//중복확인 
      if(!dupCheck){
      	alert('중복확인을 해주세요.');
      	return false;
      	
      }else{
      	var params = {
      		areaNm 	: updateBuildingForm.areaNm.value
      		,areaCd : updateBuildingForm.areaCd.value
      		,dtlAddr: updateBuildingForm.dtlAddr.value
      		,bldgNm	: updateBuildingForm.bldgNm.value
      		,bldgCd	: updateBuildingForm.bldgCd.value
      		,memo 	: updateBuildingForm.memo.value
      		,activeYn: (updateBuildingForm.active.checked ? true : false )
      		,auth : $('input[name="modifyAuth"]:checked').val()
      	}
      	
      	$.ajax({
              url : "/building/updateBuilding",
              async : false, // 비동기모드 : true, 동기식모드 : false
              type : 'POST',
              cache : false,
              dataType : 'text',
              data : params,
              success : function(data) {
                  alert("건물 수정이 완료되었습니다.");
                  closePop();
                  getBuildingList();
              },
              error : function(request,status,error) {
               	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
              }
            });
      }
  }
  
//건물분류 동적으로 가져오기
  function getAuthList() {
  	var returnVal;
  	var param = {
  			cd 	: 'bldgType'
  		};
  	
      $.ajax({
              url : "/code/getCodeList",
              async : false, // 비동기모드 : true, 동기식모드 : false
              type : 'POST',
              data : param,
              success : function(result) {
              	
              	console.log(result);
              	
              	var authList = [];
                  if(result.length > 0){
                  	
                  	for(var i =0; i<result.length; i++){
                  		authList[i] = { id: result[i].cd, name: result[i].nm };	
                  	}
                  	
                  }else{
                  	authList[0] = { id: null, name: null };	
                  }
                  returnVal = authList;
              },
              error : function(request,status,error) {
                  alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
              }
      });
      
      return returnVal;
  }

  function exportExcel(){
  	var gridView = buildingGrid.collectionView;
  	var oldPgSize = gridView.pageSize;
  	var oldPgIndex = gridView.pageIndex;

   	//전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
  	buildingGrid.beginUpdate();
  	buildingView.pageSize = 0;

   	wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(buildingGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'BuildingrList.xlsx',
  	      saved => {
  	    	gridView.pageSize = oldPgSize;
  	    	gridView.moveToPage(oldPgIndex);
  	    	buildingGrid.endUpdate();
  	      }, null
  	 );
  }
  
function dupChceckFalse(){
    dupCheck = false;
}

 </script>

<body onload="pageLoad();">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
        
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">건물관리</h2>
                <div class="main_summary quarter">
                    <dl>
                        <dt>자사건물</dt>
                        <dd id="bldgTotalOwn">0개</dd>
                    </dl>
                    <dl>
                        <dt>가공업체</dt>
                        <dd id="bldgTotalMnFact">0개</dd>
                    </dl>
                    <dl>
                        <dt>마감업체</dt>
                        <dd id="bldgTotalFinFact">0개</dd>
                    </dl>
                    <!-- 클릭시 팝업창 띄움 -->
                    <a href="javascript:void(0);" class="popup_trigger" onclick="showPop('new_building');"><i></i>건물추가</a>
                </div>
                <div class="main_utility">
                    <div class="btn_wrap">
                        <button class="btn stroke" onClick="exportExcel();">엑셀다운로드</button>
                    </div>
                </div>
                <div class="main_content">
                    <!-- 필터 영역 main_filter-->
                    <div class="main_filter">
                        <form action="#" id="search_form" name="search_form" onsubmit="return false;">
                            <label for="con">검색조건</label>
                            <select name="con" id="con">
                                <option value="all" selected="selected">전체</option>
                                <option value="area">지역</option>
                                <option value="bulName">건물명</option>
                            </select>
                            <label for="inq" onkeyup="enterkey();">조회</label>
                            <input id="inq" type="text" placeholder=",로 다중검색 가능" onkeyup="enterkey();">
                            <button type="button" class="main_filter_btn" onClick="getBuildingList();"><i>조회</i></button>
                        </form>
                    </div>
                    <!-- 보드 영역 main_dashboard-->
                    <div class="main_dashboard">
                        <div class="sub_cont">
                            <div class="btn_wrap">
                                <select id="buildingGridPageCount" id="buildingGridPageCount" onchange="getBuildingList()">
                                    <option value="100">100개씩</option>
                                    <option value="50">50개씩</option>
                                    <option value="30" selected="selected">30개씩</option>
                                </select>
                                <button type="button" class="btn stroke" onClick="_getUserGridLayout('buildingLayout', buildingGrid);">칼럼위치저장</button>
                                <button type="button" class="btn stroke" onClick="_resetUserGridLayout('buildingLayout', buildingGrid, buildingColumns);">칼럼초기화</button>
                                <button type="button" class="btn" onClick="popBuildingQrList();">QR출력</button>
                                <button type="button" class="btn" onClick="saveGrid();">저장</button>
                            </div>
                        </div>
                        <div class="grid_wrap">
                        	<div id="buildingGrid" ></div>
                        	<div id="buildingGridPager" class="pager"></div>
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
        <!-- 팝업 -->
    <!-- 팝업 : 건물추가 추가-->
    <div class="popup" id="new_building">
        <div class="popup_container">
            <div class="popup_head">
                <p class="popup_title">건물추가</p>
                <button type="button" class="popup_close" onClick="closePop();">x</button>
            </div>
            <div class="popup_inner">
                <dfn>필수항목 <i>*</i></dfn>
                <form id="newBuildingForm" onsubmit="return false;">
                    <table>
                        <tbody>
                        	<tr>
                                <th>건물분류<i>*</i></th>
                                <td>
                                    <input type="radio" value="own" id="own" name="newAuth" checked>
                                    <label for="own">자사</label>
                                    <input type="radio" value="mnFact" id="mnFact" name="newAuth">
                                    <label for="mnFact">가공업체</label>
                                    <input type="radio" value="finFact" id="finFact" name="newAuth">
                                    <label for="finFact">마감업체</label>
                                </td>
                            </tr>
                            <tr>
                                <th>지역<i>*</i></th>
                                <td>
                                    <input type="text" id="areaNm" name="areaNm" required readonly>
                                    <input type="text" id="areaCd" name="areaCd" style="display:none;">
                                    <button type="button" class="btn att" onClick="findAddr();">검색</button>
                                </td>
                            </tr>
                            <tr>
                                <th>상세주소<i>*</i></th>
                                <td>
                                    <input type="text" id="dtlAddr" class="wide" name="dtlAddr">
                                    <button class="btn att" onClick="dupBuildingCheck('new');">중복확인</button>
                                </td>
                            </tr>
                            <tr>
                                <th>건물명<i>*</i></th>
                                <td>
                                    <input type="text" id="bldgNm" name="bldgNm">
                                </td>
                            </tr>
                            <tr>
                                <th>건물번호<i>*</i></th>
                                <td>
                                    <input type="text" id="bldgCd" name="bldgCd" required readonly>
                                </td>
                            </tr>
                            <tr>
                                <th>메모</th>
                                <td>
                                    <textarea name="memo" id="memo" cols="30" rows="10"></textarea>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
                <div class="popup_btn_area">
                    <button type="button" class="btn confirm" onClick="saveBuilding();">추가</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 계정추가 팝업 영역 끝-->
    <!-- 팝업 : 정보 수정 -->
    <div class="popup" id="modify_building">
        <div class="popup_container">
            <div class="popup_head">
                <p class="popup_title">정보수정</p>
                <button type="button" class="popup_close" onClick="closePop()">x</button>
            </div>
            <div class="popup_inner">
                <dfn>필수항목 <i>*</i></dfn>
                <form id="updateBuildingForm" onsubmit="return false;">
                    <table>
                        <tbody>
                        	<tr>
                                <th>건물분류<i>*</i></th>
                                <td>
                                    <input type="radio" value="own" id="own2" name="modifyAuth" >
                                    <label for="own2">자사</label>
                                    <input type="radio" value="mnFact" id="mnFact2" name="modifyAuth">
                                    <label for="mnFact2">가공업체</label>
                                    <input type="radio" value="finFact" id="finFact2" name="modifyAuth">
                                    <label for="finFact2">마감업체</label>
                                </td>
                            </tr>
                            <tr>
                                <th>활성화</th>
                                <td>
                                    <input type="checkbox" id="active" name="active" checked>
                                    <label for="active">체크 시, 활성화</label>
                                </td>
                            </tr>
                            <tr>
                                <th>지역<i>*</i></th>
                                <td>
                                    <input type="text" id="areaNm" name="areaNm" required readonly>
                                    <input type="text" id="areaCd" name="areaCd" style="display:none;">
                                    <button type="button" class="btn att" onClick="findAddr();">검색</button>
                                </td>
                            </tr>
                            <tr>
                                <th>상세주소<i>*</i></th>
                                <td>
                                    <input type="text" id="dtlAddr" class="wide" name="dtlAddr" required onChange="dupChceckFalse();">
                                    <button class="btn att" onClick="dupBuildingCheck('modify');">중복확인</button>
                                </td>
                            </tr>
                            <tr>
                                <th>건물명<i>*</i></th>
                                <td>
                                    <input type="text" id="bldgNm" name="bldgNm">
                                </td>
                            </tr>
                            <tr>
                                <th>건물번호<i>*</i></th>
                                <td>
                                    <input type="text" id="bldgCd" name="bldgCd" required readonly>
                                </td>
                            </tr>
                            <tr>
                                <th>메모</th>
                                <td>
                                    <textarea name="memo" id="memo" cols="30" rows="10"></textarea>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
                <div class="popup_btn_area">
                    <button type="button" class="btn stroke" onClick="updateBuilding();">수정</button>
                    <button type="button" class="btn fill" onClick="deleteBuilding();">삭제</button>
                </div>
            </div>
        </div>
    </div>
    <!--정보수정 팝업 영역 끝-->
    </div>
    
    <div class="grid_wrap" id="editDiv" style="display:none;">
        <div id="editGrid" ></div>
    </div>
</body>
</html>