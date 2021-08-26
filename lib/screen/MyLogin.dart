import 'package:deanora/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final id = TextEditingController();
  final pw = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            putimg(105.0, 105.0, "loginLogo"),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: SizedBox(
                  height: 30,
                  width: 250,
                  child: TextField(
                      controller: id,
                      decoration: InputDecoration(
                          hintText: '학번',
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.only(bottom: 8),
                            child: putimg(10.0, 10.0, "loginIdIcon"),
                          )))),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: SizedBox(
                  height: 30,
                  width: 250,
                  child: TextField(
                      controller: pw,
                      decoration: InputDecoration(
                          hintText: '비밀번호',
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.only(bottom: 8),
                            child: putimg(10.0, 10.0, "loginPwIcon"),
                          )))),
            )
          ],
        ),
      ),
    ));
  }
}
