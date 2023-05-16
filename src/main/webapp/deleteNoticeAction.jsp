<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%
	// 요청값 유효성 검사
	String msg = null;
	if(request.getParameter("noticeNo") == null
			|| request.getParameter("noticeNo").equals("")) {
		response.sendRedirect("./noticeList.jsp");
		// 비정상적인 접근(noticeNo가 null이거나 공백)은 list페이지로
		return;
	} else if(request.getParameter("noticePw") == null
			|| request.getParameter("noticePw").equals("")) {
		msg = "Password is required!"; // 비밀번호가 null이거나 공백일 경우 msg 발생
	}
	System.out.println("deleteNoticeAction msg: " + msg); // 디버깅
	
	// msg 발생 시 해당 form 페이지로 리다이렉션 // msg도 출력되게 하기 위해 같이 넘겨준다
	if(msg != null) {
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo=" + request.getParameter("noticeNo") + "&msg=" + msg);
		return;
	}

	// 유효성 검사에 걸리지 않았을 경우 값 변수에 받기
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	
	// 디버깅 // 어디에서 출력하는 건지도 같이 적어주기
	System.out.println("deleteNoticeAction noticeNo: " + noticeNo);
	System.out.println("deleteNoticeAction noticePw: " + noticePw);
	
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 2) mariadb 서버에 접속, 접속 유지
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 삭제 쿼리 생성
	// storeNo와 storepw가 모두 일치해야하므로 and절 사용
	String sql = "DELETE FROM notice WHERE notice_no=? AND notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 총 2개 (1~2)
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	System.out.println("deleteNoticeAction sql: " + stmt); // 디버깅
	
	// 삭제 쿼리가 잘 실행되었는지 확인
	int row = stmt.executeUpdate(); // 정상 실행시 1, 실패시 0
	System.out.println("deleteNoticeAction row: " + row);
	
	if(row == 0) { // 0일경우 패스워드 오류
		msg = "incorrect Password!";
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo=" + noticeNo + "&msg=" + msg);
	} else { // 1일경우 쿼리 실행 성공
		response.sendRedirect("./noticeList.jsp");
	}
%>