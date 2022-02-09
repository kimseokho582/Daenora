import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/all.dart';

int? isviewed;

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoContext.clientId = '0ee1a69b5061efe60731a280662c04d7';
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  isviewed = prefs.getInt('Tutorial');
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
        home: Cover()
        //home: MyKakaoLogin()
        // home: Test()
        );
  }
}

class Cover extends StatefulWidget {
  const Cover({Key? key}) : super(key: key);
  @override
  _CoverState createState() => _CoverState();
}

class _CoverState extends State<Cover> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 50), () {
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
}
