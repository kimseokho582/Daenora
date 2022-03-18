import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:http/http.dart' as http;

class MyKakaoLogin extends StatefulWidget {
  const MyKakaoLogin({Key? key}) : super(key: key);

  @override
  _MyKakaoLoginState createState() => _MyKakaoLoginState();
}

class _MyKakaoLoginState extends State<MyKakaoLogin> {
  String kakaotoken = "";
  var id ;
  Future<void> _loginButtonPressed() async {
    kakaotoken = await AuthCodeClient.instance.request();
    print(kakaotoken + "토큰 왔다!!");

    _getUserId();
    // _registerTest();
  }

  _getUserId() async {
    User user = await UserApi.instance.me();
    setState(() {
      id = user.kakaoAccount!.profile?.toJson()['nickname'].toString();
    });
  }

  _registerTest() async {
    final url = Uri.parse("http://52.79.251.162:80/auth/Register");

    var response = await http.put(url,
        body: <String, String>{"uid": kakaotoken, "nickName": "ksh123123"});
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: _loginButtonPressed,
                child: Text(
                  '카카오 로그인',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Text(id.toString()),
          ],
        ),
      ),
    );
  }
}
