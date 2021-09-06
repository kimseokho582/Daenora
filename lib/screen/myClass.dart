import 'dart:convert';
import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/classdivid.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:deanora/screen/myAssignment.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyClass extends StatefulWidget {
  var id, pw, classProps, userProps;

  MyClass(this.id, this.pw, this.classProps, this.userProps);
  @override
  _MyClassState createState() =>
      _MyClassState(this.id, this.pw, this.classProps, this.userProps);
}

class _MyClassState extends State<MyClass> {
  var id, pw, classProps, userProps;
  List<dynamic> assignment = [];
  List names = [];
  List filteredNames = [];
  List fname = [];
  String _searchText = "";
  Icon searchIcon = new Icon(Icons.search);
  Widget bar = new Text("");
  late Future<double> progressCnt;
  _MyClassState(this.id, this.pw, this.classProps, this.userProps);
  @override
  void initState() {
    super.initState();
    this._getNames(classProps);
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
          icon: Icon(Icons.arrow_back),
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
                              print(_searchText);
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

  Widget build(BuildContext context) {
    var windowHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          child: Scaffold(
              appBar: myAppbar(context),
              resizeToAvoidBottomInset: false,
              body: Container(
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
                                text: "${user(userProps)[0].name}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 18),
                              ),
                              TextSpan(text: "님")
                            ])),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text("내 강의실 List",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18))),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: FutureBuilder(
                          future: requestAssignment(id, pw, filteredNames),
                          builder: (context, AsyncSnapshot<List> snap) {
                            List? doneCntList = [];
                            doneCntList = snap.data;
                            if (snap.hasData) {
                              return SizedBox(
                                height: windowHeight - 190,
                                child: ListView.builder(
                                  itemCount: filteredNames.length,
                                  itemBuilder: (context, index) {
                                    if (filteredNames != [] &&
                                        filteredNames.length ==
                                            doneCntList?.length) {
                                      return ClassDivid(
                                          id,
                                          pw,
                                          filteredNames[index] ?? "",
                                          doneCntList![index] ?? "",
                                          userProps);
                                    } else {
                                      return Text("");
                                    }
                                  },
                                ),
                              );
                            } else if (snap.hasError) {
                              return Text("Error");
                            } else {
                              return SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator());
                            }
                          },
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

  void _getNames(classProps) {
    for (int i = 0; i < classes(classProps).length; i++) {
      names.add(classes(classProps)[i]);
    }
    setState(() {
      filteredNames = names;
      fname = names;
    });
  }

  Future<List> requestAssignment(id, pw, props) async {
    var crawl = new Crawl();
    List doneCnt = [];
    if (props != null) {
      for (int i = 0; i < props.length; i++) {
        var assignmentProps =
            await crawl.crawlAssignments(id, pw, props[i].classId);
        if (assignmentProps.length > 0) {
          assignment = assignments(assignmentProps);
          double tmp = 0.0;
          for (int i = 0; i < assignment.length; i++) {
            if (assignment[i].state == "") {
              tmp++;
            }
          }
          doneCnt.add(tmp / assignment.length);
        } else {
          doneCnt.add(0.0);
        }
      }
      return doneCnt;
    }
    return [];
  }
}
