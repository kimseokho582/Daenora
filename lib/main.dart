import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:deanora/screen/Test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

int? isviewed;

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: 'dd673bf6fd4e61a745ecae2bd14a2671');
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  isviewed = prefs.getInt('Tutorial');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => Crawl("2018H1109", "zky78nt@cf!")),
      ],
      child: MyApp(),
    ),
  );
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

    Timer(Duration(milliseconds: 500), () {
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
