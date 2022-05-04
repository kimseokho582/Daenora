import 'package:custom_check_box/custom_check_box.dart';
import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/custom_menu_tabbar.dart';
import 'package:deanora/const/color.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/crawl/customException.dart';
import 'package:deanora/object/AmdinLogin.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
import 'package:deanora/screen/MyClass.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final id = TextEditingController();
  final pw = TextEditingController();
  late BehaviorSubject<int> test1;
  NyanUser userInfo = NyanUser('', '');
  List<Lecture> classesInfo = [];
  int willpop = 0;
  var ctrl = new LoginDataCtrl();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    test1 = BehaviorSubject.seeded(-1);
  }

  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        print('willpop $willpop');
        if (willpop == 1) {
          test1.sink.add(1);
          return false;
        } else {
          test1.sink.add(-1);
          return true;
        }
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(height: 139),
                            putimg(105.0, 105.0, "loginLogo"),
                            SizedBox(height: 60),
                            loginTextF(id, "학번", "loginIdIcon", false),
                            SizedBox(
                              height: 10,
                            ),
                            loginTextF(pw, "비밀번호", "loginPwIcon", true),
                            SizedBox(
                              height: 15,
                            ),
                            Container(height: 40, child: logindefault),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomCheckBox(
                              value: _isChecked,
                              shouldShowBorder: true,
                              borderColor: Color(0xff8E53E9),
                              checkedFillColor: Color(0xff8E53E9),
                              borderRadius: 5,
                              borderWidth: 2.3,
                              checkBoxSize: 13,
                              onChanged: (value) async {
                                if (value == true) {
                                } else {
                                  await ctrl.removeLoginData();
                                }
                                setState(() {
                                  _isChecked = value; //true가 들어감.
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_isChecked == true) {
                                    _isChecked = false;
                                  } else {
                                    _isChecked = true;
                                  }
                                });
                              },
                              child: Text(
                                "로그인 상태 유지",
                                style: TextStyle(color: Color(0xff707070)),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (_isChecked == true) {
                                print("저장할게요~");
                                await ctrl.saveLoginData(id.text, pw.text);
                              }
                              var crawl = new Crawl();
                              Crawl.id = id.text;
                              Crawl.pw = pw.text;

                              try {
                                try {
                                  userInfo = GetIt.I<NyanUser>(
                                      instanceName: "userInfo");
                                  classesInfo = GetIt.I<List<Lecture>>(
                                      instanceName: "classesInfo");
                                } catch (e) {
                                  await crawl.crawlUser();
                                  await crawl.crawlClasses();
                                  userInfo = GetIt.I<NyanUser>(
                                      instanceName: "userInfo");
                                  classesInfo = GetIt.I<List<Lecture>>(
                                      instanceName: "classesInfo");

                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        duration: Duration(milliseconds: 250),
                                        type: PageTransitionType.fade,
                                        child: MyClass(
                                          id.text,
                                          pw.text,
                                        ),
                                      ));
                                }

                                setState(() {
                                  logindefault = new Text("");
                                });
                              } on CustomException catch (e) {
                                print(e);
                                setState(() {
                                  if (logindefault != loginfault2 &&
                                      logindefault != loginfault &&
                                      logindefault != firstfault) {
                                    logindefault = firstfault;
                                  } else if (logindefault != loginfault) {
                                    logindefault = loginfault;
                                  } else if (logindefault != loginfault2) {
                                    logindefault = loginfault2;
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: <Color>[
                                        PRIMARY_COLOR_DEEP,
                                        PRIMARY_COLOR_LIGHT,
                                      ]),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Container(
                                width: 270,
                                height: 60,
                                alignment: Alignment.center,
                                child: Text(
                                  '로그인',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomMenuTabbar(
                    ttt: (int id) {
                      willpop = id;
                    },
                    test1: test1,
                    parentsContext: context,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
