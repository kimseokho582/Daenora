import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

_requestTest() async {
  var url = Uri.http('52.79.251.162:80', '/auth/info');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    print('Number of books about http: $jsonResponse.');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: () => {_requestTest(), print("로그인테스트입니다")},
          child: Text("테스트"),
        ));
  }
}
