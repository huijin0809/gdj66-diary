<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// select notice_no, notice_title, createdate from notice
	// notice_no는 출력되지는 않아도 필요하므로 같이 불러온다!
	// order by createdate desc
	// limit 0, 5
		
	// 1) 드라이버 로딩 // mariadb를 사용가능하게 하는 드라이버 클래스 위치의 풀네임을 적는다 (굳이 외우려고 할 필요x)
	Class.forName("org.mariadb.jdbc.Driver"); 
		
	// 2) mariadb 서버에 접속, 접속 유지
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234"); // 매개변수 3개 (주소,계정,암호)
		
	// 3) 쿼리 생성 후 실행
	// String sql 만들어서 미리 작성하고 하는 게 더 편함
	// 날짜순 최근 공지 5개 (내림차순)
	String sql1 = "SELECT notice_no noticeNo, notice_title noticeTitle, createdate FROM notice ORDER BY createdate DESC limit 0, 5";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	System.out.println("home stmt1: " + stmt1); // 디버깅
	
	ResultSet rs1 = stmt1.executeQuery();
	// ResultSet -> ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs1.next()) {
		Notice n = new Notice();
		n.noticeNo = rs1.getInt("noticeNo"); // 이름이 불일치 // sql 작성시 별명으로 받아서 통일시켜주는 것이 좋음
		n.noticeTitle = rs1.getString("noticeTitle");
		n.createdate = rs1.getString("createdate");
		noticeList.add(n);
	}
	
	// 오늘 일정 (오름차순)
	String sql2 = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo,1,5) scheduleMemo, schedule_color scheduleColor FROM schedule WHERE schedule_date = CURDATE() ORDER BY schedule_time ASC";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println("home stmt2: " + stmt2); // 디버깅
	
	ResultSet rs2 = stmt2.executeQuery();
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs2.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs2.getInt("scheduleNo"); // 이름이 불일치 // sql 작성시 별명으로 받아서 통일시켜주는 것이 좋음
		s.scheduleDate = rs2.getString("scheduleDate"); 
		s.scheduleTime = rs2.getString("scheduleTime");
		s.scheduleMemo = rs2.getString("scheduleMemo"); // 메모 전체가 아닌 일부(5글자)만 가져옴
		s.scheduleColor = rs2.getString("scheduleColor");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home.jsp</title>
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
	<div class="center"><!-- 메인메뉴 -->
		<a class="btn btn-warning krFont" href="./home.jsp">홈으로</a>
		<a class="btn btn-outline-warning krFont" href="./noticeList.jsp">공지 리스트</a> <!-- 최근 10개씩 -->
		<a class="btn btn-outline-warning krFont" href="./scheduleList.jsp">일정 리스트</a> <!-- 이번달 전체 -->
	</div>
	<br>
	<h1> 프로젝트 내용 &#128187; </h1>
	<h4>
		1. mariadb를 이용하여 데이터 테이블 만들기<br>
		2. DML(Select, Insert, Delete, Update)을 이용하여 공지사항 또는 일정을 <br> 조회, 입력, 삭제, 수정할 수 있는 Form 페이지와 Action 페이지 만들기<br>
		3. Calendar 기본API를 이용하여 달력 만들기<br>
		4. 달력에 데이터 테이블을 연결시켜 일정 미리보기<br>
		4. Bootstrap5를 이용하여 CSS하기<br>
	</h4>
	<br><br>
	<h1> &#x1F49B; 최근 공지 &#x1F33B; </h1>
	<table class="table">
		<thead class="table-warning h5 krFont">
			<tr>
				<th>공지 제목</th>
				<th>작성일자</th>
			</tr>
		</thead>
		<tbody>
			<%
				for(Notice n : noticeList) {
			%>
				<tr>
					<td>
						<a class="text-dark" href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
						<!-- notice_title의 값은 중복될 수 있기 때문에 값은 notice_no의 값을 넘긴다 -->
						<!-- 주소?키=값 -->
							<%=n.noticeTitle%>
						</a>
					</td>
					<td><%=n.createdate.substring(0, 10) %></td>
					<!-- 자바의 날짜타입과 똑같지 않기 때문에 String타입으로 받는다 (참조타입끼리는 자동형변환이 가능하기 때문에)-->
					<!-- 시간이 제대로 출력되지 않기 때문에 substring 메서드를 이용하여 날짜부분만 출력 -->
					<!-- (시작 인덱스, 끝 인덱스) 시작 인덱스부터 ~ 끝 인덱스 앞까지 출력, 인덱스의 시작은 0 -->
				</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<br><br>
	<h1> &#x1F49B; 오늘의 일정 &#x1F33B; </h1>
	<table class="table">
		<thead class="table-warning h5 krFont">
			<tr>
				<th>날짜</th>
				<th>시간</th>
				<th>일정메모</th>
			</tr>
		</thead>
		<tbody>
			<%
				for(Schedule s : scheduleList) {
			%>
				<tr>
					<td>
						<%
							// scheduleDate에서 y,m,d 값 받기
							String y = s.scheduleDate.substring(0,4);
							int m = Integer.parseInt(s.scheduleDate.substring(5,7)) - 1; // 자바 API는 0월부터 시작
							String d = s.scheduleDate.substring(8);
						%>
						<a class="text-dark" href="./scheduleListByDate.jsp?y=<%=y%>&m=<%=m%>&d=<%=d%>">
							<%=s.scheduleDate%>
						</a>
					</td>
					<td><%=s.scheduleTime.substring(0, 5)%></td>
					<td>
						<!-- 별명 사용 -->
						<div style="color: <%=s.scheduleColor%>">
							<%=s.scheduleMemo%>
						</div>
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