<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%
	// select 쿼리를 mariadb에 전송 후 결과셋을 받아서 출력하는 페이지
	
	// 1) mariadb 프로그램 사용 가능하도록 장치 드라이버를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb 서버에 로그인 후 접속정보를 반환받아야 한다
	Connection conn = null; // 접속정보 타입
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("접속성공"+conn);
	
	// 3) 쿼리생성 후 실행
	String sql = "select student_no, student_name, student_age from student";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	System.out.println("쿼리실행성공"+rs);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>studentList.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container mt-3">
	<h2>학생목록</h2>
 	<table class="table">
		<thead class="table-success">
			<tr>
				<th>no</th>
				<th>name</th>
				<th>age</th>
			</tr>
		</thead>
		<tbody>
		
		<%
			while(rs.next()) {
		%>
			<tr>
				<td><%=rs.getInt("student_no") %></td>
				<td><%=rs.getString("student_name") %></td>
				<td><%=rs.getInt("student_age") %></td>
			</tr>
		<%
			}
		%>
		</tbody>
	</table>
</div>
</body>
</html>