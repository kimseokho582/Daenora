import 'package:carousel_slider/carousel_slider.dart';
import 'package:deanora/Widgets/Yumhttp.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class MyYumMain extends StatefulWidget {
  var _nickName;
  var _email;
  MyYumMain(this._nickName, this._email);
  @override
  _MyYumMainState createState() => _MyYumMainState(this._nickName, this._email);
}

class _MyYumMainState extends State<MyYumMain> {
  List _top5List = [];
  int _top5Index = 0;
  var _nickName;
  var _email;

  _MyYumMainState(this._nickName, this._email);
  @override
  void initState() {
    _top5List
        .add(Image.asset('assets/images/tutorial2.jpg', fit: BoxFit.cover));
    _top5List.add(Image.asset(
      'assets/images/tutorial1.jpg',
      fit: BoxFit.cover,
    ));
    _top5List
        .add(Image.asset('assets/images/tutorial3.jpg', fit: BoxFit.cover));
    _top5List
        .add(Image.asset('assets/images/tutorial4.jpg', fit: BoxFit.cover));
    _top5List.add(Image.asset('assets/images/yumTitle.png', fit: BoxFit.cover));
  }

  Widget build(BuildContext context) {
    // print(_nickName);

    // _nickName.substring(9, 9 + _nickName.substring(9).indexOf('"'));
    print('$_email asdasdsad');
    var yumHttp = new Yumhttp(_email);
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: yumHttp.yumLogin(),
            builder: (context, snap) {
              if (snap.hasData) {
                return Container(
                  //margin: EdgeInsets.only(left:25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 31,
                        ),
                        Row(
                          children: [
                            Text("안녕하세요 $_nickName님"),
                            ElevatedButton(
                              child: Text("로그아웃"),
                              onPressed: () async {
                                try {
                                  await UserApi.instance.logout();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyMenu()));
                                } catch (e) {
                                  print('로그아웃 실패 $e');
                                }
                              },
                            ),
                            ElevatedButton(
                              child: Text("얌 회탈"),
                              onPressed: () async {
                                try {
                                  var yumDelete = await yumHttp.yumDelete();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyMenu()));
                                } catch (e) {
                                  print('회탈 실패 $e');
                                }
                              },
                            ),
                            ElevatedButton(
                              child: Text("회원정보"),
                              onPressed: () async {
                                try {
                                  var yumInfo = await yumHttp.yumInfo();
                                  print(yumInfo);
                                } catch (e) {
                                  print('회원정보 실패 $e');
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 31,
                        ),
                        Text("이달의 Top 5"),
                        CarouselSlider(
                          options: CarouselOptions(
                              height: 200,
                              autoPlay: false,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _top5Index = index;
                                });
                              }),
                          items: _top5List.map((e) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: e,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Center(child: Text('${_top5Index + 1} Name')),
                        Center(child: Text("${_top5Index + 1} Description")),
                      ]),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
