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
               InkWell(
                  onTap: () {
                   logintest();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: windowWidth - 60,
                        //height: (windowWidth-60)*0.66,
                        child: Image.asset('assets/images/nyanTitle.png'),
                      ),
                      Container(
                        width: windowWidth - 60,
                        height: 65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "냥대 - 내 강의실",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                                Text("각 과목의 과제 정보와 학사일정을 확인",
                                    style: TextStyle(fontSize: 13))
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 38,
                ),
                InkWell(
                  onTap: () {
                    print("냠");
                  },
                  child: Column(
                    children: [
                      Container(
                        width: windowWidth - 60,
                        //height: (windowWidth-60)*0.66,
                        child: Image.asset('assets/images/yumTitle.png'),
                      ),
                      Container(
                        width: windowWidth - 60,
                        height: 65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "냠대 - 맛집 정보",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                                Text("안양대생만의 숨은 꿀 맛집 정보를 공유",
                                    style: TextStyle(fontSize: 13))
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
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
