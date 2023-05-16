<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 유효성 검사
	String msg = null;
	if(request.getParameter("scheduleNo") == null
			|| request.getParameter("scheduleNo").equals("")
			|| request.getParameter("scheduleDate") == null
			|| request.getParameter("scheduleDate").equals("")) {
		response.sendRedirect("./scheduleList.jsp");
		// null이거나 공백일 경우 리스트페이지로
		return;
	} else if(request.getParameter("schedulePw") == null
			|| request.getParameter("schedulePw").equals("")) {
		msg = "Password is required!";
		// 비밀번호가 null이거나 공백일 경우 msg 발생
	}
	System.out.println("deleteScheduleAction msg: " + msg); // 디버깅
	
	// 비밀번호가 null이거나 공백일 경우 (msg 발생) 리다이렉션 // msg도 출력되게 하기 위해 같이 넘겨준다
	if(msg != null) {
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo=" + request.getParameter("scheduleNo") + "&scheduleDate=" + request.getParameter("scheduleDate") + "&msg=" + msg);
		return;
	}
	
	// 값 변수에 받기
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo")); // no는 int타입
	String scheduleDate = request.getParameter("scheduleDate");
	String schedulePw = request.getParameter("schedulePw");
	System.out.println("deleteScheduleAction scheduleNo: " + scheduleNo);
	System.out.println("deleteScheduleAction scheduleDate: " + scheduleDate);
	System.out.println("deleteScheduleAction schedulePw: " + schedulePw);
	
	// scheduleDate에서 y,m,d 값 받기
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7)) - 1; // 자바 API는 0월부터 시작
	String d = scheduleDate.substring(8);
	System.out.println("deleteScheduleAction y: " + y);
	System.out.println("deleteScheduleAction m: " + m);
	System.out.println("deleteScheduleAction d: " + d);
	
	// 1) 드라이버로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
	// 2) db서버에 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리 작성
	String sql = "DELETE FROM schedule WHERE schedule_no=? AND schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 총 2개
	stmt.setInt(1, scheduleNo);
	stmt.setString(2, schedulePw);
	System.out.println("deleteScheduleAction sql: " + stmt);
	
	// 쿼리가 잘 실행되었는지 확인하기
	int row = stmt.executeUpdate(); // 성공시 1, 실패시 0
	System.out.println("deleteScheduleAction row: " + row);
		
	// 쿼리 실행 결과(row값)에 따라 리다이렉션
	if(row == 0) { // 0일 경우 패스워드 오류
		msg = "incorrect schedulePw!";
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo=" + scheduleNo + "&scheduleDate=" + scheduleDate + "&msg=" + msg);
		// msg와 함께 form페이지로
	} else if(row == 1) { // 1일 경우 쿼리 실행 성공
		response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
		// 삭제 성공시 확인을 위해 해당 ListByDate페이지로
	}
%>
