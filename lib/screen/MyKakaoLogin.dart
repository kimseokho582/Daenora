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
  Future<void> _loginButtonPressed() async {
    kakaotoken = await AuthCodeClient.instance.request();
    print(kakaotoken + "토큰 왔다!!");
    _postRequest();
  }

  _postRequest() async {
    final url = Uri.parse("http://121.162.15.236:80/register");
    await http
        .post(
          url,
          body: <String, String>{'uid': kakaotoken},
        )
        .then((value) => print(value.body + "여기가 통신"))
        .catchError((e) => print(e.toString() + "오류입니다"));
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
          ],
        ),
      ),
    );
  }
}
