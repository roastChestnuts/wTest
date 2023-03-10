<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="path" value="${ pageContext.request.contextPath }"/>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	예비 메인화면
</h1>

    <sec:authorize access="isAnonymous()">
        <input type="button" value="로그인" onclick="location.href='${ path }/member/login'">
    </sec:authorize>

    <sec:authorize access="isAuthenticated()">
        <input type="button" value="로그아웃" onclick="location.href='${ path }/member/logout'">
    </sec:authorize>

    <input type="button" value="게시판" onclick="location.href='${ path }/board/list'">

	<br><br><br>


    <sec:authorize access="hasRole('ROLE_ADMIN')">
        <button onclick="location.assign('${path}/admin/home')">관리자 페이지</button>
    </sec:authorize>
</body>
</html>