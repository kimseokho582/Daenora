class Pair<Datetime, T1> {
  final Datetime schduleDate;
  final T1 schduleString;
  Pair(this.schduleDate, this.schduleString);
}

List<Pair> schedule = [
  Pair("2021-03-01", "삼일절"),
  Pair("2021-03-02", "1학기 개강"),
  Pair("2021-03-02/2021-03-08", "2차 수강정정 기간"),
  Pair("2021-03-02/2021-03-05", "2차 일반휴학 신청 기간"),
  Pair("2021-03-08/2021-03-12", "전액 2차 등록 기간"),
  Pair("2021-03-08/2021-03-09", "조기졸업 신청 기간"),
  Pair("2021-03-22/2021-03-23", "수강철회 기간"),
  Pair("2021-03-26", "수강주수 1/4선"),
  Pair("2021-04-20/2021-04-26", "수시고사 기간"),
  Pair("2021-04-22", "수강주수 2/4선"),
  //Pair("2021-04-30/2021-05-04", "중간강의평가 및 수시고사 성적 확인"),
  Pair("2021-05-05", "어린이날(보강일: 06.09(수))"),
  Pair("2021-05-10/2021-05-11", "수료자 졸업 신청 기간"),
  Pair("2021-05-12/2021-05-13", "체육대회"),
  Pair("2021-05-19", "부처님 오신 날(보강일:06.10(목))"),
  Pair("2021-05-21", "수업주수 3/4"),
  Pair("2021-06-06", "현충일"),
  Pair("2021-06-08/2021-06-14", "보강주(어린이날, 부처님 오신날)"),
  Pair("2021-06-15/2021-06-21", "기말고가 기간"),
  Pair("2021-06-15/2021-06-28", "성적입력 기간"),
  Pair("2021-06-21", "1학기 종강"),
  Pair("2021-06-22", "하계 계절수업 개강"),
  Pair("2021-06-29/2021-07-02", "강의평가, 성적확인 및 정정기간"),
  Pair("2021-07-12", "하계 계절수업 종강"),
  Pair("2021-07-12/2021-07-16", "재입학 신청 기간"),
  Pair("2021-07-19/2021-07-23", "부·복·연계·자기설계전공 및 전과 신청"),
  Pair("2021-07-26/2021-07-27", "졸업연기 신청 기간"),
  Pair("2021-07-19/2021-07-30", "휴학 및 복학 신청 기간"),
  Pair("2021-08-15", "광복절"),
  Pair("2021-08-20", "대학원 후기 학위수여식"),
  Pair("2021-08-23/2021-08-27", "전액 1차 등록 기간"),
  Pair("2021-08-23/2021-08-26", "2학기 수강신청 기간"),
  Pair("2021-08-27", "1차 수강정정 기간"),
  Pair("2021-09-01", "2학기 개강"),
  Pair("2021-09-28/2021-09-30", "축제"),
  Pair("2021-10-01", "수업주수 1/4선"),
  Pair("2021-10-09", "한글날"),
  Pair("2021-10-20/2021-10-26", "수시고사 기간"),
  Pair("2021-10-21", "한날"),
  Pair("2021-10-29", "수업주수 2/4선"),
  Pair("2021-11-01/2021-11-03", "중간강의평가 및 수시고사 성적 확인"),
  Pair("2021-11-08/2021-11-09", "수료자 졸업 신청 기간"),
  Pair("2021-11-24", "수업주수 3/4선"),
  Pair("2021-12-08/2021-12-14", "보강주(추석연휴, 개교기념일)"),
  Pair("2021-12-15/2021-12-21", "기말고사 기간"),
  Pair("2021-12-15/2021-12-28", "성적입력 기간"),
  Pair("2021-12-21", "2학기 종강"),
  Pair("2021-12-22", "동계 계정학기 개강"),
  //Pair("2021-12-29/2022-01-03", "강의평가, 성적확인 및 정정 기간"),
];
