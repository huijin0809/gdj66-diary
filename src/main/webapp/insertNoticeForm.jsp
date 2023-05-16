<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm.jsp</title>
<!-- 폰트변경 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Comfortaa:wght@600&display=swap" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&display=swap" rel="stylesheet">
<!-- 부트스트랩5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a {text-decoration: none;}
	a:hover {text-decoration: underline;}
	.center {text-align: center;}
	.enFont {
		font-family: 'Comfortaa', cursive;
	}
	.krFont {
		font-family: 'Gowun Dodum', sans-serif;
	}
</style>
</head>
<body>
<div class="p-5 bg-warning text-white text-center">
  <h1 class="enFont">Diary Project</h1>
  <p class="krFont">개발환경: Eclipse(2022-12), JDK(17.0.6), Mariadb(10.5.19), Apache Tomcat(10.1.7), HeidiSQL<br>사용언어: java, sql, html, css, bootstrap5</p> 
</div>
<div class="container mt-3 center krFont">
	<div><!-- 메인메뉴 -->
		<a class="btn btn-warning" href="./home.jsp">홈으로</a>
		<a class="btn btn-outline-warning" href="./noticeList.jsp">공지 리스트</a> <!-- 최근 10개씩 -->
		<a class="btn btn-outline-warning" href="./scheduleList.jsp">일정 리스트</a> <!-- 이번달 전체 -->
	</div>
	<br>
	<h1 class="krFont"> 공지 작성하기 &#x1F4DD </h1>
	<div class="text-bg-danger" >
		<!-- 에러문구 발생시 -->
		<%
			if(request.getParameter("msg") != null) {
		%>
				<%=request.getParameter("msg") %>
		<%
			}
		%>
	</div>
	<form action="./insertNoticeAction.jsp" method="post">
		<table class="table container">
			<tr>
				<th class="table-warning">공지 제목</th>
				<td>
					<input type="text" name="noticeTitle">
				</td>
			</tr>
			<tr>
				<th class="table-warning">공지 내용</th>
				<td>
					<textarea rows="5" cols="80" name="noticeContent"></textarea>
				</td>
			</tr>
			<tr>
				<th class="table-warning">작성자</th>
				<td>
					<input type="text" name="noticeWriter">
				</td>
			</tr>
			<tr>
				<th class="table-warning">비밀번호</th>
				<td>
					<input type="password" name="noticePw" placeholder="비밀번호를 입력해주세요">
				</td>
			</tr>
		</table>
			<div>
			<a class="btn btn-outline-secondary" href="./noticeList.jsp">뒤로</a>
			<button type="submit" class="btn btn-outline-secondary">작성</button>
		</div>
	</form>
</div>
<div class="mt-5 p-4 bg-secondary text-white text-center krFont">
  <p>구디아카데미 GDJ 66기 김희진</p>
</div>
</body>
</html>