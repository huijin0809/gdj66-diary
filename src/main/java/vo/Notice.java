package vo;
// notice 테이블의 한행(레코드)를 저장하는 용도
// Value Object or Data Transfer Object or Domain
public class Notice {
	public int noticeNo;
	public String noticeTitle;
	public String noticeContent;
	public String noticeWriter;
	public String createdate; // Date타입 또는 String타입 중에 선택
	public String updatedate;
	public String noticePw;
}
