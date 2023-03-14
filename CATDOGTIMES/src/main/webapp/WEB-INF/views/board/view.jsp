<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="path" value="${ pageContext.request.contextPath }"/>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<style>
    section>div#board-write-container{width:600px; margin:0 auto; text-align:center;}
    section>div#board-write-container h2{margin:10px 0;}
    table#tbl-board{width:500px; margin:0 auto; border:1px solid black; border-collapse:collapse; clear:both; }
    table#tbl-board th {width: 125px; border:1px solid; padding: 5px 0; text-align:center;} 
    table#tbl-board td {border:1px solid; padding: 5px 0 5px 10px; text-align:left;}
    div#comment-container button#btn-insert{width:60px;height:50px; color:white; background-color:#3300FF;position:relative;top:-20px;}
    
    /*댓글테이블*/
    table#tbl-comment{width:580px; margin:0 auto; border-collapse:collapse; clear:both; } 
    table#tbl-comment tr td{border-bottom:1px solid; border-top:1px solid; padding:5px; text-align:left; line-height:120%;}
    table#tbl-comment tr td:first-of-type{padding: 5px 5px 5px 50px;}
    table#tbl-comment tr td:last-of-type {text-align:right; width: 100px;}
    table#tbl-comment button.btn-delete{display:none;}
    table#tbl-comment tr:hover {background:lightgray;}
    table#tbl-comment tr:hover button.btn-delete{display:inline;}
    table#tbl-comment sub.comment-writer {color:navy; font-size:14px}
    table#tbl-comment sub.comment-date {color:tomato; font-size:10px}
</style>
<section id="content">   
	<div id="board-write-container">
		<h2>게시판</h2>
		<table id="tbl-board">
			<tr>
				<th>글번호</th>
				<td>${ board.no }</td>
			</tr>
			<tr>
				<th>제 목</th>
				<td>${ board.title }</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>${ board.writerId }</td>
			</tr>
			<tr>
				<th>조회수</th>
				<td>${ board.readCount }</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td>
					<c:if test="${ empty board.originalFileName }">
						<span>-</span>
					</c:if>
					<c:if test="${ not empty board.originalFileName }">
						<img src="${ path }/resources/images/file.png" width="20px" height="20px">
						<a href="javascript:" id="fileDown">
							<span>${ board.originalFileName }</span>
						</a>
						<%-- 
						<br><a href="${ path }/resources/upload/board/${board.renamedFileName}"
							download="${ board.originalFileName }">파일 다운</a>
						--%>
					</c:if>
				</td>
			</tr>
			<tr>
				<th>내 용</th>
				<td>${ board.content }</td>
			</tr>
			<%--글작성자/관리자인경우 수정삭제 가능 --%>
			<tr>

				<th colspan="2">
                    <sec:authorize access="isAuthenticated()">
                        <sec:authentication property="principal.id" var="security_id"/>
                        <sec:authorize access="hasRole('ROLE_ADMIN')" var="isAdmin"/>
                        <c:if test="${security_id == board.writerId || isAdmin}">
                            <button type="button"
                                onclick="location.href='${ path }/board/update?no=${ board.no }'">수정</button>
                            <button type="button" id="btnDelete">삭제</button>
                        </c:if>
                    </sec:authorize>
					<button type="button" onclick="location.href='${ path }/board/list'">목록으로</button>
				</th>
			</tr>
		</table>

        <div style="border: 1px solid; width: 600px; padding: 5px">
            <form name="form1" action="${path}/board/reply?${_csrf.parameterName}=${_csrf.token}" method="post">
                <sec:authentication property="principal.id" var="security_id"/>
                <sec:authentication property="principal.no" var="security_no"/>
                <input type="hidden" name="boardNo" value="${board.no}">
                작성자: <input type="text" name="writerId" value="${ security_id }" readonly><br/>
                <input type="hidden" name="writerNo" value="${ security_no }" readonly><br/>

                <textarea name="content" rows="3" cols="60" maxlength="500" placeholder="댓글을 달아주세요."></textarea>
                <input type='submit' value='등록'>
            </form>
        </div>

        <c:forEach var="reply" items="${replies}" varStatus="status">
            <div style="border: 1px solid gray; width: 600px; padding: 5px; margin-top: 5px;
                  margin-left: <c:out value="${20*reply.depth}"/>px; display: inline-block">
                <c:out value="${reply.writerId}"/> <c:out value="${reply.modifyDate}"/>
                <a href="#" onclick="fn_replyDelete('<c:out value="${reply.no}"/>')">삭제</a>
                <a href="#" onclick="fn_replyUpdate('<c:out value="${reply.no}"/>')">수정</a>
                <a href="#" onclick="fn_replyReply('<c:out value="${reply.no}"/>')">댓글</a>
                <br/>
                <div id="reply<c:out value="${reply.no}"/>"><c:out value="${reply.content}"/></div>
            </div><br/>
        </c:forEach>

        <div id="replyDiv" style="width: 99%; display:none">
            <form name="form2" action="boardReplySave" method="delete">
                <input type="hidden" name="boardNo" value="${board.no}">
                <input type="hidden" name="no">
                <textarea name="content" rows="3" cols="60" maxlength="500"></textarea>
                <a href="#" onclick="fn_replyUpdateSave()">저장</a>
                <a href="#" onclick="fn_replyUpdateCancel()">취소</a>
            </form>
        </div>
        <!--대댓글-->
        <div id="replyDialog" style="width: 99%; display:none">
            <form name="form3" action="${path}/board/reply?${_csrf.parameterName}=${_csrf.token}" method="post">
                <sec:authentication property="principal.id" var="security_id"/>
                <sec:authentication property="principal.no" var="security_no"/>
                <input type="hidden" name="boardNo" value="${board.no}">
                <input type="hidden" name="no">
                <input type="hidden" name="parent">
                작성자: <input type="text" name="writerId" value="${ security_id }" readonly><br/>
                <input type="hidden" name="writerNo" value="${ security_no }" readonly><br/>
                <textarea name="content" rows="3" cols="60" maxlength="500"></textarea>
                <a href="#" onclick="fn_replyReplySave()">저장</a>
                <a href="#" onclick="fn_replyReplyCancel()">취소</a>
            </form>
        </div>

		<!--
		<div id="comment-container">
	    	<div class="comment-editor">
	    		<form action="${ path }/board/reply" method="POST">
	    			<input type="hidden" name="boardNo" value="${ board.no }">
					<textarea name="content" id="replyContent" cols="55" rows="3"></textarea>
					<button type="submit" id="btn-insert">등록</button>	    			
	    		</form>
	    	</div>
	    </div>

	    <table id="tbl-comment">
	    	<c:forEach var="reply" items="${ board.replies }">
		    	<tr class="level1">
		    		<td>
		    			<sub class="comment-writer"><c:out value="${ reply.writerId }"/></sub>
		    			<sub class="comment-date"><fmt:formatDate type="date" value="${ reply.createDate }"/></sub>
		    			<br>
		    			<c:out value="${ reply.content }"/>
		    		</td>
		    		<td>
                        <sec:authorize access="isAuthenticated()">
                            <sec:authentication property="principal.id" var="security_id"/>
                            <sec:authorize access="hasRole('ROLE_ADMIN')" var="isAdmin"/>
                            <c:if test="${security_id == board.writerId || isAdmin}">
	    					    <button class="btn-delete">삭제</button>
                            </c:if>
                        </sec:authorize>
		    		</td>
		    	</tr>
	    	</c:forEach>
	    </table>
	    -->
