<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %> <!-- *로 모든 명령어를 import 가능 -->
<%
	// 한글 깨지지 않게 인코딩
	request.setCharacterEncoding("utf-8");

	// 유효성 검사(1) scheduleDate가 null이거나 공백일 경우
	if(request.getParameter("scheduleDate") == null
			|| request.getParameter("scheduleDate").equals("")) {
		response.sendRedirect("./scheduleList.jsp"); // 리스트페이지로
		return;
	}
	
	// scheduleDate가 null이거나 공백이 아닐 경우
	// 선택한 날짜 값 변수에 넣기
	String scheduleDate = request.getParameter("scheduleDate");
	System.out.println("insertScheduleAction scheduleDate: " + scheduleDate);
	// scheduleDate의 데이터를 y,m,d 변수에 넣기
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5,7)) - 1; // 넘어온 m의 값은 +1한 상태이기 때문에!
	String d = scheduleDate.substring(8);
	// 디버깅
	System.out.println("insertScheduleAction y: " + y);
	System.out.println("insertScheduleAction m: " + m);
	System.out.println("insertScheduleAction d: " + d);

	// 유효성 검사(2) null이거나 공백일 경우
	String msg = null;
	if(request.getParameter("scheduleTime") == null
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
	System.out.println("insertScheduleAction msg: " + msg); // 디버깅
	
	if(msg != null) {
		response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d + "&msg=" + msg);
		// 스케줄입력페이지로
		return;
	}
	
	// null이거나 공백이 아닐경우
	// 값 변수에 받기
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	// 디버깅
	System.out.println("insertScheduleAction scheduleTime: " + scheduleTime);
	System.out.println("insertScheduleAction scheduleColor: " + scheduleColor);
	System.out.println("insertScheduleAction scheduleMemo: " + scheduleMemo);
	System.out.println("insertScheduleAction schedulePw: " + schedulePw);
	
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
				
	// 2) mariadb 서버에 접속, 접속 유지
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		
	// 3) 쿼리 생성 후 실행
	String sql = "INSERT into schedule(schedule_date, schedule_time, schedule_color, schedule_memo, schedule_pw, createdate, updatedate) values(?,?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 총 4개 (1~4)
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setString(5, schedulePw);
	System.out.println("insertScheduleAction sql: " + stmt); // 디버깅
	
	// 4) 쿼리가 잘 실행되었는지 확인
	int row = stmt.executeUpdate(); // 성공시 1, 실패시 0
	if(row == 1) {
		System.out.println("insertScheduleAction 쿼리 실행 성공");
	} else {
		System.out.println("insertScheduleAction 쿼리 실행 실패");
	}
	
	// view가 없으므로 insert 후 리다이렉션
	response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
%>