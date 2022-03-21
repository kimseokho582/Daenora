import 'package:deanora/Widgets/Yumhttp.dart';
import 'package:deanora/screen/MyYumMain.dart';
import 'package:flutter/material.dart';

class MyNyamNickName extends StatefulWidget {
  var nickName;
  MyNyamNickName(this.nickName);

  @override
  _MyNyamNickNameState createState() => _MyNyamNickNameState(this.nickName);
}

class _MyNyamNickNameState extends State<MyNyamNickName>
    with SingleTickerProviderStateMixin {
  final _nickNameController = TextEditingController();
  late FocusNode myFocusNode;
  String _loginCookie = "";
  bool _visible = false;
  late AnimationController _animationController;
  var nickName;
  _MyNyamNickNameState(this.nickName);
  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    // _animationController.repeat(reverse: true, period: Duration(seconds: 1));
    myFocusNode = FocusNode();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70,
                ),
                Text(
                  "회원님을 어떻게 부를까요?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: TextField(
                    focusNode: myFocusNode,
                    controller: _nickNameController,
                    textAlign: TextAlign.center,
                    cursorColor: Color(0xff8E53E9),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 25),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffF3F3F5)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xffF3F3F5)),
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fillColor: Color(0xffF3F3F5),
                        filled: true,
                        hintText: "닉네임",
                        hintStyle:
                            TextStyle(color: Color(0xffd6d6d6), fontSize: 16)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "-설정하신 닉네임은 냠 페이지에 적용됩니다.",
                  style: TextStyle(color: Color(0xff707070), fontSize: 12),
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      var yumHttp = new Yumhttp(nickName);
                      try {
                        var yumRegister =
                            await yumHttp.yumRegister(_nickNameController.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyYumMain(_nickNameController.text)),
                        );
                      } catch (e) {}
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
                          height: 60,
                          width: 280,
                          alignment: Alignment.center,
                          child: Text(
                            "설정하기",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FadeTransition(
                  opacity: _animationController,
                  child: Center(
                      child: Text(
                    "사용중인 닉네임입니다",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
