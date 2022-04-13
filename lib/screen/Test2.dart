import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/Yumhttp.dart';
import 'package:deanora/screen/LoginTest.dart';
import 'package:deanora/screen/MyNyamNickName.dart';
import 'package:deanora/screen/MyYumMain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  bool _isKakaoInstalled = true;
  void initState() {
    super.initState();
    _initKakaoTalkInstalled();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoInstalled = installed;
    });
  }

  // _first() async {
  //   if (await AuthApi.instance.hasToken()) {
  //     try {
  //       AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
  //       // print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => LoginTest()),
  //       );
  //     } catch (error) {
  //       if (error is KakaoException && error.isInvalidTokenError()) {
  //         // print('토큰 만료 $error');
  //       } else {
  //         // print('토큰 정보 조회 실패 $error');
  //       }

  //       try {
  //         _login();
  //       } catch (error) {}
  //     }
  //   } else {
  //     _login();
  //   }
  // }

  _login2() async {
    try {
      _isKakaoInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();
    } catch (e) {
      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (e is PlatformException && e.code == 'CANCELED') {
        return;
      }
    }
    // print('카카오계정으로 로그인 성공');

    try {
      print("여기지?");
      User _user = await UserApi.instance.me();
      String _email =
          _user.kakaoAccount!.profile?.toJson()['nickname'].toString() ??
              ""; //이메일로 바꿔야함
      var yumUserHttp = new YumUserhttp(_email);
      var yumLogin = await yumUserHttp.yumLogin();
      print(yumLogin);
      if (yumLogin == 200) {
        //로그인 성공
        var yumInfo = await yumUserHttp.yumInfo();
        print(yumInfo[0]["nickName"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyYumMain(yumInfo[0], _email)),
        );
      } else if (yumLogin == 400) {
        // 로그인 실패, 회원가입 으로
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MyNyamNickName(_email)));
      } else {
        // 기타 에러
        print(yumLogin);
      }
    } catch (e) {
      if (e is PlatformException && e.code == 'CANCELED') {
        return;
      }
    }
  }

  //nickname에서 email로 바꿔야함!
  // _login() async {
  //   if (await isKakaoTalkInstalled()) {
  //     try {
  //       _login2();
  //     } catch (error) {
  //       print('카카오톡으로 로그인 실패 $error');

  //       // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
  //       // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
  //       if (error is PlatformException && error.code == 'CANCELED') {
  //         return;
  //       }

  //       // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
  //       try {
  //         _login2();
  //       } catch (error) {
  //         // print('카카오계정으로 로그인 실패 $error');
  //       }
  //     }
  //   } else {
  //     try {
  //       _login2();
  //     } catch (error) {
  //       // print('카카오계정으로 로그인 실패 $error');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/kakaologinback.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SafeArea(
              child: Container(
                height: 30,
                margin: const EdgeInsets.only(left: 25, top: 10),
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: () => {
                          Navigator.pop(context),
                        },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    )),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: 90,
              ),
            ),
            putimg(127.0, 127.0, "coverLogo"),
            SizedBox(
              height: 19,
            ),
            putimg(127.0, 127.0, "kakaologintitle"),
            Flexible(
              child: SizedBox(
                height: 80,
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _login2,
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Ink(
                  decoration: BoxDecoration(
                      color: Color(0xff794cdd),
                      borderRadius: BorderRadius.circular(50)),
                  child: Container(
                    width: 270,
                    height: 60,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '카카오 로그인하기   ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'NanumSquare_acB',
                          ),
                        ),
                        Image.asset(
                          'assets/images/kakaologo.png',
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: 20,
              ),
            ),
            Text(
              "더욱 다양한 서비스 사용을 위해\n 냥 기능을 활성화해주세요 :)",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansKR_Regular",
                  fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
