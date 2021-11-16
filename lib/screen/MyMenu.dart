import 'package:deanora/Widgets/Tutorial.dart';
import 'package:deanora/Widgets/Widgets.dart';
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
    var windowHeight = MediaQuery.of(context).size.height;
    var windowWidth = MediaQuery.of(context).size.width;

    Widget contentsMenu(_ontapcontroller, image, title, descrition) {
      return InkWell(
        onTap: () {
          _ontapcontroller();
        },
        child: Center(
          child: Container(
            //height: (windowHeight - 270) / 2,
            width: 260,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      child: Image.asset('assets/images/$image.png'),
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                title,
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              Text(descrition, style: TextStyle(fontSize: 13))
                            ]),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Container(
          color: Colors.black,
          width: windowWidth,
          height: windowHeight,
          child: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text("냥냠대 컨탠츠",
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                SizedBox(
                  height: 18,
                ),
                contentsMenu(logintest, "nyanTitle", "냥대 - 내 강의실",
                    "각 과목의 과제 정보와 학사일정을 확인"),
                SizedBox(
                  height: 38,
                ),
                contentsMenu(() => {print("냠")}, "yumTitle", "냠대 - 맛집 정보",
                    "안양대생만의 숨은 꿀 맛집 정보를 공유"),
              ],
            ),
          ),
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
