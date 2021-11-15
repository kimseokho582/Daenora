import 'package:deanora/Widgets/MakeCalendar.dart';
import 'package:deanora/Widgets/MenuTabBar.dart';
import 'package:deanora/Widgets/Tutorial.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/crawl/customException.dart';
import 'package:deanora/screen/ApiTest.dart';
import 'package:deanora/screen/MyCalendar.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:deanora/screen/MyClass.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:deanora/screen/Test.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:kakao_flutter_sdk/all.dart';

int? isviewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('Tutorial');
  KakaoContext.clientId = "13ae9c058a3730139cb75ca886110d5a";
  KakaoContext.javascriptClientId = "7757b31611d5699d11f7d5ee10b4cd9c";
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '냥냠대',
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.black,
            accentColor: Colors.white),
        debugShowCheckedModeBanner: false,
        //home: Cover()
        //home: Test(),
        home: ApiTest());
  }
}

class Cover extends StatefulWidget {
  const Cover({Key? key}) : super(key: key);
  @override
  _CoverState createState() => _CoverState();
}

class _CoverState extends State<Cover> {
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    var windowHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Positioned(child: cover_Background()),
        Positioned(
          bottom: windowHeight / 2,
          left: windowWidth / 2 - windowWidth * 0.3 / 2,
          child: putimg(windowWidth * 0.3, windowWidth * 0.3, "coverLogo"),
        ),
        Positioned(
          bottom: windowHeight / 2 - windowWidth * 0.3 * 0.416 - 50,
          left: windowWidth / 2 - windowWidth * 0.3 / 2,
          child: putimg(
              windowWidth * 0.3, windowWidth * 0.3 * 0.416, "coverTitle"),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 800),
          type: PageTransitionType.fade,
          alignment: Alignment.topCenter,
          child: MyMenu(),
        ),
      );
    });
  }
}
