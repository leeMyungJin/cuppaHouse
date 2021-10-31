<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
</head>

<script type="text/javascript">

var memberView;
var memberGridPager;
var memberGrid;
var memberColumns;
var dupCheckIdFlag = false;
var authList;
var buildingList;

var memberId = "<%=session.getAttribute("id")%>";
var memberAuth = "<%=session.getAttribute("auth")%>";

function pageLoad(){
	sessionCheck(memberId, memberAuth, 'member');
	
	$('#member').addClass("current");
	
	loadGridList('init');
	
	//getMemberList();
	getMemberTotal();
	getAppversion();
	getBldgDtlSelect();
}

function enterkey() {
    if (window.event.keyCode == 13) {
    	getMemberList();
    }
}

//그리드 초기 셋팅
function loadGridList(type, result){
	  if(type == "init"){
		   memberView = new wijmo.collections.CollectionView(result, {
		       pageSize: 100
		   });
		    
		   memberGridPager = new wijmo.input.CollectionViewNavigator('#memberGridPager', {
		        byPage: true,
		        headerFormat: '{currentPage:n0} / {pageCount:n0}',
		        cv: memberView
		    });
		   
		   authList = new wijmo.grid.DataMap(getAuthList(), 'id', 'name');
		   buildingList = new wijmo.grid.DataMap(getBldgDtl(), 'id', 'name');
		   memberColumns = [
		      { binding: 'name', header: '이름', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'id', header: 'ID', isReadOnly: true, width: 200, align:"center"  },
		      { binding: 'auth', header: '접근권한', isReadOnly: true, width: 80, align:"center", dataMap: authList, dataMapEditor: 'DropDownList' },
		      { binding: 'bldgCd', header: '건물', isReadOnly: true, width: 150, align:"center", dataMap: buildingList, dataMapEditor: 'DropDownList' },
		      { binding: 'activeYn', header: '활성화', isReadOnly: true, width: 60 },
		      { binding: 'pnum', header: '전화번호', isReadOnly: true, width: 120, align:"center"  },
		      { binding: 'position', header: '직급', isReadOnly: true, width: 100, align:"center" },
		      { binding: 'memo', header: '메모', isReadOnly: true, width: '*', align:"center" },
		      { binding: 'lateassDt', header: '최근접속일', isReadOnly: true, width: 100 , align:"center" },
		      { binding: 'cretDt', header: '계정생성일', isReadOnly: true, width: 100 , align:"center" },
		      { binding: 'edit', header: '정보수정', width: 100, align:"center",
		    	  cellTemplate: wijmo.grid.cellmaker.CellMaker.makeButton({
		              text: '<b>수정</b>',
		              click: (e, ctx) => {
		            	  showPop('modify_member');
		              }
		              
		    	  })
		      }
		    ];
		  
		   memberGrid = new wijmo.grid.FlexGrid('#memberGrid', {
			    autoGenerateColumns: false,
			    alternatingRowStep: 0,
			    columns: memberColumns,
			    itemsSource: memberView
			  });
			  
		   memberGrid.itemFormatter = function (panel, r, c, cell) { 
	            if (panel.cellType == wijmo.grid.CellType.RowHeader) {
	                cell.textContent = (r + 1).toString();
	            }
	        }; 
		   
		   	_setUserGridLayout('memberLayout', memberGrid, memberColumns);
			  
	  }else{
		  memberView = new wijmo.collections.CollectionView(result, {
		       pageSize: Number($('#memberGridPageCount').val())
		   });
		  memberGridPager.cv = memberView;
		  memberGrid.itemsSource = memberView;
	  }
	  
	  refreshPaging(memberGrid.collectionView.totalItemCount, 1, memberGrid, 'memberGrid');  // 페이징 초기 셋팅
	  
}

