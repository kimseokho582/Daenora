import 'dart:convert';
import 'package:deanora/Widgets.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
import 'package:deanora/screen/myAssignment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyClass extends StatefulWidget {
  var props;

  MyClass(this.props);
  @override
  _MyClassState createState() => _MyClassState(this.props);
}



class _MyClassState extends State<MyClass> {
  var props;
  Icon _searchIcon = new Icon(Icons.search);
  // Widget myapp = new Row(children: [Icon(Icons.arrow_back),
  //   Container(
  //     margin: const EdgeInsets.only(left: 280),
  //     child: IconButton(onPressed: (){

  //     }icon: _
  //       ,)
  //   )
  // ]
  
  // );
  _MyClassState(this.props);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.only(top: 40, left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_back),
                    Container(
                      margin: const EdgeInsets.only(left: 280),
                      child: IconButton(
                          onPressed: () {
                            print("누름");
                            setState(() {
                              this._searchIcon = new Icon(Icons.add);
                            });

                          }, icon: _searchIcon),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 20),
                  child: Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(text: "안녕하세요, "),
                    TextSpan(
                      text: "${user(props)[0].name}",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    TextSpan(text: "님")
                  ])),
                ),
                Container(child: Text("내 강의실")),
                Column(
                    children: classes(props)
                        .map((e) => new InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyAssignment(e)));
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Ink(
                                    width: 400,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(1, 3),
                                        )
                                      ],
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(25),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${e.className}'),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(' ${e.profName} 교수님')
                                          ]),
                                    )),
                              ),
                            ))
                        .toList()),
              ],
            )));
  }
}
