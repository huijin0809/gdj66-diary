<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%
	// post방식 인코딩 처리 (한글 깨지지 않게)
	request.setCharacterEncoding("utf-8");

	// validation (요청 파라미터값 유효성 검사)
	// 공백도 잊지 말기! 공백은 equals로
	String msg = null;
	if(request.getParameter("noticeTitle") == null
			|| request.getParameter("noticeTitle").equals("")) {
		msg = "Title is required!";
	} else if(request.getParameter("noticeContent") == null
			|| request.getParameter("noticeContent").equals("")) {
		msg = "Content is required!";
	} else if(request.getParameter("noticeWriter") == null
			|| request.getParameter("noticeWriter").equals("")) {
		msg = "Writer is required!";
	} else if(request.getParameter("noticePw") == null
			|| request.getParameter("noticePw").equals("")) {
		msg = "Password is required!";
	}
	System.out.println("insertNoticeAction msg: " + msg); // 디버깅
	
	if(msg != null) {
		response.sendRedirect("./insertNoticeForm.jsp?msg=" + msg);
		return;
	}

	// 값 변수로 받아놓기
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	
	// 값들을 데이터 테이블에 입력(insert)
	/*
		insert into notice(
				notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate
		) values(?,?,?,?,now(),now())
	*/
	
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
			
	// 2) mariadb 서버에 접속, 접속 유지
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	// 3) 쿼리 생성 후 실행
	String sql = "INSERT INTO notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 총 4개 (1~4)
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	System.out.println("insertNoticeAction sql: " + stmt); // 디버깅
	
	// 4) 쿼리가 잘 실행되었는지 확인
	int row = stmt.executeUpdate(); // 디버깅용도, 1이면 1행 insert성공/ 2면 2행 insert성공 / 0이면 insert된 행이 없음
	// conn.commit(); // conn.setAutoCommit의 디폴트값이 ture이므로 자동 commit되기 때문에 생략
	if(row == 1) {
		System.out.println("insertNoticeAction 쿼리 실행 성공");
	} else {
		System.out.println("insertNoticeAction 쿼리 실행 실패");
	}
	
	// view가 없으므로 redirection
	response.sendRedirect("./noticeList.jsp");
%>