<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
<c:set var="path" value="${ pageContext.request.contextPath }"/>

<!-- jQuery -->

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>



<!-- Bootstrap CSS -->

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" crossorigin="anonymous">


<!-- 상단 메뉴바{s} -->

<nav class="navbar navbar-expand-sm navbar-dark bg-dark">

  <a class="navbar-brand" href="#">.COM</a>

  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample03" aria-controls="navbarsExample03" aria-expanded="false" aria-label="Toggle navigation">

    <span class="navbar-toggler-icon"></span>

  </button>



  <div class="collapse navbar-collapse" id="navbarsExample03">

    <ul class="navbar-nav mr-auto">

      <li class="nav-item">

        <a class="nav-link" href="${ path }/board/list">게시판 <span class="sr-only">(current)</span></a>

      </li>

      <li class="nav-item">

        <a class="nav-link" href="${ path }/admin/나중에">관리자 페이지</a>

      </li>

      <!--로그인 전-->
      <li class="nav-item">
        <security:authorize access="isAnonymous()">
            <a class="nav-link" href="${ path }/member/login">로그인/회원가입</a>
        </security:authorize>

        <security:authorize access="isAuthenticated()">
            <security:authentication property="principal.name" var="sec_name"/>
            <a class="nav-link" href="${ path }/member/logout">로그아웃</a>
            ${ sec_name }님
        </security:authorize>
      </li>


    </ul>

    <form class="form-inline my-2 my-md-0">

      <input class="form-control" type="text" placeholder="Search">

    </form>

  </div>

</nav>

<!-- 상단 메뉴바{e} -->