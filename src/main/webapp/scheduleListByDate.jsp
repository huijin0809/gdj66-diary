<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %> <!-- *로 모든 명령어를 import 가능 -->
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 유효성 검사
	// y, m, d의 값이 null 이거나 공백일 경우
	if(request.getParameter("y") == null
			|| request.getParameter("y").equals("")
			|| request.getParameter("m") == null
			|| request.getParameter("m").equals("")
			|| request.getParameter("d") == null
			|| request.getParameter("d").equals("")) {
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	//  y, m, d의 값이 null 이거나 공백이 아닐경우 형변환
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m")) + 1; // 자바API에서는 0월부터 시작하므로 +1을 해준다
	int d = Integer.parseInt(request.getParameter("d"));
	
	// 디버깅
	System.out.println("scheduleListByDate y: " + y);
	System.out.println("scheduleListByDate m: " + m);
	System.out.println("scheduleListByDate d: " + d);
	
	// yyyy-mm-dd 형식에 맞추기 위해
	String strM = m+""; // 공백 붙여서 간단하게 String타입으로 바꾸기
	if(m<10) { // 일의 자리 수면 앞에 0 붙여주기
		strM = "0" + strM;
	}
	String strD = d+"";
	if(d<10) {
		strD = "0" + strD;
	}
	
	// 스케줄 목록 공간에 출력 (일별 스케줄 리스트)
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 	
	// 2) mariadb 서버에 접속, 접속 유지
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리 생성 후 실행
	String sql = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate FROM schedule WHERE schedule_date=? ORDER BY schedule_time DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, y + "-" + strM + "-" + strD); // yyyy-mm-dd 형식에 맞추기
	System.out.println("scheduleListByDate sql: " + stmt);
	
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule(); // rs의 갯수만큼 만들어짐
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 실제로는 day(일)만 가져옴
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleMemo = rs.getString("scheduleMemo"); // 메모 전체가 아닌 일부(5글자)만 가져옴
		s.scheduleColor = rs.getString("scheduleColor");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleListByDate.jsp</title>
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
		<a class="btn btn-warning krFont" href="./home.jsp">홈으로</a>
		<a class="btn btn-outline-warning krFont" href="./noticeList.jsp">공지 리스트</a> <!-- 최근 10개씩 -->
		<a class="btn btn-outline-warning krFont" href="./scheduleList.jsp">일정 리스트</a> <!-- 이번달 전체 -->
	</div>
	<br>
	<!-- 스케줄 입력 공간 -->
	<h1> 일정 추가하기 &#x1F4DD </h1>
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
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table container">
			<tr>
				<th class="table-warning">날짜</th>
				<td>
					<input type="date" name="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly">
					<!-- 선택된 날짜는 수정 안되게 readonly -->
				</td>
			</tr>
			<tr>
				<th class="table-warning">시간</th>
				<td>
					<input type="time" name="scheduleTime">
				</td>
			</tr>
			<tr>
				<th class="table-warning">색상</th>
				<td>
					<input type="color" name="scheduleColor" value="#000000">
				</td>
			</tr>
			<tr>
				<th class="table-warning">일정메모</th>
				<td>
					<textarea cols="80" rows="3" name="scheduleMemo"></textarea>
				</td>
			</tr>
			<tr>
				<th class="table-warning">비밀번호</th>
				<td>
					<input type="password" name="schedulePw" placeholder="비밀번호를 입력해주세요">
				</td>
			</tr>
		</table>
		<div>
			<a class="btn btn-outline-secondary" href="./scheduleList.jsp">뒤로</a>
			<button type="submit" class="btn btn-outline-secondary">추가</button>
		</div>
	</form>
	<br><br>
	<!-- 스케줄 목록 공간(일별 스케줄 리스트) -->
	<h1 class="krFont"> &#x1F49B <%=y%>.<%=m%>.<%=d%> 일정 목록 &#x1F33B</h1>
	<table class="table">
		<thead class="table-warning h5 krFont">
			<tr>
				<th>시간</th>
				<th>일정 메모</th>
				<th>생성일자</th>
				<th>수정일자</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
		</thead>
		<tbody>
			<%
				for(Schedule s : scheduleList) {
			%>
					<tr>
						<td><%=s.scheduleTime.substring(0, 5)%></td>
						<td>
							<div style="color: <%=s.scheduleColor%>">
								<%=s.scheduleMemo%>
							</div>
						</td>
						<td><%=s.createdate.substring(0, 10)%></td>
						<td><%=s.updatedate.substring(0, 10)%></td>
						<td>
							<a class="btn btn-outline-secondary" href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">수정</a>
						</td>
						<td>
							<a class="btn btn-outline-secondary" href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">삭제</a>
						</td>
					</tr>
			<%
				}
			%>
		</tbody>
	</table>
</div>
<div class="mt-5 p-4 bg-secondary text-white text-center krFont">
  <p>구디아카데미 GDJ 66기 김희진</p>
</div>
</body>
</html>