<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../include/header.jsp" %>
    <script src="../ckeditor5/build/ckeditor.js"></script>
    <link rel="stylesheet" type="text/css" href="../ckeditor5/sample/styles.css">
    <style type="text/css">
        .ck-content {height: 80vh;}
    </style>
</head>

<script>
    var termSerContent;
    var termPriContent;
    var termLocContent;
    var memberId = "<%=session.getAttribute("id")%>";
    var memberAuth = "<%=session.getAttribute("auth")%>";

    //이용약관추가 
    var saveSerTerm = function(){
        //필수값 체크
        if(editor1.getData() == ""){
            alert("내용을 입력해주세요.");
            return false;
        }
        
        var params = {
            content :editor1.getData()
        }
            
        $.ajax({
            url : "/terms/saveTermService",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            cache : false,
            dataType : 'text',
            data : params,
            success : function(data) {
                alert("이용약관 작성이 완료되었습니다.");
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
            });
    }

    //이용약관 가져오기
    var getSerTerm  = function(){
    $.ajax({
		url : "/terms/getTermService",
		async : false, // 비동기모드 : true, 동기식모드 : false
		type : 'POST',
		cache : false,
		dataType : 'text',
		data : null,
		success : function(data) {
            termSerContent = data;
		},
		error : function(request,status,error) {
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
		});
    }

    //개인정보수집약관 추가 
    function savePriTerm(){
        //필수값 체크
        if(editor3.getData() == ""){
            alert("내용을 입력해주세요.");
            return false;
        }
        
        var params = {
            content :editor3.getData()
        }
            
        $.ajax({
            url : "/terms/saveTermPrivacy",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            cache : false,
            dataType : 'text',
            data : params,
            success : function(data) {
                alert("개인정보수집약관 작성이 완료되었습니다.");
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
            });
    }

    //개인정보수집약관 가져오기
    var getPriTerm  = function(){
        $.ajax({
            url : "/terms/getTermPrivacy",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            cache : false,
            dataType : 'text',
            data : null,
            success : function(data) {
                termPriContent = data;
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
            });
    }
    
  //위치정보이용약관 추가 
    function saveLocTerm(){
        //필수값 체크
        if(editor2.getData() == ""){
            alert("내용을 입력해주세요.");
            return false;
        }
        
        var params = {
            content :editor2.getData()
        }
            
        $.ajax({
            url : "/terms/saveTermLocation",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            cache : false,
            dataType : 'text',
            data : params,
            success : function(data) {
                alert("위치정보이용약관 작성이 완료되었습니다.");
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
            });
    }

    //위치정보이용약관 가져오기
    var getLocTerm  = function(){
        $.ajax({
            url : "/terms/getTermLocation",
            async : false, // 비동기모드 : true, 동기식모드 : false
            type : 'POST',
            cache : false,
            dataType : 'text',
            data : null,
            success : function(data) {
                termLocContent = data;
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
            });
    }
    
    
    $(document.body).ready(function() {  
    	$('#terms').addClass("current");
        getSerTerm();
        getPriTerm(); 
    //    getLocTerm(); 
        
        ClassicEditor
			.create( document.querySelector( '#service' ), {
				
			toolbar: {
				items: [
					'heading',
					'|',
					'bold',
					'italic',
					'link',
					'bulletedList',
					'numberedList',
					'|',
					'outdent',
					'indent',
					'|',
					'blockQuote',
					'insertTable',
					'undo',
					'redo',
					'fontColor',
					'fontBackgroundColor',
					'fontSize',
					'underline',
					'specialCharacters',
					'horizontalLine',
					'htmlEmbed'
				]
			},
			language: 'ko',
			image: {
				toolbar: [
					'imageTextAlternative',
					'imageStyle:inline',
					'imageStyle:block',
					'imageStyle:side'
				]
			},
			table: {
				contentToolbar: [
					'tableColumn',
					'tableRow',
					'mergeTableCells'
				]
			},
				licenseKey: '',
				
				
				
			} )
			.then( editor => {
				editor1 = editor;
				editor1.setData(termSerContent);
				
				
				
			} )
			.catch( error => {
				console.error( 'Oops, something went wrong!' );
				console.error( 'Please, report the following error on https://github.com/ckeditor/ckeditor5/issues with the build id and the error stack trace:' );
				console.warn( 'Build id: eed83e2ex4oz-pejoxvy7ffif' );
				console.error( error );
			} );
        /* 
        
        ClassicEditor
			.create( document.querySelector( '#location' ), {
				
			toolbar: {
				items: [
					'heading',
					'|',
					'bold',
					'italic',
					'link',
					'bulletedList',
					'numberedList',
					'|',
					'outdent',
					'indent',
					'|',
					'blockQuote',
					'insertTable',
					'undo',
					'redo',
					'fontColor',
					'fontBackgroundColor',
					'fontSize',
					'underline',
					'specialCharacters',
					'horizontalLine',
					'htmlEmbed'
				]
			},
			language: 'ko',
			image: {
				toolbar: [
					'imageTextAlternative',
					'imageStyle:inline',
					'imageStyle:block',
					'imageStyle:side'
				]
			},
			table: {
				contentToolbar: [
					'tableColumn',
					'tableRow',
					'mergeTableCells'
				]
			},
				licenseKey: '',
				
				
				
			} )
			.then( editor => {
				editor2 = editor;
				editor2.setData(termLocContent);
				
				
				
			} )
			.catch( error => {
				console.error( 'Oops, something went wrong!' );
				console.error( 'Please, report the following error on https://github.com/ckeditor/ckeditor5/issues with the build id and the error stack trace:' );
				console.warn( 'Build id: eed83e2ex4oz-pejoxvy7ffif' );
				console.error( error );
			} );
         */
        
        ClassicEditor
		.create( document.querySelector( '#privacy' ), {
			
		toolbar: {
			items: [
				'heading',
				'|',
				'bold',
				'italic',
				'link',
				'bulletedList',
				'numberedList',
				'|',
				'outdent',
				'indent',
				'|',
				'blockQuote',
				'insertTable',
				'undo',
				'redo',
				'fontColor',
				'fontBackgroundColor',
				'fontSize',
				'underline',
				'specialCharacters',
				'horizontalLine',
				'htmlEmbed'
			]
		},
		language: 'ko',
		image: {
			toolbar: [
				'imageTextAlternative',
				'imageStyle:inline',
				'imageStyle:block',
				'imageStyle:side'
			]
		},
		table: {
			contentToolbar: [
				'tableColumn',
				'tableRow',
				'mergeTableCells'
			]
		},
			licenseKey: '',
			
			
			
		} )
		.then( editor => {
			editor3 = editor;
			editor3.setData(termPriContent);
			
			
			
		} )
		.catch( error => {
			console.error( 'Oops, something went wrong!' );
			console.error( 'Please, report the following error on https://github.com/ckeditor/ckeditor5/issues with the build id and the error stack trace:' );
			console.warn( 'Build id: eed83e2ex4oz-pejoxvy7ffif' );
			console.error( error );
		} );
    })    
    
    
function tabChange(type){
    $('tablist a').removeClass('on');
   	$('#tab'+type).addClass('on');

   	$('tabcont dev').removeClass('on');
   	$('#terms'+type).addClass('on');
}

</script>

<body>
    <div class="main_wrap">
    	<%@ include file="../include/nav.jsp" %>
    	
        <div class="main_container">
            <section class="main_section">
                <h2 class="main_title">약관관리</h2>
                <!-- 탭 메뉴-->
                <div class="main_tab">
                     <!-- 탭 리스트-->
                     <div role="tablist" class="tablist">
                        <a id='tab1' class="tab on" data-id="terms1" role="tab" onClick="tabChange('1')">이용약관</a>
                        <a id='tab2' class="tab" data-id="terms2" role="tab" onClick="tabChange('2')">개인정보처리방침</a>
                        <!-- <a id='tab3' class="tab" data-id="terms3" role="tab" onClick="tabChange('3')">위치정보이용약관</a> -->
                    </div>
                    <div class="tabcont">
                        <!-- 탭 패널 : 이용약관 .terms1-->
                        <div id="terms1" role="tabpanel" class="tabpanel on">
                            <div class="sub_cont">
                                <div class="btn_wrap">
                                    <button class="btn blck" onClick="saveSerTerm();">저장</button>
                                </div>
                            </div>
                            <div class="edt">
                                <textarea name="service" id="service"></textarea>
                            </div>
                        </div>
                        <!-- 탭 패널 : 개인정보처리방침 .terms2-->
                        <div id="terms2" role="tabpanel" class="tabpanel">
                            <div class="sub_cont">
                                <div class="btn_wrap">
                                    <button class="btn blck" onClick="savePriTerm();">저장</button>
                                </div>
                            </div>
                            <div class="edt">
                                <textarea name="privacy" id="privacy"></textarea>
                            </div>
                        </div>
                         <!-- 탭 패널 : 위치정보이용약관 .terms3-->
                        <!--  <div id="terms3" role="tabpanel" class="tabpanel">
                            <div class="sub_cont">
                                <div class="btn_wrap">
                                    <button class="btn blck" onClick="saveLocTerm();">저장</button>
                                </div>
                            </div>
                            <div class="edt">
                                <textarea name="location" id="location"></textarea>
                            </div>
                        </div> -->
                    </div>
                </div>
            </section>
        </div>
    </div>
</body>
</html>