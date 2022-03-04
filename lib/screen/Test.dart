import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

String _loginCookie = "";
_registerTest() async {
  final url = Uri.parse("http://52.79.251.162:80/auth/Register");
  var response = await http
      .put(url, body: <String, String>{"uid": "soko", "nickName": "kirqw"});
  print(response.body);
}

_loginTest() async {
  var url = Uri.http('52.79.251.162:80', '/auth/login', {"uid": "soko"});
  var response = await http.get(url);
  String _tmpCookie = response.headers['set-cookie'] ?? '';
  var idx = _tmpCookie.indexOf(';');
  _loginCookie = (idx == -1) ? _tmpCookie : _tmpCookie.substring(0, idx);
  if (response.statusCode == 200) {
    print(response.body);
    print(_loginCookie);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

_infoTest() async {
  print(_loginCookie);
  final url =
      Uri.http('52.79.251.162:80', '/auth/info', {'cookie': _loginCookie});

  var response = await http.get(url);
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () => {_registerTest(), print("등록 테스트")},
              child: Text("등록"),
            )),
        Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () => {_loginTest(), print("로그인 테스트")},
              child: Text("로그인"),
            )),
        Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () => {_infoTest(), print("정보 테스트")},
              child: Text("정보"),
            ))
      ],
    );
  }
}
