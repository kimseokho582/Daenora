import 'dart:convert';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
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

  _MyClassState(this.props);

  @override
  Widget build(BuildContext context) {
    List classes = [];
    props['classes']
        .map((x) =>
            {classes.add(Lecture(x["className"], x["profName"], x["classId"]))})
        .toList();
    classes.map((e) => {Text(e.className)}).toList();
    //print(classes[0].classId);
    List user = [];
    user.add(User(props["user"]["name"], props["user"]["studentId"]));
    //print(user[0].name);

    return Scaffold(
        body: Container(
            margin: const EdgeInsets.only(top: 40, left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 20),
                  child: Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(text: "안녕하세요, "),
                    TextSpan(
                      text: "${user[0].name}",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    TextSpan(text: "님")
                  ])),
                ),
                Container(child: Text("내 강의실")),
                Column(
                    children: classes
                        .map((e) => InkWell(
                              onTap: () {
                                print('taped ${e.className}');
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
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
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
