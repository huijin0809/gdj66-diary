<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%
	// post방식 인코딩처리 // 한글 깨지지 않게
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 (1)
	// noticNo가 null이면 form페이지로 갈 수 없으므로 list페이지로 리다이렉션
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return; // 코드진행종료
	}

	// 유효성 검사 (2)
	// null 이거나 공백인 것에따라 에러메세지(msg) 분기
	String msg = null;
	if(request.getParameter("noticeTitle") == null
			|| request.getParameter("noticeTitle").equals("")) {
			msg = "Title is required!";
	} else if(request.getParameter("noticeContent") == null
			|| request.getParameter("noticeContent").equals("")) {
			msg = "Content is required!";
	} else if(request.getParameter("noticePw") == null
			|| request.getParameter("noticePw").equals("")) {
			msg = "Password is required!";
	}
	System.out.println("updateNoticeAction msg: " + msg); // 디버깅
	
	// msg 발생 시 수정폼 페이지로 리다이렉션 // msg도 출력되게 하기 위해 같이 넘겨준다
	if(msg != null) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo=" + request.getParameter("noticeNo") + "&msg=" + msg);
		return; // 코드진행종료
	}
	
	// null 이거나 공백이 아닐 경우
	// 값 변수에 받기 (형변환)
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo")); // int타입으로 변환
	String noticePw = request.getParameter("noticePw");
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	
	// 디버깅
	// 어느 페이지의 어떤 디버깅인지도 잘 적어주기
	System.out.println("updateNoticeAction noticeNo: " + noticeNo);
	System.out.println("updateNoticeAction noticePw: " + noticePw);
	System.out.println("updateNoticeAction noticeTitle: " + noticeTitle);
	System.out.println("updateNoticeAction noticeContent: " + noticeContent);
	
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
				
	// 2) mariadb 서버에 접속, 접속 유지
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		
	// 3) 쿼리 생성 후 실행
	// UPDATE notice SET notice_title=? , notice_content=? , updatedate=now() WHERE notice_no=? AND notice_pw=?
	String sql = "UPDATE notice SET notice_title=? , notice_content=? , updatedate=now() WHERE notice_no=? AND notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 총 4개
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setInt(3, noticeNo); // noticeNo는 int타입
	stmt.setString(4, noticePw);
	System.out.println("updateNoticeAction sql: " + stmt); // 디버깅
	
	// 쿼리가 잘 실행되었는지 확인
	int row = stmt.executeUpdate(); // 수정 성공시 1, 실패시 0
	System.out.println("updateNoticeAction row: " + row);
	
	// 수정 성공 유무에 따라 리다이렉션
	// = 쿼리 실행 결과에 따라 페이지(View)를 분기한다
	if(row == 0) { // 패스워드가 일치하지 않는 경우
		msg = "incorrect Password!";
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo=" + noticeNo + "&msg=" + msg);
		// form페이지로 // msg 발생
   	} else if(row == 1) { // 쿼리 실행 성공
      response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
   		// 확인을 위해 상세페이지(noticeOne)로
  	} else { // 그 외 경우의 에러 발생은 update문 실행을 취소(rollback)해야 한다
      System.out.println("error 발생 row값 : "+row);
 	}

%>