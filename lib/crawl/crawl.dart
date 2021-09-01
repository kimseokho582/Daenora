import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'customException.dart';

class Crawl {
  String _cookie = '';

  Future<http.StreamedResponse> _getResponse(
      String method,
      String url,
      [
        Map<String, String> headers = const {},
        Map<String, String> body = const {}
      ]) {
    http.Request request = http.Request(method, Uri.parse(url));
    request.headers.addAll(headers);
    request.bodyFields = body;
    return request.send();
  }

  Future<void> _login(String id, String pw) async {
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = { 'userDTO.userId': id, 'userDTO.password': pw };
    final url = 'http://cyber.anyang.ac.kr/MUser.do?cmd=loginUser';
    final response = await _getResponse('POST', url, headers, body);

    String rawCookie = response.headers['set-cookie'] ?? '';
    if (response.headers['pragma'] != null) throw new CustomException(300, 'Login Failed');
    else {
      int index = rawCookie.indexOf(';');
      this._cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
  Future<Map<String, String>> crawlUser(String id, String pw) async {
    if(this._cookie == '') await _login(id, pw);

    final url = 'http://cyber.anyang.ac.kr/MMain.do?cmd=viewIndexPage';
    final response = await _getResponse('GET', url, {'cookie': this._cookie});
    final document = parse(await response.stream.bytesToString());

    var loginBtn = document.getElementById('login_popup');
    var element = document.querySelector( '.login_info > ul > li:last-child');

    if(loginBtn != null) throw new CustomException(300, 'Cookie has Expired');

    String userData = element!.text;
    List<String> data = userData.split(' ');
    Map<String, String> user = {
      'name': data[0],
      'studentId': data[1].substring(1, data[1].length - 1)
    };

    return user;
  }

  Future<List<Map<String, String>>> crawlClasses(String id, String pw) async {
    if(this._cookie == '') await _login(id, pw);

    final url = 'http://cyber.anyang.ac.kr/MMain.do?cmd=viewIndexPage';
    final response = await _getResponse('GET', url, {'cookie': this._cookie});
    final document = parse(await response.stream.bytesToString());

    var loginBtn = document.getElementById('login_popup');
    var options = document.getElementsByTagName('option');
    List<Map<String, String>> classes = [];

    if(loginBtn != null) throw new CustomException(300, 'Cookie has Expired');
  
    for (var i = 1; i < options.length; i++) {
      var data = options[i].attributes['value']?.split(',');
      classes.add({
        'classId': data?[0] ?? '',
        'className': options[i].text,
        'profName': data?[1] ?? ''
      });
    }

    return classes;
  }

  Future<List<Map<String, String>>> crawlAssignments(String id, String pw, String courseId) async {
    if(this._cookie == '') await _login(id, pw);

    final url = 'http://cyber.anyang.ac.kr/MReport.do?cmd=viewReportInfoPageList&boardInfoDTO.boardInfoGubun=report&courseDTO.courseId=$courseId';
    final response = await _getResponse('GET', url, {'cookie': this._cookie});
    final document = parse(await response.stream.bytesToString());

    var error = document.querySelector('.error_none');
    if(error != null) throw new CustomException(300, 'Cookie has Expired');

    List<Map<String, String>> assignments = [];

    var elements = document.querySelectorAll('.board_list > ul > li:not(:last-child)');
    for(var elem in elements) {
      List<String> date = (elem.querySelector('ul:nth-child(5) > li')?.text ?? '').split('~');
      assignments.add({
        'title': elem.children.first.text.trim().replaceAll('\t', '').replaceAll('\n', ''),
        'state': elem.children.last.text.trim(),
        'startDate': date[0].trim(),
        'endDate': date[1].trim()
      });
    }

    return assignments;
  }
}