import 'package:deanora/Widgets/Yumhttp.dart';
import 'package:deanora/object/AmdinLogin.dart';
import 'package:deanora/screen/MyKakaoLogin.dart';
import 'package:deanora/screen/MyNyamNickname.dart';
import 'package:deanora/screen/MyYumMainTest.dart';
import 'package:deanora/screen/Test2.dart';
import 'package:http/http.dart' as http;
import 'package:deanora/Widgets/Tutorial.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/crawl/customException.dart';
import 'package:deanora/main.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:deanora/screen/MyClass.dart';
import 'package:deanora/screen/MyYumMain.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
// import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyMenu extends StatefulWidget {
  const MyMenu({Key? key}) : super(key: key);

  @override
  _MyMenuState createState() => _MyMenuState();
}

var weatherData;
var anYangWeatherData;
var cityNameData;
var precipitationPercentDate;
var anYangPrecipitationPercentDate;

class _MyMenuState extends State<MyMenu> {
  final _openweatherkey = 'e474b467f27b8f03abdeb64c8a8e027a';
  String saved_id = "", saved_pw = "";
  // Location location = new Location();
  // late PermissionStatus _permissionGranted;
  // late LocationData _locationData;
  late bool _serviceEnabled;
  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
              buttonPadding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              title: Center(
                  child: Text(
                event.notification!.title!,
                style: TextStyle(fontWeight: FontWeight.w900),
              )),
              content: Container(
                  child: Text(
                event.notification!.body!,
                textAlign: TextAlign.center,
              )),
              actions: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Color(0xffd2d2d5), width: 1.0))),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        child: Text(
                          "확인",
                          style: TextStyle(color: Color(0xff755FE7)),
                        ),
                      )),
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

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
            width: windowWidth - 60,
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

    return Provider<Crawl>(
      create: (_) => Crawl(),
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Container(
            color: Colors.black,
            width: windowWidth,
            height: windowHeight,
            child: Container(
              margin: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("냥냠대 컨탠츠",
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: windowHeight - 100,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 18,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await context.read<Crawl>().crawlUserTest();
                            print(Provider.of<Crawl>(context, listen: false)
                                .providerUser);
                          },
                          child: Text(""),
                        ),
                        contentsMenu(nyanLogintest, "nyanTitle", "냥대 - 내 강의실",
                            "각 과목의 과제 정보와 학사 일정을 확인"),
                        SizedBox(
                          height: 30,
                        ),
                        // contentsMenu(
                        //     () => {
                        //           Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (context) => MyYumMainTest()))
                        //         },
                        //     "yumTitle",
                        //     "냠대 - 맛집 정보",
                        //     "안양대생만의 숨은 꿀 맛집 정보를 공유"),
                        contentsMenu(yumLogintest, "yumTitle", "냠대 - 맛집 정보",
                            "안양대생만의 숨은 꿀 맛집 정보를 공유"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  nyanLogintest() async {
    var ctrl = new LoginDataCtrl();
    var assurance = await ctrl.loadLoginData();
    saved_id = assurance["user_id"] ?? "";
    saved_pw = assurance["user_pw"] ?? "";
    print('$saved_id $saved_pw');
    Crawl.id = saved_id;
    Crawl.pw = saved_pw;
    try {
      // var classes = await crawl.crawlClasses();
      await context.read<Crawl>().crawlClassesTest();

      print("Saved_login");
      Navigator.push(
          context,
          PageTransition(
            duration: Duration(milliseconds: 250),
            type: PageTransitionType.fade,
            child: MyClass(saved_id, saved_pw, [],
                context.read<Crawl>().crawlUserTest(), weatherData),
          ));
    } on CustomException catch (e) {
      print(e);
      Navigator.push(
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

  // _login2() async {
  //   await UserApi.instance.loginWithKakaoAccount();
  //   // print('카카오계정으로 로그인 성공');
  //   User _user = await UserApi.instance.me();
  //   String _email =
  //       _user.kakaoAccount!.profile?.toJson()['nickname'].toString() ?? "";
  //   var yumHttp = new Yumhttp(_email);
  //   var yumLogin = await yumHttp.yumLogin();
  //   if (yumLogin == 200) {
  //     //로그인 성공
  //     var yumInfo = await yumHttp.yumInfo();
  //     print(yumInfo);

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => MyYumMain(yumInfo[0]['nickName'])),
  //     );
  //   } else if (yumLogin == 400) {
  //     // 로그인 실패, 회원가입 으로
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => MyNyamNickName(_email)));
  //   } else {
  //     // 기타 에러
  //     print(yumLogin);
  //   }
  // }

  yumLogintest() async {
    if (await AuthApi.instance.hasToken()) {
      print("여기는 바로 가능");
      try {
        // await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        User _user = await UserApi.instance.me();
        String _email =
            _user.kakaoAccount!.profile?.toJson()['nickname'].toString() ?? "";
        var yumHttp = new YumUserhttp(_email);
        var yumLogin = await yumHttp.yumLogin();
        if (yumLogin == 200) {
          //로그인 성공
          var yumInfo = await yumHttp.yumInfo();
          print(yumInfo);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyYumMain(yumInfo[0]["nickName"], _email)),
          );
        } else if (yumLogin == 400) {
          // 로그인 실패, 회원가입 으로
          print("닉네임 설정 해야함 토큰은 있음");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MyNyamNickName(_email)));
        } else {
          // 기타 에러
          print(yumLogin);
        }
      } catch (e) {
        if (e is KakaoException && e.isInvalidTokenError()) {
          print('토큰 만료 $e');
        } else {
          print('토큰 정보 조회 실패 $e');
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Test2()));
      }
    } else {
      print("토큰 없음");
      Navigator.push(context, MaterialPageRoute(builder: (context) => Test2()));
    }
  }

  // mygetlocation() async {
  // _serviceEnabled = await location.serviceEnabled();
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await location.requestService();
  //   if (!_serviceEnabled) {
  //     return;
  //   }
  // }

  // _permissionGranted = await location.hasPermission();
  // if (_permissionGranted == PermissionStatus.denied) {
  //   _permissionGranted = await location.requestPermission();
  //   if (_permissionGranted != PermissionStatus.granted) {
  //     return;
  //   }
  // }

  // _locationData = await location.getLocation();

  // await getWeatherData(
  //     lat: _locationData.latitude.toString(),
  //     lon: _locationData.longitude.toString());

  // await getAnyangWeatherData();

  // await getCityNameDate(
  //     lat: _locationData.latitude.toString(),
  //     lon: _locationData.longitude.toString());
  // return 0;
