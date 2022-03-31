import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/MenuTabBar.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/object/AmdinLogin.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:deanora/screen/MyWeather.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  var id, pw, classProps, userProps, weather;

  MyClass(this.id, this.pw, this.classProps, this.userProps, this.weather);
  @override
  _MyClassState createState() => _MyClassState(
      this.id, this.pw, this.classProps, this.userProps, this.weather);
}

class _MyClassState extends State<MyClass> with TickerProviderStateMixin {
  var id, pw, classProps, userProps, weather;
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

  _MyClassState(this.id, this.pw, this.classProps, this.userProps, weatherData);
  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    animationController.repeat();
    // _getNames(classProps);
  }

  dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    dncList = List.generate(10, (i) => 0.0);
    var windowHeight = MediaQuery.of(context).size.height;
    var windowWidth = MediaQuery.of(context).size.width;
    myclasses = context.watch<Crawl>().providerClass;

    Future<bool> _willPopCallback() async {
      if (checkbackbutton == false) {
        return Future.value(true);
      } else {
        MenuTabBar(mycontext: context);
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: MyClass(id, pw, classProps, userProps, weatherData),
                type: PageTransitionType.fade));
        return Future.value(false);
      }
    }

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: ChangeNotifierProvider<Crawl>(
        create: (_) => Crawl(),
        child: MaterialApp(
          theme: ThemeData(primaryColor: Colors.lightGreen),
          //debugShowCheckedModeBanner: false,
          home: GestureDetector(
            onTap: () => {
              FocusScope.of(context).unfocus(),
              setState(() {
                bar = new Text("");
                searchIcon = new Icon(Icons.search);
              })
            },
            child: Container(
              child: Scaffold(
                  appBar: myAppbar(context),
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: Stack(children: [
                      Container(
                        color: Colors.white,
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 3, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30,
                                margin:
                                    const EdgeInsets.only(left: 10, bottom: 20),
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
                                            "${context.watch<Crawl>().providerUser.name}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
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
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                  builder: (context) =>
                                                      MyCalendar()));
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
                              RefreshIndicator(
                                onRefresh: _refresh,
                                child: FutureBuilder(
                                    future: requestAssignment(
                                        id, pw, filteredNames),
                                    builder:
                                        (futureContext, AsyncSnapshot snap) {
                                      if (snap.hasData) {
                                        dncList = snap.data;
                                        return Center(
                                          child: SizedBox(
                                            height: windowHeight - 270,
                                            child: myclasses.length != 0
                                                ? ListView.builder(
                                                    itemCount: myclasses.length,
                                                    itemBuilder: (BuildContext
                                                            classContext,
                                                        int index) {
                                                      return ClassList(context,
                                                          myclasses[index]);
                                                    })
                                                : ListView(children: [
                                                    Center(
                                                        child: Text("강의가 없습니다"))
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
                                                child:
                                                    Text(snap.error.toString()),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      animationController.drive(
                                                          ColorTween(
                                                              begin: Color(
                                                                  0xff8E53E9),
                                                              end: Colors.red)),
                                                )));
                                      }
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                      MenuTabBar(mycontext: context)
                    ]),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 250),
          type: PageTransitionType.fade,
          child: MyClass(
              this.id, this.pw, this.classProps, this.userProps, this.weather),
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
  ClassList(this.pageContext, this.props);
  @override
  _ClassListState createState() =>
      _ClassListState(this.pageContext, this.props);
}

class _ClassListState extends State<ClassList> {
  BuildContext pageContext;
  var props;
  _ClassListState(this.pageContext, this.props);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getpercent(pageContext, props.classId),
        builder: (futureContext, snap) {
          if (snap.hasData) {
            return InkWell(
              onTap: () async {
                var crawl = new Crawl();
                var _adssi = await crawl.crawlAssignments(props.classId);
                Navigator.push(
                    pageContext,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyAssignment(props ?? "", _adssi, [])));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 2, color: Colors.grey.withOpacity(0.03)),
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
                  margin: const EdgeInsets.only(
                      top: 20, right: 30, left: 25, bottom: 18),
                  child: Stack(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(pageContext).size.width - 205,
                              child: Text(
                                props.className,
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
                            Text(' ${props.profName} 교수님',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff707070))),
                          ]),
                      // Container(
                      //     alignment:
                      //         Alignment
                      //             .centerRight,
                      //     child: CustomCircularBar(
                      //         vsync:
                      //             this,
                      //         upperBound:
                      //             dncList[index]))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Text("로딩중");
          }
        });
  }
}

Future<int> getpercent(context, classId) async {
  return 2;
}
