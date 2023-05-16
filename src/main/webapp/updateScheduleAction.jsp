<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %> <!-- *로 모든 명령어를 import 가능 -->
<%
	//한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");

	// 유효성 검사 (1) scheduleNo가 null일 경우
	if(request.getParameter("scheduleNo") == null) {
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	// scheduleNo가 null이 아닐경우 값 변수에 받기
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	
	// 유효성 검사 (2)
	// form페이지에서 입력한 값이 null이거나 공백일 경우에 따라 msg 분기
	String msg = null;
	if(request.getParameter("scheduleDate") == null
			|| request.getParameter("scheduleDate").equals("")) {
		msg = "Date is required!";
	} else if(request.getParameter("scheduleTime") == null
			|| request.getParameter("scheduleTime").equals("")) {
		msg = "Time is required!";
	} else if(request.getParameter("scheduleColor") == null
			|| request.getParameter("scheduleColor").equals("")) {
		msg = "Color is required!";
	} else if(request.getParameter("scheduleMemo") == null
			|| request.getParameter("scheduleMemo").equals("")) {
		msg = "Memo is required!";
	} else if(request.getParameter("schedulePw") == null
			|| request.getParameter("schedulePw").equals("")) {
		msg = "Password is required!";
	}
	System.out.println("updateScheduleAction msg: " + msg); // 디버깅
	
	// msg 발생시 리다이렉션
	if(msg != null) {
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo=" + scheduleNo + "&msg=" + msg);
		return;
	}
	
	// form페이지에서 입력한 값이 null이거나 공백이 아닐 경우 값 변수에 받기
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	// 디버깅
	System.out.println("updateScheduleAction scheduleNo: " + scheduleNo);
	System.out.println("updateScheduleAction scheduleDate: " + scheduleDate);
	System.out.println("updateScheduleAction scheduleTime: " + scheduleTime);
	System.out.println("updateScheduleAction scheduleColor: " + scheduleColor);
	System.out.println("updateScheduleAction scheduleMemo: " + scheduleMemo);
	System.out.println("updateScheduleAction schedulePw: " + schedulePw);
	
	// scheduleDate에서 y,m,d 값 받기
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7)) - 1; // 자바 API는 0월부터 시작
	String d = scheduleDate.substring(8);
	System.out.println("updateScheduleAction y: " + y);
	System.out.println("updateScheduleAction m: " + m);
	System.out.println("updateScheduleAction d: " + d);
	
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
	// 2) db서버에 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리 작성
	String sql = "UPDATE schedule SET schedule_date=?, schedule_time=?, schedule_color=?, schedule_memo=?, updatedate=now() WHERE schedule_no=? AND schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 총 5개
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setInt(5, scheduleNo); // noticeNo는 int타입
	stmt.setString(6, schedulePw);
	System.out.println("updateScheduleAction sql: " + stmt); // 디버깅
	
	// 쿼리가 잘 실행되었는지 확인하기
	int row = stmt.executeUpdate(); // 성공시 1, 실패시 0
	System.out.println("updateScheduleAction row: " + row);
	
	// 쿼리 실행 결과(row값)에 따라 리다이렉션
	if(row == 0) { // 0일 경우 패스워드 오류
		msg = "incorrect Password!";
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo=" + scheduleNo + "&msg=" + msg);
		// msg와 함께 form페이지로
	} else if(row == 1) { // 1일 경우 쿼리 실행 성공
		response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
		// 수정된 화면 확인을 위해 ListByDate페이지로
	}
%>
