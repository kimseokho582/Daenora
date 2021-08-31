import 'package:deanora/Widgets.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';
import 'dart:ui';

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

class _CoverState extends State<Cover> {
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    //var windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Positioned(child: cover_Background()),
        Align(
          alignment: Alignment(0.0, -0.2),
          child: putimg(windowWidth * 0.3, windowWidth * 0.3, "coverLogo"),
        ),
        Align(
          alignment: Alignment(0.0, 0.2),
          child: putimg(
              windowWidth * 0.3, windowWidth * 0.3 * 0.416, "coverTitle"),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      print('pop');
      Navigator.pop(
        context,
      );
    });
    Timer(Duration(seconds: 1), () {
      print('hii');
      Navigator.push(
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
