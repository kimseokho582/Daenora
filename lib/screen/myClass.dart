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
  List names = [];
  List filteredNames = [];
  List fname = [];
  String _searchText = "";
  Icon searchIcon = new Icon(Icons.search);
  Widget bar = new Text("");

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

                  bar = new Container(
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
    return GestureDetector(
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Colors.blueGrey,
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
                    Container(
                        child: Text("내 강의실 List",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18))),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        height: windowHeight - 170,
                        child: ListView.builder(
                          itemCount: filteredNames.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ClassDivid(
                                id, pw, filteredNames[index], userProps);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
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
}
