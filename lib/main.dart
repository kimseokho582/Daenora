import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/crawl/customException.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:deanora/screen/myClass.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';
import 'dart:ui';
import 'package:deanora/Widgets/LoginDataCtrl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'deanora',
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.black,
            accentColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: Cover());
  }
}

class Cover extends StatefulWidget {
  const Cover({Key? key}) : super(key: key);
  @override
  _CoverState createState() => _CoverState();
}

String saved_id = "", saved_pw = "";

class _CoverState extends State<Cover> {
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    //var windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Positioned(child: cover_Background()),
        Align(
          alignment: Alignment(0.0, -0.18),
          child: putimg(windowWidth * 0.3, windowWidth * 0.3, "coverLogo"),
        ),
        Align(
          alignment: Alignment(0.0, 0.16),
          child: putimg(
              windowWidth * 0.3, windowWidth * 0.3 * 0.416, "coverTitle"),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    logintest();
    if (saved_id != 'null' && saved_pw != 'null') {
    } else {
      Timer(Duration(seconds: 1), () {
        print('hii');
        Navigator.pushReplacement(
          context,
          PageTransition(
            duration: Duration(milliseconds: 800),
            type: PageTransitionType.fade,
            alignment: Alignment.topCenter,
            child: MyLogin(),
          ),
        );
      });
    }
  }

  logintest() async {
    var ctrl = new LoginDataCtrl();
    var assurance = await ctrl.loadLoginData();
    saved_id = assurance["user_id"] ?? "";
    saved_pw = assurance["user_pw"] ?? "";
    print(saved_pw);
    var crawl = new Crawl();

    try {
      var classes = await crawl.crawlClasses(saved_id, saved_pw);
      var user = await crawl.crawlUser(saved_id, saved_pw);
      Navigator.pushReplacement(
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
          child: MyLogin(),
        ),
      );
    }
  }
}
