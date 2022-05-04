import 'package:carousel_slider/carousel_slider.dart';
import 'package:deanora/Widgets/LoadingCustom.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/http/Yumhttp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

class MyYumMainTest extends StatefulWidget {
  const MyYumMainTest({Key? key}) : super(key: key);

  @override
  _MyYumMainTestState createState() => _MyYumMainTestState();
}

class _MyYumMainTestState extends State<MyYumMainTest> {
  var top5Idx = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final yumStorehttp = YumStorehttp();
    return MaterialApp(
        home: Scaffold(
      body: Container(
        // margin: const EdgeInsets.only(left: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: SizedBox(
              height: 75,
              child: Text("위치? 검색"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "이달의 Top5",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
              future: yumStorehttp.storeTop5(),
              builder: (futerContext, AsyncSnapshot<List<dynamic>> snap) {
                if (!snap.hasData) {
                  return LoadingCustom();
                }
                if (snap.hasData && snap.data!.isEmpty) {
                  return Center(child: Text("가게 정보가 없습니다."));
                }

                List top5List = snap.data as List;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      items: top5List.map((e) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(right: 15.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: e["path"] != null
                                      ? Image.network(
                                          e["path"],
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/defaultImg.png')),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                          height: 200,
                          autoPlay: false,
                          viewportFraction: 0.9,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              top5Idx = index;
                              print(top5Idx);
                            });
                          }),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        '${top5List[top5Idx]["storeId"]}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text('${top5List[top5Idx]["storeId"]} 의 한줄평',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Color(0xffd6d6d6)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 1.0),
                              child: Text(
                                "추천 메뉴 & 가격",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Color(0xffd6d6d6)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 1.0),
                              child: Text(
                                "평점 ${top5List[top5Idx]["score"]}",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Color(0xffd6d6d6)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 1.0),
                              child: RichText(
                                text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Color(0xffFFCB64),
                                        ),
                                      ),
                                      TextSpan(
                                        text: " ${top5List[top5Idx]["score"]}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              })
        ]),
      ),
    ));
  }
}
