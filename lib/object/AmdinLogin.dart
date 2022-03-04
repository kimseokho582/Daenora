Map<String, String> adminUser = {'name': '슈퍼계정', 'studentId': '슈퍼 1'};

List<Map<String, String>> adminClasses = [
  {'classId': "1", 'className': "임시 과목 1", 'profName': '교수 1'},
  {'classId': "2", 'className': "임시 과목 2", 'profName': '교수 2'},
  {'classId': "3", 'className': "임시 과목 3", 'profName': '교수 3'},
  {'classId': "4", 'className': "임시 과목 4", 'profName': '교수 4'},
  {'classId': "5", 'className': "임시 과목 5", 'profName': '교수 5'},
  {'classId': "6", 'className': "임시 과목 6", 'profName': '교수 6'},
];

class AdminAssignments {
  var _num = "";
  AdminAssignments(this._num);
  List<Map<String, String>> adminAssignment = [];

  List<Map<String, String>> postAdminAssiment() {
    for (var i = 1; i <= 10; i++) {
      adminAssignment.add({
        'title': '임시 과제 ${this._num}-${i}',
        'state': i % 2 == 0 ? '제출완료' : '미제출',
        'startDate': "2022-0${this._num}-0${i}",
        'endDate': "2022-0${this._num}-0${i}",
        'text': "",
      });
    }
    return adminAssignment;
  }
}
