<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %> <!-- 수정폼도 select 해야하므로 rs 이용 -->
<%@ page import = "vo.*" %>
<%
	// 유효성 검사
	// null일 경우 리다이렉션
	// 리턴 // 코드진행종료 // 반환값을 넘길때
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	// null이 아닐경우
	// 변수에 값 받기 // int 타입으로 변환
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println("updateNoticeForm noticeNo: " + noticeNo); // 디버깅
	
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
	// 2) db서버에 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리 작성
	// 해당 no에 맞는 페이지 출력 == noticeOne 페이지와 같은 sql
	String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate FROM notice WHERE notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 첫번째 ?에 noticeNo 값을 set
	stmt.setInt(1, noticeNo);
	System.out.println("updateNoticeForm sql: " + stmt); // 디버깅
	
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> 데이터 타입(Notice)의 클래스로 바꾸기
	Notice notice = null;
	// 한번에 쓰면 Notice notice = new Notice();
	if(rs.next()) {
		notice = new Notice();
		notice.noticeNo = rs.getInt("noticeNo");
		notice.noticeTitle = rs.getString("noticeTitle");
		notice.noticeContent = rs.getString("noticeContent");
		notice.noticeWriter = rs.getString("noticeWriter");
		notice.createdate = rs.getString("createdate");
		notice.updatedate = rs.getString("updatedate");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm.jsp</title>
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
	<h1 class="krFont"> 공지 수정하기 &#x1F4DD </h1>
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
	<form action="./updateNoticeAction.jsp" method="post">
		<table class="table container">
			<tr>
				<!-- 수정불가지만, action페이지에서 where절에 들어가야하므로 (값을 넘겨야하므로) input type은 hidden으로 숨기기 -->
				<th class="table-warning">글번호</th>
				<td>
					<%=notice.noticeNo%> <!-- 단순 출력 -->
					<input type="hidden" name="noticeNo" value="<%=notice.noticeNo%>">
				</td>
			</tr>
			<tr>
				<!-- 수정가능란, input태그 -->
				<th class="table-warning">공지 제목</th>
				<td>
					<input type="text" name="noticeTitle" value="<%=notice.noticeTitle%>">
				</td>
			</tr>
			<tr>
				<!-- 수정가능란, input태그 -->
				<th class="table-warning">공지 내용</th>
				<td>
					<textarea rows="5" cols="80" name="noticeContent"><%=notice.noticeContent%></textarea>
				</td>
			</tr>
			<tr>
				<!-- 수정불가란, 출력만 하기 -->
				<th class="table-warning">작성자</th>
				<td>
					<%=notice.noticeWriter%>
				</td>
			</tr>
			<tr>
				<!-- 수정불가란, 출력만 하기 -->
				<th class="table-warning">생성일자</th>
				<td>
					<%=notice.createdate.substring(0, 10)%>
				</td>
			</tr>
			<tr>
				<!-- 수정불가란, 출력만 하기 -->
				<th class="table-warning">수정일자</th>
				<td>
					<%=notice.updatedate.substring(0, 10)%>
				</td>
			</tr>
			<tr>
				<!-- 패스워드입력란, action페이지에서 where절에 들어가야하므로 (값을 넘겨야하므로) input태그 -->
				<th class="table-warning">비밀번호</th>
				<td>
					<input type="password" name="noticePw" placeholder="비밀번호를 입력해주세요">
				</td>
			</tr>
		</table>
		<div>
			<a class="btn btn-outline-secondary" href="./noticeOne.jsp?noticeNo=<%=noticeNo%>">뒤로</a>
			<button type="submit" class="btn btn-outline-secondary">수정</button>
		</div>
	</form>
</div>
<div class="mt-5 p-4 bg-secondary text-white text-center krFont">
  <p>구디아카데미 GDJ 66기 김희진</p>
</div>
</body>
</html>