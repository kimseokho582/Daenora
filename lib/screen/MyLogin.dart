import 'package:deanora/Widgets.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/crawl/customException.dart';
import 'package:deanora/screen/myClass.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final id = TextEditingController();
  final pw = TextEditingController();
  // dynamic id = "201663025";
  // dynamic pw ="Ghldnjs369!"
  //201663025
  //Ghldnjs369!

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                children: [
                  putimg(105.0, 105.0, "loginLogo"),
                  loginTextF(id, "학번", "loginIdIcon", false),
                  loginTextF(pw, "비밀번호", "loginPwIcon", true),
                  SizedBox(
                    height: 80.0,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());

                        var crawl = new Crawl();
                        try {
                          //var obj = await crawl.crawlClasses(id.text, pw.text);
                          var obj = await crawl.crawlClasses(
                              "201663025", "Ghldnjs369!");

                          Navigator.push(
                              context,
                              PageTransition(
                                duration: Duration(milliseconds: 150),
                                type: PageTransitionType.bottomToTop,
                                child: MyClass(obj),
                              ));
                        } on CustomException catch (e) {
                          print('${e.code} ${e.message}');
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
                ],
              ),
            ),
          ),
        ));
  }
}
