<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %> <!-- 조회할 때만 사용 -->
<%@ page import = "java.util.*" %> <!-- arraylist 사용하기 위해 -->
<%@ page import = "vo.*" %> <!-- 만든 클래스 가져오기 -->
<%
	// 요청분석
	// 현재페이지
	int currentPage = 1; // 현재 페이지는 1페이지부터 시작
	if(request.getParameter("currentPage") != null) { // 즉, 이전 or 다음을 눌렀을 경우
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println("currentPage: " + currentPage); // 디버깅
	
	// 페이지당 출력할 행의 수
	int rowPerPage = 10; // 공지를 몇개씩 출력할지
	
	// 시작 행 번호
	int startRow = (currentPage-1)*rowPerPage; 
	/*
	currentPage		startRow(rowPerPage 10일때)	
	1				0	<-- (currentPage-1)*rowPerPage
	2				10
	3				20
	4				30
	*/
	// int startRow = 0; // 1페이지 일때는 0으로 시작
	
	
	// DB연결 설정
	// select notice_no, notice_title, createdate from notice
	// order by createdate desc
	// limit ?, ?
	// 값은 페이지마다 계속 바뀔 것이므로 ?로 둔다
				
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
	// 2) mariadb 서버에 접속, 접속 유지
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리 생성 후 실행
	String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, createdate FROM notice ORDER BY createdate DESC limit ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 총 2개
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage); 
	System.out.println("noticeList sql: " + stmt); // 디버깅
	
	// 공지 리스트 출력하기
	ResultSet rs = stmt.executeQuery();
	// ResultSet타입(집합 자료구조타입)을 일반적인 타입(자바 배열 또는 기본API안에 있는 자료구조 타입인 List, Set, Map 등..)으로 바꾸기
	// ResultSet -> ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()) {
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo"); // 이름이 불일치 // sql 작성시 별명으로 받아서 통일시켜주는 것이 좋음
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
	
	// 데이터 총 갯수
	// select count(*) from notice
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	int totalRow = 0;
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)"); // 이 ResultSet은 굳이 바꿀 필요 없음 // 이미 int타입인 totalRow라는 변수로 바뀌었기 때문
	}
	
	// 마지막 페이지
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) { // 페이지가 딱 나누어떨어지지 않으면 한페이지가 더 필요하다
		lastPage = lastPage + 1;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeList.jsp</title>
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
<div class="container mt-3 center">
	<div><!-- 메인메뉴 -->
		<a class="btn btn-warning krFont" href="./home.jsp">홈으로</a>
		<a class="btn btn-outline-warning krFont" href="./noticeList.jsp">공지 리스트</a> <!-- 최근 10개씩 -->
		<a class="btn btn-outline-warning krFont" href="./scheduleList.jsp">일정 리스트</a> <!-- 이번달 전체 -->
	</div>
	<br>
	<table class="container">
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>
				<h1 class="enFont"> &#x1F49B notice list &#x1F33B </h1> <!-- 출력할 땐 month +1 -->
			</td>
			<td>
				<a class="btn btn-outline-secondary btn-sm krFont" href="./insertNoticeForm.jsp">공지입력</a>
			</td>
		</tr>
	</table>	
	<table class="table">
		<thead class="table-warning h5 krFont">
		<tr>
			<th>공지 제목</th>
			<th>작성일자</th>
		</tr>
		</thead>
		<tbody>
		<%
			// while(rs.next()) {
			for(Notice n : noticeList) {
		%>
			<tr>
				<td>
					<a class="krFont text-dark" href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
						<%=n.noticeTitle %>
					</a>
				</td>
				<td class="krFont"><%=n.createdate.substring(0, 10) %></td>
			</tr>
		<%
			}
		%>
		</tbody>
	</table>
	
	<%
		if(currentPage > 1) { // 이전은 1페이지에서는 출력되면 안된다
	%>
			<a class="krFont text-dark" href="./noticeList.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
 	%>
		<span class="enFont"> <%=currentPage%> </span> <!-- 현재페이지 -->
	<%
		if(currentPage < lastPage) { // 마지막 페이지에서는 다음이 촐력되면 안된다
	%>
			<a class="krFont text-dark" href="./noticeList.jsp?currentPage=<%=currentPage+1%>">다음</a>
	<%
		}
	%>
</div>
<div class="mt-5 p-4 bg-secondary text-white text-center krFont">
  <p>구디아카데미 GDJ 66기 김희진</p>
</div>
</body>
</html>