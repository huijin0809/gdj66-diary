<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	//유효성 검사
	if(request.getParameter("scheduleNo") == null
			|| request.getParameter("scheduleNo").equals("")) {
		response.sendRedirect("./scheduleList.jsp"); // 리스트페이지로 리다이렉션
		return;
	}

	//null이거나 공백이 아닐 경우 값 변수에 넣기(형변환)
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo")); // no는 int타입
	System.out.println("updateScheduleForm scheduleNo: " + scheduleNo);
	
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
	// 2) db서버에 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리 작성 (수정할 페이지를 '조회'해야하므로 select문 작성)
	// 받아온 no의 값과 일치하는(where) 내용 불러오기
	String sql = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate FROM schedule WHERE schedule_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	System.out.println("updateScheduleForm sql: " + stmt); // 디버깅
	
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> 데이터 타입(Schedule)의 클래스로 바꾸기
	Schedule schedule = null;
	if(rs.next()) {
		schedule = new Schedule();
		schedule.scheduleNo = rs.getInt("scheduleNo");
		schedule.scheduleDate = rs.getString("scheduleDate");
		schedule.scheduleTime = rs.getString("scheduleTime");
		schedule.scheduleMemo = rs.getString("scheduleMemo");
		schedule.scheduleColor = rs.getString("scheduleColor");
		schedule.createdate = rs.getString("createdate");
		schedule.updatedate = rs.getString("updatedate");
	}
	
	// scheduleDate에서 y,m,d 값 받기
	String y = schedule.scheduleDate.substring(0,4);
	int m = Integer.parseInt(schedule.scheduleDate.substring(5,7)) - 1; // 자바 API는 0월부터 시작
	String d = schedule.scheduleDate.substring(8);
	System.out.println("home y: " + y);
	System.out.println("home m: " + m);
	System.out.println("home d: " + d);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteScheduleForm.jsp</title>
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
	<h1> 일정 삭제하기 &#x1F4DD </h1>
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
	<form action="./deleteScheduleAction.jsp" method="post">
	<!-- scheduleNo는 action 페이지로 값을 넘기고 hidden으로 숨기기 -->
	<input type="hidden" name="scheduleNo" value="<%=scheduleNo%>">
		<table class="table container">
			<tr>
				<th class="table-warning">날짜</th>
				<td>
					<input type="date" name="scheduleDate" value="<%=schedule.scheduleDate%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th class="table-warning">시간</th>
				<td>
					<input type="time" value="<%=schedule.scheduleTime%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th class="table-warning">색상</th>
				<td>
					<input type="color" value="<%=schedule.scheduleColor%>" disabled="disabled">
				</td>
			</tr>
			<tr>
				<th class="table-warning">일정메모</th>
				<td><%=schedule.scheduleMemo%></td>
			</tr>
			<tr>
				<th class="table-warning">생성일자</th>
				<td><%=schedule.createdate.substring(0, 10)%></td>
			</tr>
			<tr>
				<th class="table-warning">수정일자</th>
				<td><%=schedule.updatedate.substring(0, 10)%></td>
			</tr>
			<tr>
				<!-- 패스워드 입력란 -->
				<th class="table-warning">비밀번호</th>
				<td>
					<input type="password" name="schedulePw" placeholder="비밀번호를 입력해주세요">
				</td>
			</tr>
		</table>
		<div>
			<a class="btn btn-outline-secondary" href="./scheduleListByDate.jsp?y=<%=y%>&m=<%=m%>&d=<%=d%>">뒤로</a>
			<button type="submit" class="btn btn-outline-secondary">삭제</button>
		</div>
	</form>
</div>
<div class="mt-5 p-4 bg-secondary text-white text-center krFont">
  <p>구디아카데미 GDJ 66기 김희진</p>
</div>
</body>
</html>