function getMemberTotal(){
	$.ajax({
	      type : 'POST',
	      url : '/member/getMemberTotal',
	      async : false, // 비동기모드 : true, 동기식모드 : false
	      dataType : null,
	      success : function(result) {
	      	console.log(result);
	      	$("#adminTotal").text(Number(result.admintotal).toLocaleString('ko-KR')+ "명");
	        $("#nonAdminTotal").text(Number(result.nonadmintotal).toLocaleString('ko-KR')+ "명");
	      },
	      error: function(request, status, error) {
	      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	      }
	  });
}


// 멤버 리스트 조회
function getMemberList(){
	var param = {
		con 	: $('#con').val()
		, inq 	: $('#inq').val()
	};
	
	$.ajax({
      type : 'POST',
      url : '/member/getMemberList',
      dataType : null,
      data : param,
      success : function(result) {
      	console.log("getMemberList success");
      	loadGridList('search', result);
      	getMemberTotal();
      },
      error: function(request, status, error) {
      	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

      }
  }); 
}

//분류 동적으로 가져오기
function getAuthList() {
	var returnVal;
	var param = {
			cd 	: 'position'
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

//팝업 오픈
function showPop(pop){
	if(pop == "new_member"){
		dupCheckIdFlag = false;
		
		newMemberForm.id.value = "";
		newMemberForm.password.value = "";
		newMemberForm.chckpw.value = "";
		newMemberForm.name.value = "";
		newMemberForm.telPhone.value = "";
		newMemberForm.memo.value = "";
		newMemberForm.position.value = "";
		newMemberForm.dept.value = "";
		$("input:radio[name='newAuth']").prop('checked', false);
		$('#bldgCd').val('all');
		
		//관리자, 자사지원만 직급, 부서 입력 가능
		var newAuth = $('input[name="newAuth"]:checked').val();
		if(newAuth == "admin" || newAuth == "own"){
			$("#trPosition_new").removeClass('displaynone');
			$("#trDept_new").removeClass('displaynone');
			
		}else{
			$("#trPosition_new").addClass('displaynone');
			$("#trDept_new").addClass('displaynone');
			
		}
		
	}else if(pop == "modify_member"){
		updateMemberForm.active.checked = (memberGrid.collectionView.currentItem["activeYn"] == true ? true : false );
		updateMemberForm.id.value = memberGrid.collectionView.currentItem["id"];
		updateMemberForm.password.value = "";
		updateMemberForm.chckpw.value = "";
		updateMemberForm.name.value = memberGrid.collectionView.currentItem["name"];
		updateMemberForm.telPhone.value = memberGrid.collectionView.currentItem["pnum"];
		updateMemberForm.memo.value = memberGrid.collectionView.currentItem["memo"];
		updateMemberForm.position.value = memberGrid.collectionView.currentItem["position"];
		updateMemberForm.dept.value = memberGrid.collectionView.currentItem["dept"];
		$("input:radio[name='modifyAuth']:radio[value='"+memberGrid.collectionView.currentItem["auth"]+"']").prop('checked', true); 
		$("#bldgCd2").val(memberGrid.collectionView.currentItem["bldgCd"]);
		
		//관리자, 자사지원만 직급, 부서 입력 가능
		var modifyAuth = $('input[name="modifyAuth"]:checked').val();
		if(modifyAuth == "admin" || modifyAuth == "own"){
			$("#trPosition_modify").removeClass('displaynone');
			$("#trDept_modify").removeClass('displaynone');
			
		}else{
			$("#trPosition_modify").addClass('displaynone');
			$("#trDept_modify").addClass('displaynone');
			
		}
		
	}

	$('#'+pop).addClass('is_on');
}

//팝업 종료
function closePop(){
	$('.popup').removeClass('is_on');
}

//직원추가 
function saveNewMember(){
	//필수값 체크
	if( $(':radio[name="newAuth"]:checked').length < 1 ){
        alert("접근권한을 선택해주세요.");
        return false;
        
	}else if(newMemberForm.id.value == ""){
        alert("아이디를 입력해주세요.");
        newMemberForm.id.focus();
        return false;
        
    }else if(newMemberForm.password.value == ""){
    	alert("비밀번호를 입력해주세요.");
        newMemberForm.password.focus();
        return false;
        
    }else if(newMemberForm.chckpw.value == ""){
    	alert("비밀번호 확인을 입력해주세요.");
        newMemberForm.chckpw.focus();
        return false;
        
    }else if(newMemberForm.name.value == ""){
    	alert("이름/업체명을 입력해주세요.");
        newMemberForm.name.focus();
        return false;
        
    }else if(newMemberForm.telPhone.value == ""){
    	alert("전화번호를 입력해주세요.");
        newMemberForm.telPhone.focus();
        return false;
        
    }else if($('#bldgCd option:selected').val() == "all"){
    	alert("건물을 선택해주세요.");
        newMemberForm.bldgCd.focus();
        return false;
        
    }
	
	//벨리데이션 체크 
	var idRule1  = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	var pwdRule1  = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{10,}$/;
    var pwdRule2  = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,}$/;
    var pwdRule3  = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    var emailRule = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
    var telRule1   = /^[0-9]{11}$/;
    var telRule2   = /^\d{2,3}-\d{3,4}-\d{4}$/;
    
    if(!emailRule.test(newMemberForm.id.value)){
    	alert("ID는 aaaa@aaaa.aaa 형식으로 작성해주시기 바랍니다.");
    	newMemberForm.id.focus();
    	return false;
    }else if(!pwdRule1.test(newMemberForm.password.value) && !pwdRule2.test(newMemberForm.password.value) && !pwdRule3.test(newMemberForm.password.value)){
    	alert("비밀번호를 확인하시기 바랍니다.\n비밀번호는 영문자(대,소문자), 숫자를 포함하여 최소 10자 이상,\n 혹은 영문자(대,소문자), 숫자, 특수문자를 포함하여 최소 8자 이상이어야 합니다.");
    	newMemberForm.password.focus();
    	return false;
    }else if(!telRule1.test(newMemberForm.telPhone.value) && !telRule2.test(newMemberForm.telPhone.value)){  // 전화번호
    	alert("전화번호를 올바르게 입력하시기 바랍니다. \n예)01012341234, 010-1234-1234");
    	newMemberForm.telPhone.focus();
        return false;
    }else if(newMemberForm.password.value != newMemberForm.chckpw.value){
    	alert("비밀번호와 비밀번호 확인이 일치하지 않습니다, \n비밀번호를 확인하시기 바랍니다.");
    	newMemberForm.chckpw.focus();
        return false;
    }
    
    //중복확인 
    if(!dupCheckIdFlag){
    	alert('중복확인을 해주세요.');
    	return false;
    	
    }else{
    	console.log($('#bldgCd option:selected').val());
    	
    	var params = {
    		id 		:	newMemberForm.id.value
    		,password:	newMemberForm.password.value
    		,name	:	newMemberForm.name.value
    		,telPhone:	newMemberForm.telPhone.value
    		,memo	:	newMemberForm.memo.value
    		,position : newMemberForm.position.value
    		,dept : newMemberForm.dept.value
    		,auth : $('input[name="newAuth"]:checked').val()
    		,bldgCd : $('#bldgCd option:selected').val()
    	}
    	
    	$.ajax({
            url : "/member/saveNewMember",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            cache : false,
            dataType : 'text',
            data : params,
            success : function(data) {
                alert("계정 추가가 완료되었습니다.");
                closePop();
                getMemberList();
            },
            error : function(request,status,error) {
             	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
          });
    }
}


//아이디 중복확인 dupCheckIdFlag
function dupCheckId(){
	
	console.log(newMemberForm.id.value);
	
	if(newMemberForm.id.value == ""){
	   alert("아이디를 입력하세요.");
	   return false;
	 }
	
	var param = {
			id : newMemberForm.id.value
	}
	
	$.ajax({
     url : "/member/dupCheckId",
     async : false, // 비동기모드 : true, 동기식모드 : false
     type : 'POST',
     cache : false,
     dataType : 'text',
     data : param,
     success : function(data) {
         if(data != ""){
           alert('이미 존재하는 아이디입니다.');
           dupCheckIdFlag = false;
         }else{
           alert('사용가능한 아이디입니다.');
           dupCheckIdFlag = true;
         }
     },
     error : function(request,status,error) {
      alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
     }
   });
}

function deleteMember(){
	if(confirm("삭제하시겠습니까?")){
		var params = {
       	id : updateMemberForm.id.value
   	};
		
		$.ajax({
         url : '/member/deleteMember',
         async : false, // 비동기모드 : true, 동기식모드 : false
         type : 'POST',
         cache : false,
         dataType : null,
         data : params,
         success : function(data) {
         	alert('정상적으로 삭제되었습니다.');
         	closePop();
         	getMemberList();
         },
         error : function(request,status,error) {
           alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
         }
   });
	}
}

function updateMember(){
	//필수값 체크
	if( $(':radio[name="modifyAuth"]:checked').length < 1 ){
        alert("접근권한을 선택해주세요.");
        return false;
        
	}else /* if(updateMemberForm.password.value == ""){
    	alert("비밀번호를 입력해주세요.");
    	updateMemberForm.password.focus();
        return false;
        
    }else if(updateMemberForm.chckpw.value == ""){
    	alert("비밀번호 확인을 입력해주세요.");
    	updateMemberForm.chckpw.focus();
        return false;
        
    }else */ if(updateMemberForm.name.value == ""){
    	alert("이름/업체명을 입력해주세요.");
    	updateMemberForm.name.focus();
        return false;
        
    }else if(updateMemberForm.telPhone.value == ""){
    	alert("전화번호를 입력해주세요.");
    	updateMemberForm.telPhone.focus();
        return false;
        
    }else if($('#bldgCd2 option:selected').val() == "all"){
    	alert("건물을 선택해주세요.");
    	updateMemberForm.bldgCd2.focus();
        return false;
        
    }
	
	//벨리데이션 체크 
	var idRule1  = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	var pwdRule1  = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{10,}$/;
    var pwdRule2  = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,}$/;
    var pwdRule3  = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    var emailRule = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
    var telRule1   = /^[0-9]{11}$/;
    var telRule2   = /^\d{2,3}-\d{3,4}-\d{4}$/;
    
    if(updateMemberForm.password.value != '' && !pwdRule1.test(updateMemberForm.password.value) && !pwdRule2.test(updateMemberForm.password.value) && !pwdRule3.test(updateMemberForm.password.value)){
    	alert("비밀번호를 확인하시기 바랍니다.\n비밀번호는 영문자(대,소문자), 숫자를 포함하여 최소 10자 이상,\n 혹은 영문자(대,소문자), 숫자, 특수문자를 포함하여 최소 8자 이상이어야 합니다.");
    	updateMemberForm.password.focus();
    	return false;
    }else if(!telRule1.test(updateMemberForm.telPhone.value) && !telRule2.test(updateMemberForm.telPhone.value)){  // 전화번호
    	alert("전화번호를 올바르게 입력하시기 바랍니다. \n예)01012341234, 010-1234-1234");
    	updateMemberForm.telPhone.focus();
        return false;
    }else if(updateMemberForm.password.value != updateMemberForm.chckpw.value){
    	alert("비밀번호와 비밀번호 확인이 일치하지 않습니다, \n비밀번호를 확인하시기 바랍니다.");
    	updateMemberForm.chckpw.focus();
        return false;
    }
 
 var params = {
		active 		: (updateMemberForm.active.checked ? true : false )
    	, id 		: updateMemberForm.id.value
    	, password 	: updateMemberForm.password.value
    	, name 		: updateMemberForm.name.value
    	, telPhone 	: updateMemberForm.telPhone.value	
    	, memo 		: updateMemberForm.memo.value	
    	, position 	: updateMemberForm.position.value	
    	, dept 		: updateMemberForm.dept.value	
    	, auth 		: $('input[name="modifyAuth"]:checked').val()
    	,bldgCd : $('#bldgCd2 option:selected').val()
 }
 
 $.ajax({
     url : "/member/updateMember",
     async : false, // 비동기모드 : true, 동기식모드 : false
     type : 'POST',
     cache : false,
     dataType : 'text',
     data : params,
     success : function(data) {
     	alert('정상적으로 수정되었습니다.');
     	closePop();
     	getMemberList();
     },
     error : function(request,status,error) {
      alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
     }
   });
}

function exportExcel(){
	
	var gridView = memberGrid.collectionView;
	var oldPgSize = gridView.pageSize;
	var oldPgIndex = gridView.pageIndex;

 	//전체 데이터를 엑셀다운받기 위해서는 페이징 제거 > 엑셀 다운 > 페이징 재적용 하여야 함.
	memberGrid.beginUpdate();
	memberView.pageSize = 0;

 	wijmo.grid.xlsx.FlexGridXlsxConverter.saveAsync(memberGrid, {includeCellStyles: true, includeColumnHeaders: true}, 'MemberList.xlsx',
	      saved => {
	    	gridView.pageSize = oldPgSize;
	    	gridView.moveToPage(oldPgIndex);
	    	memberGrid.endUpdate();
	      }, null
	 );
}

function getAppversion(){
		$.ajax({
         url : '/member/getAppVersion',
         async : false, // 비동기모드 : true, 동기식모드 : false
         type : 'POST',
         cache : false,
         dataType : null,
         success : function(data) {
         	$("#appver").val(data.appversion);
         },
         error : function(request,status,error) {
           alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
         }
   });
}

function saveAppversion(){
	var params = {
       	appversion : $('#appver').val()
   	};
		
		$.ajax({
         url : '/member/saveAppVersion',
         async : false, // 비동기모드 : true, 동기식모드 : false
         type : 'POST',
         cache : false,
         dataType : null,
         data : params,
         success : function(data) {
         	alert('정상적으로 저장되었습니다.');
         },
         error : function(request,status,error) {
           alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
         }
   });
}

function clickAuth(type){
	var newAuth = $('input[name="'+type+'Auth"]:checked').val();
	
	//관리자, 자사지원만 직급, 부서 입력 가능
	if(newAuth == "admin" || newAuth == "own"){
		$("#trPosition_"+type).removeClass('displaynone');
		$("#trDept_"+type).removeClass('displaynone');
		
	}else{
		$("#trPosition_"+type).addClass('displaynone');
		$("#trDept_"+type).addClass('displaynone');
		
	}
}

//건물 동적으로 가져오기
function getBldgDtl() {
  var returnVal;
	
  $.ajax({
          url : "/stock/getBldgList",
          async : false, // 비동기모드 : true, 동기식모드 : false
          type : 'POST',
        //  data : params,
          success : function(result) {
        	  var bldg = [];
              if(result.length > 0){
              	
              	for(var i =0; i<result.length; i++){
              		bldg[i] = { id: result[i].bldgCd, name: result[i].bldgNm };	
              	}
              	
              }else{
            	  bldg[0] = { id: null, name: null };	
              }
              returnVal = bldg;
              
              console.log(bldg);
          },
          error : function(request,status,error) {
              alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
          }
  });
  
  return returnVal;
 
}

//건물 동적으로 가져오기
function getBldgDtlSelect(){
  $.ajax({
          url : "/stock/getBldgList",
          async : false, // 비동기모드 : true, 동기식모드 : false
          type : 'POST',
        //  data : params,
          success : function(result) {
        	  
        	  if(result.length > 0){
              	$('#bldgCd').empty().append('<option selected="selected" value="all" selected>전체</option>');
              	$('#bldgCd2').empty().append('<option selected="selected" value="all" selected>전체</option>');
                  for(var i =0; i<result.length; i++){
                      $("#bldgCd").append("<option value='" + result[i].bldgCd + "'>" + result[i].bldgNm + "</option>");
                  	  $("#bldgCd2").append("<option value='" + result[i].bldgCd + "'>" + result[i].bldgNm + "</option>");
                  }
                  
              }else{
              	$('#bldgCd').empty().append('<option selected="selected" value="all" selected>전체</option>');
              	$('#bldgCd2').empty().append('<option selected="selected" value="all" selected>전체</option>');
              	
              }
          },
          error : function(request,status,error) {
              alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
          }
  });
}


</script>

<body onload="pageLoad();">
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">회원관리</h2>
                <div class="main_summary">
                    <dl>
                        <dt>전체 회원수</dt>
                        <dd id="nonAdminTotal">0개</dd>
                    </dl>
                    <dl>
                        <dt>관리자 수</dt>
                        <dd id="adminTotal">0개</dd>
                    </dl>
                    <!-- 클릭시 팝업창 띄움 -->
                    <a href="javascript:void(0);" class="popup_trigger" onclick="showPop('new_member');"><i></i>계정추가</a>
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
                                <option value="name">이름</option>
                                <option value="id">ID</option>
                            </select>
                            <label for="inq" onkeyup="enterkey();">조회</label>
                            <input id="inq" type="text" placeholder=",로 다중검색 가능" onkeyup="enterkey();">
                            <button type="button" class="main_filter_btn" onClick="getMemberList();"><i>조회</i></button>
                        </form>
                        <div class="fr">
                            <label for="">APP 버전</label>
                            <input id="appver" type="text" style="width:110px;">
                            <button type="button" class="btn att" onclick="saveAppversion();">수정</button>
                        </div>
                    </div>
                    <!-- 보드 영역 main_dashboard-->
                    <div class="main_dashboard">
                        <div class="sub_cont">
                            <div class="btn_wrap">
                                <select id="memberGridPageCount" id="memberGridPageCount" onchange="getMemberList()">
                                    <option value="100">100개씩</option>
                                    <option value="50">50개씩</option>
                                    <option value="30" selected="selected">30개씩</option>
                                </select>
                                <button type="button" class="btn stroke" onClick="_getUserGridLayout('memberLayout', memberGrid);">칼럼위치저장</button>
                                <button type="button" class="btn stroke" onClick="_resetUserGridLayout('memberLayout', memberGrid, memberColumns);">칼럼초기화</button>
                            </div>
                        </div>
                        <div class="grid_wrap" style="position:relative;">	
                        	<div id="memberGrid" ></div>
                        	<div id="memberGridPager" class="pager"></div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <!-- 팝업 -->
        <!-- 팝업 : 계정추가 추가-->
        <div class="popup" id="new_member">
            <div class="popup_container">
                <div class="popup_head">
                    <p class="popup_title">계정추가</p>
                    <button type="button" class="popup_close" onClick="closePop();">x</button>
                </div>
                <div class="popup_inner">
                    <dfn>필수항목 <i>*</i></dfn>
                    <form id="newMemberForm" onsubmit="return false;">
                        <table>
                            <tbody>
                                <tr>
                                    <th>접근권한</th>
                                    <td>
                                        <input type="radio" value="admin" id="admin" name="newAuth" checked onClick="clickAuth('new');">
                                        <label for="admin">관리자</label>
                                        <input type="radio" value="own" id="own" name="newAuth" onClick="clickAuth('new');">
                                        <label for="own">자사직원</label>
                                        <input type="radio" value="mnFact" id="mnFact" name="newAuth" onClick="clickAuth('new');">
                                        <label for="mnFact">가공업체</label>
                                        <input type="radio" value="finFact" id="finFact" name="newAuth" onClick="clickAuth('new');">
                                        <label for="finFact">마감업체</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>아이디<i>*</i></th>
                                    <td>
                                        <input type="text" class="icon" id="id" name="id" onchange="dupCheckIdFlag = false;">
                                        <button class="btn att" onClick="dupCheckId();">중복확인</button>
                                    </td>
                                </tr>
                                <tr>
                                    <th>비밀번호<i>*</i></th>
                                    <td>
                                        <input type="password" class="icon" id="password" name="password">
                                    </td>
                                </tr>
                                <tr>
                                    <th>비밀번호확인<i>*</i></th>
                                    <td>
                                        <input type="password" id="chckpw" name="chckpw" style="width:184px;">
                                    </td>
                                </tr>
                                <tr>
                                    <th>이름/업체명<i>*</i></th>
                                    <td>
                                        <input type="text" id="name" name="name">
                                    </td>
                                </tr>
                                <tr>
	                                <th>건물</th>
	                                <td>
	                                    <select name="bldgCd" id="bldgCd">
	                                    </select>
	                                </td>
	                            </tr>
                                <tr>
                                    <th>전화번호<i>*</i></th>
                                    <td>
                                        <input type="text" id="telPhone" name="telPhone">
                                    </td>
                                </tr>
                                <tr id='trPosition_new' class="displaynone">
                                    <th>직급</th>
                                    <td>
                                        <input type="text" id="position" name="position">
                                    </td>
                                </tr>
                                <tr id='trDept_new' class="displaynone">
                                    <th>부서</th>
                                    <td>
                                        <input type="text" id="dept" name="dept">
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
                        <button type="button" class="btn confirm" onClick="saveNewMember();">추가</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- 계정추가 팝업 영역 끝-->
        <!-- 팝업 : 정보 수정 -->
        <div class="popup" id="modify_member">
            <div class="popup_container">
                <div class="popup_head">
                    <p class="popup_title">정보수정</p>
                    <button type="button" class="popup_close" onClick="closePop()">x</button>
                </div>
                <div class="popup_inner">
                    <dfn>필수항목 <i>*</i></dfn>
                    <form id="updateMemberForm" onsubmit="return false;">
                        <table>
                            <tbody>
                                <tr>
                                    <th>활성화</th>
                                    <td>
                                        <input type="checkbox" id="active" name="active" checked>
                                        <label for="active">체크 시, 활성화</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>접근권한</th>
                                    <td>
                                        <input type="radio" value="admin" id="admin2" name="modifyAuth" onClick="clickAuth('modify');">
                                        <label for="admin2">관리자</label>
                                        <input type="radio" value="own" id="own2" name="modifyAuth" onClick="clickAuth('modify');" >
                                        <label for="own2">자사직원</label>
                                        <input type="radio" value="mnFact" id="mnFact2" name="modifyAuth" onClick="clickAuth('modify');">
                                        <label for="mnFact2">가공업체</label>
                                        <input type="radio" value="finFact" id="finFact2" name="modifyAuth" onClick="clickAuth('modify');">
                                        <label for="finFact2">마감업체</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>아이디<i>*</i></th>
                                    <td>
                                        <input type="text" class="icon" id="id" name="id" onfocus="this.blur();" readonly >
                                    </td>
                                </tr>
                                <tr>
                                    <th>비밀번호</th>
                                    <td>
                                        <input type="password" class="icon" id="password" name="password" placeholder="**********">
                                    </td>
                                </tr>
                                <tr>
                                    <th>비밀번호확인</th>
                                    <td>
                                        <input type="password" id="chckpw" name="chckpw" style="width:184px;">
                                    </td>
                                </tr>
                                <tr>
                                    <th>이름/업체명<i>*</i></th>
                                    <td>
                                        <input type="text" id="name" name="name">
                                    </td>
                                </tr>
                                <tr>
	                                <th>건물</th>
	                                <td>
	                                    <select name="bldgCd2" id="bldgCd2">
	                                    </select>
	                                </td>
	                            </tr>
                                <tr>
                                    <th>전화번호<i>*</i></th>
                                    <td>
                                        <input type="text" id="telPhone" name="telPhone">
                                    </td>
                                </tr>
                                <tr id='trPosition_modify' class="displaynone">
                                    <th>직급</th>
                                    <td>
                                        <input type="text" id="position" name="position">
                                    </td>
                                </tr>
                                <tr id='trDept_modify' class="displaynone">
                                    <th>부서</th>
                                    <td>
                                        <input type="text" id="dept" name="dept">
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
                        <button type="button" class="btn stroke" onClick="updateMember();">수정</button>
                        <button type="button" class="btn fill" onClick="deleteMember();">삭제</button>
                    </div>
                </div>
            </div>
        </div>
        <!--정보수정 팝업 영역 끝-->
        </div>
</body>
</html>