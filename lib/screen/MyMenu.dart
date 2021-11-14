import 'package:deanora/Widgets/Tutorial.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/crawl/customException.dart';
import 'package:deanora/main.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:deanora/screen/MyClass.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';
import 'package:deanora/Widgets/LoginDataCtrl.dart';

class MyMenu extends StatefulWidget {
  const MyMenu({Key? key}) : super(key: key);

  @override
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  String saved_id = "", saved_pw = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            InkWell(
              onTap: () {
                logintest();
              },
              child: Container(
                child: Text("냥대"),
              ),
            ),
            InkWell(
              onTap: () {
                print("냠대");
              },
              child: Container(
                child: Text("냠대"),
              ),
            )
          ],
        )),
      ),
    );
  }

  logintest() async {
    var ctrl = new LoginDataCtrl();
    var assurance = await ctrl.loadLoginData();
    saved_id = assurance["user_id"] ?? "";
    saved_pw = assurance["user_pw"] ?? "";
    var crawl = new Crawl(saved_id, saved_pw);

    try {
      var classes = await crawl.crawlClasses();
      var user = await crawl.crawlUser();
      print("Saved_login");
      Navigator.push(
          context,
          PageTransition(
            duration: Duration(milliseconds: 250),
            type: PageTransitionType.fade,
            child: MyClass(saved_id, saved_pw, classes, user),
          ));
    } on CustomException catch (e) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 800),
          type: PageTransitionType.fade,
          alignment: Alignment.topCenter,
          child: isviewed != 0 ? Tutorial() : MyLogin(),
        ),
      );
    }
  }
}
