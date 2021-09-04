import 'dart:convert';
import 'package:deanora/Widgets.dart';
import 'package:deanora/classdivid.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
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
    var windowWidth = MediaQuery.of(context).size.width;
    return PreferredSize(
      preferredSize: Size.fromHeight(30),
      child: new AppBar(
        backgroundColor: Color(0xffFAFAFA),
        elevation: 0.0,
        title: bar,
        leading: new IconButton(
          onPressed: () {
            //print("뒤로가기 만들어야 하나?");
            Navigator.pop(context);
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

  Future<bool> _onWillPop() async {
    print("끌꺼임?");
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text("Do you want to exit the app?"),
            actions: <Widget>[
              FlatButton(
                child: Text("NO"),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text("yes"),
                onPressed: () => Navigator.pop(context, true),
              )
            ],
          ),
        )) ??
        false;
  }

  Future<bool> _test() async {
    // Navigator.of(context).pop(true);
    return false;
  }

  Widget build(BuildContext context) {
    var windowHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _test,
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                appBar: myAppbar(context),
                resizeToAvoidBottomInset: false,
                body: Container(
                  margin: const EdgeInsets.only(top: 3, left: 25, right: 25),
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
                          child: Text("내 강의실 List",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18))),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Container(
                          height: windowHeight - 190,
                          //height: 30,
                          child: FutureBuilder(
                            future: requestAssignment(id, pw, filteredNames),
                            builder: (context, AsyncSnapshot<List> snap) {
                              List? doneCntList = [];
                              doneCntList = snap.data;
                              if (snap.hasData) {
                                return ListView.builder(
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
                                );
                              } else if (snap.hasError) {
                                return Text("Error");
                              } else {
                                return Container(
                                    margin: const EdgeInsets.only(bottom: 460),
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          )),
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
            if (assignment[i].state != "진행중") {
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
