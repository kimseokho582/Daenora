import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/crawl/customException.dart';
import 'package:deanora/screen/myClass.dart';
import 'package:deanora/screen/test.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final id = TextEditingController();
  final pw = TextEditingController();
  Widget loginfalse = new Text("");
  var ctrl = new LoginDataCtrl();
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
        //debugShowCheckedModeBanner: false,
        home: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 110),
                  putimg(105.0, 105.0, "loginLogo"),
                  SizedBox(height: 60),
                  loginTextF(id, "학번", "loginIdIcon", false),
                  SizedBox(
                    height: 10,
                  ),
                  loginTextF(pw, "비밀번호", "loginPwIcon", true),
                ],
              ),
            ),
            loginfalse,
            Checkbox(
              value: _isChecked,
              onChanged: (value) async {
                if (value == true) {
                  await ctrl.saveLoginData(id.text, pw.text);
                  var ass =await ctrl.loadLoginData();
                   print(ass["user_id"]);

                   print(await ctrl.loadLoginData());
                } else {
                  await ctrl.removeLoginData();
                  print(await ctrl.loadLoginData());
                  // print("거짓");
                }
                setState(() {
                  _isChecked = value!; //true가 들어감.
                });
              },
            ),
            // MaterialButton(
            //     onPressed: () async =>
            //         {print(await ctrl.saveLoginData(id.text, pw.text))},
            //     child: Text("save")),
            // MaterialButton(
            //     onPressed: () async => {print(await ctrl.loadLoginData())},
            //     child: Text("load")),
            SizedBox(
              height: 80.0,
            ),
            Center(
              child: Container(
                child: ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if(_isChecked==true){
                      print("저장할게요~");
                    }
                    var crawl = new Crawl();
                    try {
                      var classes = await crawl.crawlClasses(id.text, pw.text);
                      var user = await crawl.crawlUser(id.text, pw.text);
                      // var classes = await crawl.crawlClasses(
                      //     "201663025", "Ghldnjs369!");
                      // var user = await crawl.crawlUser(
                      //     "201663025", "Ghldnjs369!");
                      // var classes = await crawl.crawlClasses(
                      //     "201663035", "Wjdtls753!");
                      // var user = await crawl.crawlUser(
                      //     "201663035", "Wjdtls753!");
                      print(user["name"]);

                      Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 250),
                            type: PageTransitionType.fade,
                            child: MyClass(id.text, pw.text, classes, user),
                            // MyClass("201663025", "Ghldnjs369!",
                            //     classes, user),
                            // MyClass("201663035", "Wjdtls753!",
                            //     classes, user),
                            //child: Test(obj),
                          ));
                      setState(() {
                        loginfalse = new Text("");
                      });
                    } on CustomException catch (e) {
                      print('${e.code} ${e.message}');
                      setState(() {
                        loginfalse = Container(
                          margin: const EdgeInsets.only(left: 90, top: 5),
                          child: new Text(
                            "입력한 정보가 일치하지 않습니다",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w800),
                          ),
                        );
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
                              Color(0xff6D6CEB),
                              Color(0xff8C65EC),
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
      ),
    ));
  }

  savedate(id, pw, cId) async {}
}
