<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %> <!-- *로 모든 명령어를 import 가능 -->
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	// if문보다 먼저 선언
	int targetYear = 0;
	int targetMonth = 0;
	
	// 유효성 검사 // null이면 오늘 날짜의 년월값 주기
	if (request.getParameter("targetYear") == null
			|| request.getParameter("targetMonth") == null) {
		Calendar c =  Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH); // 0~11월이지만 여기서 +1을 하면 알고리즘이 깨짐
	} else { // null이 아닐 경우 형변환
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	// 디버깅
	System.out.println("scheduleList targetYear: " + targetYear + "년");
	System.out.println("scheduleList targetMonth: " + targetMonth + "월");
	
	// 본격적으로 날짜 구하기
	// 오늘 날짜 (오늘 날짜를 표시해주기 위해!)
	Calendar today = Calendar.getInstance();
	int todayYear = today.get(Calendar.YEAR);
	int todayMonth = today.get(Calendar.MONTH);
	int todayDate = today.get(Calendar.DATE);
	System.out.println("today: " + todayYear + "-" + todayMonth + "-" + todayDate);
	
	// targetMonth(출력할 월)의 1일로 셋팅
	Calendar targetDay = Calendar.getInstance();
	targetDay.set(Calendar.YEAR, targetYear);
	targetDay.set(Calendar.MONTH, targetMonth);
	targetDay.set(Calendar.DATE, 1);
	
	// 셋팅한 뒤, api 내부에서 자동으로 변경된 값 다시 변수에 넣기
	/*
		년23월12 입력 Calendar API내부에서 년24 월1변경
		년23월-1 입력 Calendar API내부에서 년22 월12 변경
	*/
	targetYear = targetDay.get(Calendar.YEAR);
	targetMonth = targetDay.get(Calendar.MONTH);
	System.out.println("scheduleList api 실행 후 targetYear: " + targetYear + "년");
	System.out.println("scheduleList api 실행 후 targetMonth: " + targetMonth + "월");
	
	// targetMonth(출력할 월)의 1일의 요일 구하기
	// DAY_OF_WEEK (일요일부터 토요일까지 1,2,3,4,5,6,7)			
	int firstYoil = targetDay.get(Calendar.DAY_OF_WEEK);
	System.out.println("firstYoil: " + firstYoil);
	// 1일 앞의 공백칸 수 구하기
	int startBlank = firstYoil - 1;
	System.out.println("startBlank: " + startBlank + "개");
	
	// targetMonth(출력할 월)의 마지막일 구하기
	// ActualMaximum 가지고 있는 날짜 중에 가장 큰 날짜 즉, 마지막 날짜
	int lastDate = targetDay.getActualMaximum(Calendar.DATE);
	System.out.println("lastDate: " + lastDate + "일");
	// 마지막일 뒤의 공백칸 수 구하기
	int endBlank = 0;
	if((startBlank + lastDate) % 7 != 0 ) {
		endBlank = 7 - ((startBlank + lastDate) % 7);
		// 나머지는 마지막 줄에서 출력된 칸 수이므로 7에서 빼주면 공백칸 수를 구할 수 있다
	}
	System.out.println("endBlank: " + endBlank + "개");
	
	// targetMonth(출력할 월)의 총 td의 갯수
	int totalTd = startBlank + lastDate + endBlank;
	System.out.println("totalTd: 총 " + totalTd + "개");
	
	// 전월 마지막날짜 구하기
	Calendar preDate = Calendar.getInstance();
 	preDate.set(Calendar.YEAR, targetYear);
	preDate.set(Calendar.MONTH, targetMonth-1);
	int preEndDate = preDate.getActualMaximum(Calendar.DATE);
	
	// DB date를 가져오는 알고리즘
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 	
	// 2) mariadb 서버에 접속, 접속 유지
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 3) 쿼리 생성 후 실행
	String sql = "SELECT schedule_no scheduleNo, DAY(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor FROM schedule WHERE YEAR(schedule_date)=? AND MONTH(schedule_date)=? ORDER BY MONTH(schedule_date) ASC;";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth + 1); // 자바API와 마리아DB의 시작월이 0과 1로 다르기 때문에 +1을 해준다
	System.out.println("scheduleList sql: " + stmt);
	
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule(); // rs의 갯수만큼 만들어짐
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 실제로는 day(일)만 가져옴
		s.scheduleMemo = rs.getString("scheduleMemo"); // 메모 전체가 아닌 일부(5글자)만 가져옴
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleList.jsp</title>
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
			<td>
				<a class="btn btn-outline-secondary btn-sm krFont" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth - 1%>">이전달</a>
			</td>
			<td>
				<h1 class="enFont"> &#x1F49B <%=targetYear%>.<%=targetMonth + 1%> calendar &#x1F33B </h1> <!-- 출력할 땐 month +1 -->
			</td>
			<td>
				<a class="btn btn-outline-secondary btn-sm krFont" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth + 1%>">다음달</a>
			</td>
		</tr>
	</table>
	<table class="table">
		<thead class="table-warning h5 krFont">
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<%
					for(int i=0; i<totalTd; i+=1) { // totalTd만큼 출력
						if(i != 0 && i % 7 == 0) { // 7칸마다 줄바꿈(tr)
				%>
							</tr><tr>
					<%
						}
						String tdStyle = "";
						int num = i - startBlank + 1; // td에 출력되는 일
						if(num > 0 && num <= lastDate) { // 출력되는 일은 1일~마지막일
							// 오늘 날짜 표시해주기 // tdStyle 변수 이용
							if(todayYear == targetYear
								&& todayMonth == targetMonth
								&& todayDate == num) {
								tdStyle ="background-color: #FFE08C;";
							}
							if(i % 7 == 0) { // 일요일
					%>
							<td style = "<%=tdStyle%>">
								<div class="h5 enFont"> <!-- num일 -->
									<a class="text-danger" href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>
								</div>
								<div> <!-- 일정 memo 잘라서(5글자만) 보여주기 -->
									<%
										for(Schedule s : scheduleList) { // 이렇게 하면 일마다 모든 값이 출력됨
											if(num == Integer.parseInt(s.scheduleDate)) { // num일과 일치하는 값만 출력됨 // num은 int타입이므로 맞춰주기
									%>
												<div class="krFont" style="color: <%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
												<!-- style에 color값 넣어주기 -->
									<%
											}
										}
									%>
								</div>
							</td>
					<%
							} else if(i % 7 == 6) { // 토요일
					%>
							<td style = "<%=tdStyle%>">
								<div class="h5 enFont"> <!-- num일 -->
									<a class="text-primary" href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>
								</div>
								<div> <!-- 일정 memo 잘라서(5글자만) 보여주기 -->
									<%
										for(Schedule s : scheduleList) { // 이렇게 하면 일마다 모든 값이 출력됨
											if(num == Integer.parseInt(s.scheduleDate)) { // num일과 일치하는 값만 출력됨 // num은 int타입이므로 맞춰주기
									%>
												<div class="krFont" style="color: <%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
												<!-- style에 color값 넣어주기 -->
									<%
											}
										}
									%>
								</div>
							</td>
					<%
							} else { // 그 밖 평일
					%>
							<td style = "<%=tdStyle%>">
								<div class="h5 enFont"> <!-- num일 -->
									<a class="text-dark" href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>
								</div>
								<div> <!-- 일정 memo 잘라서(5글자만) 보여주기 -->
									<%
										for(Schedule s : scheduleList) { // 이렇게 하면 일마다 모든 값이 출력됨
											if(num == Integer.parseInt(s.scheduleDate)) { // num일과 일치하는 값만 출력됨 // num은 int타입이므로 맞춰주기
									%>
												<div class="krFont" style="color: <%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
												<!-- style에 color값 넣어주기 -->
									<%
											}
										}
									%>
								</div>
							</td>
				<%
							}	
						} else if(num < 1){ // 1일 전
				%>
							<td class="text-black-50 h5 enFont">
								<%=preEndDate + num%>
							</td>
				<%			
						} else { // 마지막날 이후
				%>
							<td class="text-black-50 h5 enFont">
								<%=num - lastDate%>
							</td>
				<%
						}
					}
				%>
			</tr>
		</tbody>
	</table>
</div>
<div class="mt-5 p-4 bg-secondary text-white text-center krFont">
  <p>구디아카데미 GDJ 66기 김희진</p>
</div>
</body>
</html>