//   }

//   Future<void> getWeatherData({
//     required String lat,
//     required String lon,
//   }) async {
//     var str =
//         'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_openweatherkey&units=metric';
//     var precipitation =
//         'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=current,alerts,daily,hourly&appid=$_openweatherkey';
//     var response = await http.get(Uri.parse(str));
//     var precipitationResponse = await http.get(Uri.parse(precipitation));

//     if (response.statusCode == 200) {
//       var data = response.body;
//       var dataJson = jsonDecode(data);
//       weatherData = dataJson; // string to json

//       //  print('data = $data');
//       //print('${dataJson['name']}');
//     } else {
//       print('response status code = ${response.statusCode}');
//     }

//     if (precipitationResponse.statusCode == 200) {
//       var data = precipitationResponse.body;
//       var dataJson = jsonDecode(data);
//       precipitationPercentDate = dataJson;
//     } else {
//       print('response status code = ${precipitationResponse.statusCode}');
//     }
//   }

//   Future<void> getAnyangWeatherData() async {
//     var str =
//         'http://api.openweathermap.org/data/2.5/weather?lat=37.39169375011486&lon=126.91964184065135&appid=$_openweatherkey&units=metric';
//     var precipitation =
//         'https://api.openweathermap.org/data/2.5/onecall?lat=37.39169375011486&lon=126.91964184065135&exclude=current,alerts,daily,hourly&appid=$_openweatherkey';
//     var response = await http.get(Uri.parse(str));
//     var precipitationResponse = await http.get(Uri.parse(precipitation));

//     if (response.statusCode == 200) {
//       var data = response.body;
//       var dataJson = jsonDecode(data);
//       anYangWeatherData = dataJson; // string to json

//       //  print('data = $data');
//       //print('${dataJson['name']}');
//     } else {
//       print('response status code = ${response.statusCode}');
//     }

//     if (precipitationResponse.statusCode == 200) {
//       var data = precipitationResponse.body;
//       var dataJson = jsonDecode(data);
//       anYangPrecipitationPercentDate = dataJson;
//     } else {
//       print('response status code = ${precipitationResponse.statusCode}');
//     }
//   }

//   Future<void> getCityNameDate({
//     required String lat,
//     required String lon,
//   }) async {
//     var url =
//         'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$lon&localityLanguage=ko';
//     var cityresponse = await http.get(Uri.parse(url));
//     var data = cityresponse.body;

//     var dataJson = jsonDecode(data);
//     cityNameData = dataJson;
//   }
}
