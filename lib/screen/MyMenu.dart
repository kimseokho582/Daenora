import 'dart:convert';
import 'package:deanora/screen/Test.dart';
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
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:deanora/Widgets/LoginDataCtrl.dart';

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
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  @override
  void initState() {
    super.initState();
    mygetlocation();
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

    return MaterialApp(
      home: Scaffold(
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
                      //contentsMenu(logintest, "nyanTitle", "냥대 - 내 강의실", "각 과목의 과제 정보와 학사일정을 확인"),
                      contentsMenu(
                          () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Test()))
                              },
                          "nyanTitle",
                          "냥대 - 내 강의실",
                          "각 과목의 과제 정보와 학사일정을 확인"),
                      SizedBox(
                        height: 30,
                      ),
                      contentsMenu(
                          () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyYumMain()))
                              },
                          "yumTitle",
                          "냠대 - 맛집 정보",
                          "안양대생만의 숨은 꿀 맛집 정보를 공유"),
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
            child: MyClass(saved_id, saved_pw, classes, user, weatherData),
          ));
    } on CustomException catch (e) {
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

  mygetlocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    getWeatherData(
        lat: _locationData.latitude.toString(),
        lon: _locationData.longitude.toString());
    getAnyangWeatherData();

    getCityNameDate(
        lat: _locationData.latitude.toString(),
        lon: _locationData.longitude.toString());
  }

  Future<void> getWeatherData({
    required String lat,
    required String lon,
  }) async {
    var str =
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_openweatherkey&units=metric';
    var precipitation =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=current,alerts,daily,hourly&appid=$_openweatherkey';
    var response = await http.get(Uri.parse(str));
    var precipitationResponse = await http.get(Uri.parse(precipitation));

    if (response.statusCode == 200) {
      var data = response.body;
      var dataJson = jsonDecode(data);
      weatherData = dataJson; // string to json

      //  print('data = $data');
      //print('${dataJson['name']}');
    } else {
      print('response status code = ${response.statusCode}');
    }

    if (precipitationResponse.statusCode == 200) {
      var data = precipitationResponse.body;
      var dataJson = jsonDecode(data);
      precipitationPercentDate = dataJson;
    } else {
      print('response status code = ${precipitationResponse.statusCode}');
    }
  }

  Future<void> getAnyangWeatherData() async {
    var str =
        'http://api.openweathermap.org/data/2.5/weather?lat=37.39169375011486&lon=126.91964184065135&appid=$_openweatherkey&units=metric';
    var precipitation =
        'https://api.openweathermap.org/data/2.5/onecall?lat=37.39169375011486&lon=126.91964184065135&exclude=current,alerts,daily,hourly&appid=$_openweatherkey';
    var response = await http.get(Uri.parse(str));
    var precipitationResponse = await http.get(Uri.parse(precipitation));

    if (response.statusCode == 200) {
      var data = response.body;
      var dataJson = jsonDecode(data);
      anYangWeatherData = dataJson; // string to json

      //  print('data = $data');
      //print('${dataJson['name']}');
    } else {
      print('response status code = ${response.statusCode}');
    }

    if (precipitationResponse.statusCode == 200) {
      var data = precipitationResponse.body;
      var dataJson = jsonDecode(data);
      anYangPrecipitationPercentDate = dataJson;
    } else {
      print('response status code = ${precipitationResponse.statusCode}');
    }
  }

  Future<void> getCityNameDate({
    required String lat,
    required String lon,
  }) async {
    var url =
        'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$lon&localityLanguage=ko';
    var cityresponse = await http.get(Uri.parse(url));
    var data = cityresponse.body;

    var dataJson = jsonDecode(data);
    cityNameData = dataJson;
  }
}
