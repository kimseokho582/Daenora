import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:deanora/Widgets/LoadingCustom.dart';
import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/MenuTabBar.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/custom_menu_tabbar.dart';
import 'package:deanora/object/AmdinLogin.dart';
import 'package:deanora/object/assignment.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:deanora/screen/MyWeather.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:page_transition/page_transition.dart';
import 'package:deanora/Widgets/custom_circlular_bar.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/screen/MyCalendar.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:deanora/screen/myAssignment.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

class CnDPair<T1, T2> {
  int index;
  double val;
  CnDPair(this.index, this.val);
}

class MyClass extends StatefulWidget {
  var id, pw;

  MyClass(this.id, this.pw);
  @override
  _MyClassState createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> with TickerProviderStateMixin {
  List names = [];
  List<dynamic> assignment = [];
  String _searchText = "";
  List filteredNames = [];
  List fname = [];
  Icon searchIcon = new Icon(Icons.search);
  double ddnc = 0.0;
  Widget bar = new Text("");
  List dncList = [];
  List myclasses = [];

  late Future<double> progressCnt;
  late AnimationController animationController;

  _MyClassState();
  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    animationController.repeat();
    myclasses = GetIt.I<List<Lecture>>(instanceName: "classesInfo");
    // _getNames(classProps);
  }

  dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    print(myclasses[0].test);
    dncList = List.generate(10, (i) => 0.0);
    var windowHeight = MediaQuery.of(context).size.height;
    var windowWidth = MediaQuery.of(context).size.width;
    int willpop = 1;
    Future<List> requestAssignment(props) async {
      var crawl = new Crawl();
      List<Assignment> assignments = [];
      List doneCnt = [];

      for (int i = 0; i < props.length; i++) {
        try {
          assignments = GetIt.I<List<Assignment>>(
            instanceName: props[i].classId,
          );
        } catch (e) {
          await crawl.crawlAssignments(props[i].classId);
          assignments =
              GetIt.I<List<Assignment>>(instanceName: props[i].classId);
        }
        if (assignments.length > 0) {
          double tmp = 0.0;
          for (int i = 0; i < assignments.length; i++) {
            if (assignments[i].state == "제출완료") {
              tmp++;
            }
          }
          doneCnt.add(tmp / assignments.length);
        } else {
          doneCnt.add(0.0);
        }
      }

      return doneCnt;
    }

