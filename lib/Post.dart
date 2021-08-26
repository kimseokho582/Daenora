import 'dart:convert';
import 'package:deanora/detail/assignment.dart';
import 'package:deanora/detail/lecture.dart';
import 'package:http/http.dart' as http;

class Post {
  Future<List> postClass(id, pw) async {
    var url = Uri.parse(
        'http://ec2-15-164-95-61.ap-northeast-2.compute.amazonaws.com:4000/classes');
    var response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode({'id': id, 'pw': pw}));
    List json = jsonDecode(response.body);
    List classes = [];
    json.forEach((e) {
      classes.add(Lecture(e["className"], e["profName"], e["classId"]));
    });
    return classes;
  }

  Future<List> postAssignment(id, pw, classId) async {
    var url = Uri.parse(
        'http://ec2-15-164-95-61.ap-northeast-2.compute.amazonaws.com:4000/assignments');
    var response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode({'id': id, 'pw': pw, 'classId': classId}));

    List json = jsonDecode(response.body);
    List assignment = [];
    json.forEach((e) {
      assignment.add(Assignment(e["index"], e["assignmentName"], e["startDate"],
          e["endDate"], e["submission"]));
    });
    return assignment;
  }
}

Post post = Post();