</section>

<script>
	$(document).ready(() => {
		$("#btnDelete").on("click", () => {
			if(confirm("정말로 게시글을 삭제 하시겠습니까?")) {
				location.replace("${ path }/board/delete?no=${ board.no }");
			}
		});
		
		$("#fileDown").on("click", () => {
			location.assign("${ path }/board/fileDown?oname=${ board.originalFileName }&rname=${ board.renamedFileName }");
		});
    })

    function fn_replyDelete(no){
        if (!confirm("삭제하시겠습니까?")) {
            return;
        }
        var form = document.form2;

        form.action="${path}/board/reply/delete?${_csrf.parameterName}=${_csrf.token}";
        form.no.value=no;
        form.method='post';
        form.submit();
    }

    var updateReno = updateRememo = null;
    function fn_replyUpdate(no){
        var form = document.form2;
        var reply = document.getElementById("reply"+no);
        var replyDiv = document.getElementById("replyDiv");
        replyDiv.style.display = "";

        if (updateReno) {
            document.body.appendChild(replyDiv);
            var oldReno = document.getElementById("reply"+updateReno);
            oldReno.innerText = updateRememo;
        }

        form.no.value=no;
        form.content.value = reply.innerText;
        reply.innerText ="";
        reply.appendChild(replyDiv);
        updateReno   = no;
        updateRememo = form.content.value;
        form.content.focus();
    }

    function fn_replyUpdateSave(){
        var form = document.form2;
        if (form.content.value=="") {
            alert("글 내용을 입력해주세요.");
            form.content.focus();
            return;
        }

        form.action="${path}/board/reply/update?${_csrf.parameterName}=${_csrf.token}";
        form.method='post';
        form.submit();
    }

    function fn_replyUpdateCancel(){
        var form = document.form2;
        var replyDiv = document.getElementById("replyDiv");
        document.body.appendChild(replyDiv);
        replyDiv.style.display = "none";

        var oldReno = document.getElementById("reply"+updateReno);
        oldReno.innerText = updateRememo;
        updateReno = updateRememo = null;
    }
    <!--대댓글 관련 함수-->
    function hideDiv(id){
        var div = document.getElementById(id);
        div.style.display = "none";
        document.body.appendChild(div);
    }

    function fn_replyReply(no){
        var form = document.form3;
        var reply = document.getElementById("reply"+no);
        var replyDia = document.getElementById("replyDialog");
        replyDia.style.display = "";

        if (updateReno) {
            fn_replyUpdateCancel();
        }

        form.content.value = "";
        form.parent.value=no;
        reply.appendChild(replyDia);
        form.writerId.focus();
    }
    function fn_replyReplyCancel(){
        hideDiv("replyDialog");
    }

    function fn_replyReplySave(){
        var form = document.form3;

        if (form.writerId.value=="") {
            alert("작성자를 입력해주세요.");
            form.writerId.focus();
            return;
        }
        if (form.content.value=="") {
            alert("글 내용을 입력해주세요.");
            form.content.focus();
            return;
        }

        form.action="${path}/board/reply?${_csrf.parameterName}=${_csrf.token}";
        form.method='post';
        form.submit();
    }
</script>