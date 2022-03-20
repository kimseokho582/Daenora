import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;

class LoginTest extends StatefulWidget {
  const LoginTest({Key? key}) : super(key: key);

  @override
  _LoginTestState createState() => _LoginTestState();
}

class _LoginTestState extends State<LoginTest> {
  var id;
  void initState() {
    super.initState();
    _registerTest();
  }

  _getUserId() async {
    User user = await UserApi.instance.me();
    setState(() {
      id = user.kakaoAccount!.profile?.toJson()['nickname'].toString();
      print(id);
    });
  }

  _registerTest() async {
    final url = Uri.parse("http://52.79.251.162:80/auth/Register");

    var response = await http.put(url,
        body: <String, String>{"uid": "123", "nickName": "ksh123123"});
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(id.toString()),
      ),
    );
  }
}
