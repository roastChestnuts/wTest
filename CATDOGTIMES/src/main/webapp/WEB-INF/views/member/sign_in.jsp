<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="path" value="${ pageContext.request.contextPath }"/>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link href="${ path }/css/member/sign_in.css?after" rel="stylesheet">
	<link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
  	<script src="https://code.iconify.design/iconify-icon/1.0.2/iconify-icon.min.js"></script>
  	<!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
  	<!--jQuery-->
  	<script src="${ path }/js/common/jquery-3.6.0.min.js"></script>
  	<!-- bootstrap JS -->
  	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
  	<!-- SweetAlert CSS -->
  	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
</head>

<body>

	<!-- 개인정보처리방침, 이용약관 모달 -->
	<div class="modal fade" id="informModal" tabindex="-1" aria-labelledby="ModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="ModalLabel"> </h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body modal-dialog-scrollable" id="privacy-modal-body">
	      	<!-- 여기 외부 jsp 내용 들어감 -->
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
	      </div>
	    </div>
	  </div>
	</div>



  <div class="login">
    <div class="login__content">
      <section id="slider" class="slider-element dark">
		<div class="slider-inner">
			<div class="video-wrap m-auto" style="position: sticky">
				<video id="mainVideo" style="z-index: 1" preload="auto" loop autoplay muted playsinline></video>
				<div class="video-overlay w-100" style="z-index: 0; background-color: rgba(0, 0, 0, 0.45)"></div>
			</div>
	  	</div>
	  </section>


      <div class="login__forms">
        <!--로그인 폼 -->
        <form action="${ path }/member/login" method="POST" class="login__register" id="login-in">
          <h1 class="login__title">멍냥일보</h1>
          <div class="login__box">
            <i class='bx bx-user login__icon'></i>
            <input type="text" placeholder="Username" class="login__input" id="id" name="id">
          </div>
          <div class="login__box">
            <i class='bx bx-lock login__icon'></i>
            <input type="password" placeholder="Password" class="login__input" id="password" name="password">
          </div>
          <!-- <div class="form-check form-check-inline">
          	<input type="checkbox" value="saveId" id="saveId" name="saveId"> 아이디저장
          </div> -->
          <span class="find__pw" id="find-pw-span">/비밀번호 찾기</span>
          <span class="find__id" id="find-id-span">아이디</span>
          <a href="#" class="login__button" onclick="return login()">로그인</a> <!-- return받은 값이 true이면 제출 -->
          <!--잘못된 로그인 시도를 할 경우 CustomLoginFailHandler 에서 메시지 값을 넘겨받음-->
          <c:if test="${ not empty errorMessage }">
          </c:if>
          <div>
            <span class="login__account login__account--account">계정이 없으신가요?</span>
            <span class="login__signin login__signin--signup" id="sign-up">회원가입</span>
          </div>
          <div class="login__social">
          	<a href="#" class="login__social--icon" onclick="loginKakao()"><iconify-icon icon="ri:kakao-talk-fill" width="32"/></a>
          	<div id="naverIdLogin" style="display: none;"></div>
            <a href="#" class="login__social--icon" id="naverLogin"><iconify-icon icon="simple-icons:naver"/></a>
         </div>
         <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
        </form>

        <!-- 회원가입 폼 -->
        <form action="${ path }/member/sign_up" method="POST" class="login__create none" id="login-up">
          <h1 class="login__title">회원가입</h1>
          <div class="login__box">
            <i class='bx bx-user login__icon'></i>
            <input type="text" placeholder="아이디" class="login__input" id="sign_up_id" name="id" onchange="checkId()">
            <input type="hidden" name="idCheckValue" value="0" />
          </div>
          <span class="id_length">4~20자 사이 영문자, 숫자로 입력해주세요.</span>
          <span class="id_ok">사용 가능한 아이디입니다.</span>
		  <span class="id_already">누군가 이 아이디를 사용하고 있어요.</span>

          <div class="login__box">
            <i class='bx bx-lock login__icon'></i>
            <input type="password" placeholder="비밀번호" class="login__input" id="sign_up_pw1" name="password">
          </div>
		  <span id="pwd_chk1"></span>

          <div class="login__box">
            <i class='bx bx-lock login__icon'></i>
            <input type="password" placeholder="비밀번호 확인" class="login__input" id="sign_up_pw2">
          </div>
          <span id="pwd_chk2"></span>

          <div class="login__box">
            <i class='bx bx-happy-beaming login__icon'></i>
            <input type="text" placeholder="name" class="login__input" id="sign_up_name" name="name" >
          </div>

          <div class="login__box">
            <i class='bx bx-male login__icon'></i>
            <i class='bx bx-female login__icon'></i>
            <label><input type="radio" id="male" name="gender" value="M">남자</label>
            <label><input type="radio" id="female" name="gender" value="W">여자</label>
          </div>

          <div class="login__box">
            <i class='bx bx-upside-down login__icon'></i>
            <input type="text" placeholder="nickname" class="login__input" id="sign_up_nickName" name="nickName" onchange="checkNickName()">
            <input type="hidden" name="nickNameCheckValue" value="0" />
          </div>
          <span class="nickname_ok">사용 가능한 닉네임입니다.</span>
		  <span class="nickname_already">누군가 이 닉네임을 사용하고 있어요.</span>

          <div class="login__box">
            <i class='bx bx-at login__icon'></i>
            <input type="text" placeholder="Email" class="login__input" id="sign_up_email" name="email">
            <input type="button" class="btn btn-primary" id="btnEmailCheck" style="background-color: #f9cdbd; border: none;" value="인증하기">
          </div>

          <div class="login__box">
            <i class='bx bx-bell login__icon'></i>
            <input type="text" placeholder="인증번호 6자리 입력" class="login__input" id="sign_up_email_check" disabled="disabled" maxlength="6">
            <input type="hidden" id="emailCheckValue" name="emailCheckValue" value="0" />
          </div>
          <span id="mail-check-warn"></span>

          <div class="login__box__addr">
            <input type="text" placeholder="우편번호" class="login__input" name="zipcode" readonly="readonly">
          </div>

          <div class="login__box__addr__btn">
          	<input type="button" class="btn btn-primary" value="주소찾기" style="background-color: #f9cdbd; border: none;" onclick="execute_daum_address()">
          </div>

          <div class="login__box">
            <input type="text" placeholder="주소" class="login__input" id="address" name="address" readonly="readonly">
          </div>

          <div class="login__box">
            <input type="text" placeholder="상세주소" class="login__input" name="detailAddress" readonly="readonly">
          </div>
          <div class="checkbox mb-2 mt-4">
               <input type="checkbox" id="privacy_check" required> <b>(필수)</b>개인정보수집에 동의합니다. <a id="privacy" data-bs-toggle="modal" data-bs-target="#informModal" role="button" style="margin-left: 20px; color:grey;" onclick="privacyCall()">보기</a>
               <br>
               <input type="checkbox" id="termconditions_check" required> <b>(필수)</b>이용약관에 동의합니다. <a id="termconditions" data-bs-toggle="modal" data-bs-target="#informModal" role="button" style="margin-left: 52px; color:grey;" onclick="termconditionsCall()">보기</a>
          </div>
          <a href="#" class="login__button" onclick="return sign_up()">회원가입</a>

          <div>
            <span class="login__account login__account--account">이미 계정이 있으신가요?</span>
            <span class="login__signup login__signup--signup" id="sign-in">로그인</span>
          </div>
          <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
        </form>

      	<!-- 아이디 찾기 폼 -->
        <form class="login__register none" id="find-id">
          <h1 class="login__title">아이디 찾기</h1>
          <div class="login__box">
            <input type="text" placeholder="email" class="login__input" id="find_id_email" name="email">
          </div>
          <span class="login__signup login__signup--signup" onClick="window.location.reload()">로그인</span>
          <a href="#" class="login__button" id="btn-find-id">아이디 찾기</a>
        </form>

      	<!-- 비밀번호 찾기 폼 -->
      	<form class="login__register none" id="find-pw">
          <h1 class="login__title">비밀번호 재발급</h1>
          <div class="login__box">
            <input type="text" placeholder="아이디" class="login__input" id="find_pw_id" name="id">
          </div>
          <div class="login__box">
            <input type="text" placeholder="이메일" class="login__input" id="find_pw_email" name="email">
          </div>
          <span class="login__signup login__signup--signup" onClick="window.location.reload()">로그인</span>

          <a href="#" class="login__button" id="btn-find-pw">임시비밀번호 발급</a>
        </form>

      </div>
    </div>
   </div>


   <!-- 네이버 SDK -->
   <script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
   <!-- kakao JS -->
   <script src = "https://developers.kakao.com/sdk/js/kakao.js"></script>
   <!-- 주소api -->
   <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
   <!-- SweetAlert2 JS -->
   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
   <script type="text/javascript" src="${ path }/js/member/sign_in.js?v=<%=System.currentTimeMillis() %>"></script>
   <script type="text/javascript">
      <!--로그인 에러메시지 출력-->
      var msg = "${errorMessage}";

      if (msg != "") { Swal.fire(msg); }

      <!--ajax csrf토큰값 변수-->
      var header = '${_csrf.headerName}';
      var token = '${_csrf.token}';

      //네이버 로그인
	  var naverLogin = new naver.LoginWithNaverId({
		  clientId: "mxxEZM0mxB_D9crAuaD9",
		  callbackUrl: "http://localhost:8088/times/member/naverLogin",// 본인의 callBack url
		  isPopup: false,
		  loginButton: {color: "white", type: 1, height:60}
	  });
	  naverLogin.init();
	  $(document).on("click", "#naverLogin", function(){
		  var btnNaverLogin = document.getElementById("naverIdLogin").firstChild;
		  btnNaverLogin.click();
	  });

      //개인정보처리방침 모달 내부 jsp호출
	  function privacyCall(){
		  document.getElementById("ModalLabel").innerHTML = "개인정보처리방침";
		  $(".modal-body").load("${path}/member/privacyModal");
	  }
	  //이용약관 모달 내부 jsp호출
 	  function termconditionsCall(){
		  document.getElementById("ModalLabel").innerHTML = "홈페이지 표준 이용약관";
		  $(".modal-body").load("${path}/member/termconditionsModal");
	  }

      //닉네임 중복체크
   	  function checkNickName(){
   		let nickName = $('#sign_up_nickName').val().trim();
   		$.ajax({
	        url:'${ path }/member/nickNameCheck', //Controller에서 요청 받을 주소
	        type:'get', //POST 방식으로 전달
	        data:{nickName},
	        success:function(cnt){ //컨트롤러에서 넘어온 cnt값을 받는다
	            if(cnt == 0){ //사용 가능
	            	$("[name=nickNameCheckValue]").val("1");
	                $('.nickname_ok').css("display","inline-block");
	                $('.nickname_already').css("display", "none");
	            } else { //이미 존재
	            	$("[name=nickNameCheckValue]").val("0");
	                $('.nickname_already').css("display","inline-block");
	                $('.nickname_ok').css("display", "none");
	            }
	        },
	        error:function(){
	            Swal.fire("에러입니다");
	        }})
      }
	  //아이디 중복체크
	  function checkId(){
	    let id = $('#sign_up_id').val().trim(); //id값이 "sign_up_id"인 입력란의 값을 저장
		let idCheck = /^[a-z]+[a-z0-9]{3,21}$/; //아이디 형식체크 변수
		if(idCheck.test(id)){ //아이디 길이가 알맞을 때
		    $.ajax({
		        url:'${ path }/member/idCheck', //Controller에서 요청 받을 주소
		        type:'get', //POST 방식으로 전달
		        data:{id},
		        async:false, //동기식으로 전환
		        success:function(cnt){ //컨트롤러에서 넘어온 cnt값을 받는다
		            if(cnt == 0){ //사용 가능한 아이디
		            	$("[name=idCheckValue]").val("1"); //id체크 ok
		                $('.id_ok').css("display","inline-block");
		                $('.id_already').css("display", "none");
		                $('.id_length').css("display", "none");
		            } else { //이미 존재하는 아이디
		            	$("[name=idCheckValue]").val("0");
		                $('.id_already').css("display","inline-block");
		                $('.id_ok').css("display", "none");
		                $('.id_length').css("display", "none");
		            }
		        },
		        error:function(){
		            Swal.fire("에러입니다");
		        }
		    });
		}else{
			$("[name=idTest]").val("0");
			$('.id_length').css("display","inline-block");
			$('.id_already').css("display", "none");
			$('.id_ok').css("display", "none");
			sign_up_id.focus();
			return false;
	   }};
	   //이메일 인증
	   $('#btnEmailCheck').click(function() {
			const email = $('#sign_up_email').val(); // 이메일 주소값
			const checkInput = $('#sign_up_email_check'); // 인증번호 입력칸
			let emailExpression = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

			if (email == "") {
				Swal.fire('이메일을 입력해주세요.')
				return false;
			} else if(!emailExpression.test(email)){
				Swal.fire('이메일 형식에 맞게 입력해주세요.')
				return false;
			} else{
				Swal.fire({
					icon: 'success',
					title: '전송완료!',
					html: '인증번호가 전송되었습니다!<br/>*이메일이 도착하기까지 몇 분 정도 소요될 수 있습니다.<br/>*스팸 메일함으로 발송될 수 있으니 체크 바랍니다.',
				})
			}

			$.ajax({
				url:'${ path }/member/mailCheck',
				type:'post',
				data:{email},
                /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
                beforeSend : function(xhr){
                    xhr.setRequestHeader(header, token);
                },
				success : function (data) {
					checkInput.attr('disabled',false);
					code=data;
				}});
	   });
	   // 인증번호 비교
	   // blur -> focus가 벗어나는 경우 발생
	   $('#sign_up_email_check').blur(function () {
		  const inputCode = $(this).val();
		  const $resultMsg = $('#mail-check-warn');

		  if(inputCode === code){
			 $resultMsg.html('인증번호가 일치합니다.');
			 $resultMsg.css('color','green');
			 $('#btnEmailCheck').attr('disabled',true);
			 $('#sign_up_email').attr('readonly',true);
			 $('#sign_up_email_check').attr('readonly',true);
			 $('#sign_up_email_check').attr('onFocus', 'this.initialSelect = this.selectedIndex');
		     $('#sign_up_email_check').attr('onChange', 'this.selectedIndex = this.initialSelect');
		     $("[name=emailCheckValue]").val("1");
		  }else{
			 $resultMsg.html('인증번호가 불일치 합니다. 다시 확인해주세요!.');
			 $resultMsg.css('color','red');
			 $("[name=emailCheckValue]").val("0");
		  }
		});

	    //아이디 찾기
		$("#btn-find-id").click(function(){
			const email = $('#find_id_email').val(); // 이메일 주소값

			let emailExpression = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

			if (email == "") {
				Swal.fire('이메일을 입력해주세요.')
				return false;
			}else if(!emailExpression.test(email)){
				Swal.fire('이메일 형식에 맞게 입력해주세요.')
				return false;
			}
			$.ajax({
				url : "${ path }/member/findId",
				type : "POST",
				data : {
					email
				},
                /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
                beforeSend : function(xhr){
                    xhr.setRequestHeader(header, token);
                },
				success: (obj) => {
		               if(obj.result === 1) {
		            	   Swal.fire({
			                	  icon: 'success',
			                	  title: '전송 성공!',
			                      html: '회원님의 아이디가 메일로 전송되었습니다!<br/>*이메일이 도착하기까지 몇 분 정도 소요될 수 있습니다.<br/>*스팸 메일함으로 발송될 수 있으니 체크 바랍니다.',
			                	}).then(function() {
			                	    window.location.reload();
			                	});
		               } else {
		            	   Swal.fire({
			                	  icon: 'error',
			                	  title: '전송 실패!',
			                	  html: '이메일을 제대로 입력했는지 확인해주시길 바랍니다.'
			                	})
		               }
		            },
		            error: (error) => {
		               console.log(error);
		            }
		     });
		 });

	    //임시비밀번호 발급
		$("#btn-find-pw").click(function(){
			let email = $('#find_pw_email').val(); // 이메일 주소값
			let id = $('#find_pw_id').val(); // 아이디 값
			let emailExpression = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			if (email == "") {
				Swal.fire('이메일을 입력해주세요.')
				return false;
			}else if(id == ""){
				Swal.fire('아이디를 입력해주세요.')
			}else if(!emailExpression.test(email)){
				Swal.fire('이메일 형식에 맞게 입력해주세요.')
				return false;
			}
			$.ajax({
				url : "${ path }/member/findPw",
				type : "POST",
				data : {
					id,
					email
				},
                /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
                beforeSend : function(xhr){
                    xhr.setRequestHeader(header, token);
                },
				success: (obj) => {
		               if(obj.result === 1) {
		            	   Swal.fire({
			                	  icon: 'success',
			                	  title: '전송 성공!',
			                      html: '임시비밀번호가 메일로 전송되었습니다!<br/>*이메일이 도착하기까지 몇 분 정도 소요될 수 있습니다.<br/>*스팸 메일함으로 발송될 수 있으니 체크 바랍니다.',
			                	}).then(function() {
			                	    window.location.reload();
			                	});
		               } else {
		            	   Swal.fire({
			                	  icon: 'error',
			                	  title: '전송 실패!',
			                	  html: '아이디 또는 이메일을 제대로 입력했는지 확인해주시길 바랍니다.'
			                	})
		               }
		            },
		            error: (error) => {
		               console.log(error);
		            }
		     });
		 });

		$(document).ready(function () {
			videoNum = Math.floor(3 * Math.random()) + 1;
			$("#mainVideo").append('<source src="${ path }/images/movie/movie'.concat(videoNum, '.mp4" type="video/mp4" />'));
		});
   </script>
</body>


</html>