    return MaterialApp(
      home: Scaffold(
          appBar: myAppbar(context),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(children: [
              Container(
                color: Colors.white,
                child: Container(
                  margin: const EdgeInsets.only(top: 3, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle,
                              color: Colors.blueGrey,
                              size: 35,
                            ),
                            Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(text: "  안녕하세요, "),
                              TextSpan(
                                text:
                                    "${GetIt.I<NyanUser>(instanceName: "userInfo").name}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                              TextSpan(text: "님")
                            ])),
                          ],
                        ),
                      ),
                      //날씨
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => MyWeather()));
                      //   },
                      //   child: Container(
                      //     height: 30,
                      //     child: Text(
                      //         "${weatherData['weather'][0]['main']} // 전래동화...???"),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Text((myclasses[0].test).toString()),
                      Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("내 강의실 List",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                              InkWell(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyCalendar()));
                                },
                                child: Ink(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.event_available,
                                        size: 20,
                                      ),
                                      Text("학사일정"),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      CustomRefreshIndicator(
                        builder: (BuildContext context, Widget child,
                            IndicatorController controller) {
                          return AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, _) {
                              return Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  Transform.translate(
                                    offset: Offset(0, 110.0 * controller.value),
                                    child: child,
                                  ),
                                  if (!controller.isIdle)
                                    Positioned(
                                      child: SizedBox(
                                        height: 130,
                                        width: 100,
                                        child: LoadingCustom(),
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                        onRefresh: _refresh,
                        // onRefresh: () =>
                        //     Future.delayed(const Duration(seconds: 3)),
                        child: FutureBuilder(
                            future: requestAssignment(myclasses),
                            builder: (futureContext, AsyncSnapshot snap) {
                              if (snap.hasData) {
                                dncList = snap.data;
                                return Center(
                                  child: SizedBox(
                                    height: windowHeight - 270,
                                    child: myclasses.length != 0
                                        ? ListView.builder(
                                            itemCount: myclasses.length,
                                            itemBuilder:
                                                (BuildContext classContext,
                                                    int index) {
                                              return ClassList(
                                                  context,
                                                  myclasses[index],
                                                  dncList[index]);
                                            })
                                        : ListView(children: [
                                            Center(child: Text("강의가 없습니다"))
                                          ]),
                                  ),
                                );
                              } else if (snap.hasError) {
                                return Container(
                                  height: windowHeight - 270,
                                  child: ListView(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(snap.error.toString()),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container(
                                    alignment: Alignment.center,
                                    child: LoadingCustom());
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
              // CustomMenuTabbar(
              //   willPop: (int boolean) {
              //     setState(() {
              //       willpop = boolean;
              //     });
              //   },
              // ),
            ]),
          )),
    );
  }

  Future<void> _refresh() async {
    await Crawl().crawlClasses();
    for (int i = 0; i < myclasses.length; i++) {
      await Crawl().crawlAssignments(myclasses[i].classId);
    }
    Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 250),
          type: PageTransitionType.fade,
          child: MyClass(widget.id, widget.pw),
        ));
  }

  PreferredSizeWidget myAppbar(BuildContext context) {
    var ctrl = new LoginDataCtrl();
    var windowWidth = MediaQuery.of(context).size.width;
    return PreferredSize(
      preferredSize: Size.fromHeight(40),
      child: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: bar,
        leading: new IconButton(
          onPressed: () {
            ctrl.removeLoginData();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyLogin()));
          },
          icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(
                Icons.logout,
                size: 22,
              )),
          color: Colors.grey,
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              setState(() {
                if (this.searchIcon.icon == Icons.search) {
                  searchIcon = new Icon(Icons.close);
                  bar = Container(
                      width: windowWidth - 70,
                      height: 30,
                      child: Stack(
                        children: [
                          TextField(
                            autofocus: true,
                            onChanged: (text) {
                              _searchText = text;
                              if (!(_searchText == "")) {
                                List tmp = [];

                                for (int i = 0; i < fname.length; i++) {
                                  if (fname[i]
                                          .className
                                          .contains(_searchText) ||
                                      fname[i].profName.contains(_searchText)) {
                                    tmp.add(fname[i]);
                                  }
                                }
                                setState(() {
                                  filteredNames = tmp;
                                });
                              } else {
                                setState(() {
                                  filteredNames = fname;
                                });
                              }
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 1,
                              width: 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: <Color>[
                                  Color(0xff8C65EC),
                                  Color(0xff6D6CEB)
                                ]),
                              ),
                            ),
                          )
                        ],
                      ));
                } else {
                  setState(() {
                    bar = new Text("");
                    searchIcon = new Icon(Icons.search);
                    filteredNames = fname;
                  });
                }
              });
            },
            icon: searchIcon,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  // _getNames(classProps) async {
  //   for (int i = 0; i < classes(classProps).length; i++) {
  //     names.add(classes(classProps)[i]);
  //   }
  //   setState(() {
  //     filteredNames = names;
  //     fname = names;
  //   });
  // }
}

class ClassList extends StatefulWidget {
  BuildContext pageContext;
  var props;
  var dnc;
  ClassList(this.pageContext, this.props, this.dnc);
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> with TickerProviderStateMixin {
  _ClassListState();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var crawl = new Crawl();
        var _adssi = await crawl.crawlAssignments(widget.props.classId);
        Navigator.push(
            widget.pageContext,
            MaterialPageRoute(
                builder: (context) => MyAssignment(widget.props, widget.dnc)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: Colors.grey.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(3, 5),
            )
          ],
        ),
        child: Container(
          margin:
              const EdgeInsets.only(top: 20, right: 30, left: 25, bottom: 18),
          child: Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(widget.pageContext).size.width - 205,
                      child: Text(
                        widget.props.className,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff707070),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(' ${widget.props.profName} 교수님',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff707070))),
                  ]),
              Container(
                  alignment: Alignment.centerRight,
                  child: CustomCircularBar(vsync: this, upperBound: widget.dnc))
            ],
          ),
        ),
      ),
    );
  }
}
