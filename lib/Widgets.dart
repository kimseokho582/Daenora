import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/object/assignment.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
import 'package:deanora/screen/myAssignment.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

Container cover_Background() {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xff8C65EC), Color(0xff6D6CEB)])),
  );
}

// ignore: non_constant_identifier_names
Container putimg(w, h, name) {
  return Container(
      child: (Image.asset(
    'assets/images/$name.png',
    width: w,
    height: h,
  )));
}

Container loginTextF(_controller, hintext, icon, obscure) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: SizedBox(
        height: 30,
        width: 250,
        child: Stack(
          children: [
            TextField(
                onChanged: (text) {
                  print(text);
                },
                controller: _controller,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    // border: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.red),
                    // ),
                    hintText: hintext,
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.only(bottom: 8),
                      child: putimg(10.0, 10.0, icon),
                    ))),
            Positioned(
              bottom: 0,
              child: Container(
                height: 1,
                width: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Color(0xff8C65EC), Color(0xff6D6CEB)]),
                ),
              ),
            )
          ],
        )),
  );
}

BoxDecoration classContainerDeco() {
  return BoxDecoration(
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
  );
}

List classes(props) {
  List classes = [];
  props
      .map((x) =>
          {classes.add(Lecture(x["className"], x["profName"], x["classId"]))})
      .toList();
  //classes.map((e) => {Text(e.className)}).toList();
  //print(classes[0].classId);

  return classes;
}

List user(props) {
  List user = [];
  user.add(User(props["name"], props["studentId"]));
  //print(user[0].name);
  return user;
}

List assignments(props) {
  List assignment = [];
  props
      .map((x) => {
            assignment.add(Assignment(
                x["title"], x["state"], x["startDate"], x["endDate"]))
          })
      .toList();
  return assignment;
}

Widget classDivided(BuildContext context, id, pw, classProps, userProps) {
  print("클래스페이지 켜짐");

  return GestureDetector(
    onTap: () async {
      var crawl = new Crawl();
      var assignment = await crawl.crawlAssignments(id, pw, classProps.classId);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyAssignment(classProps, userProps, assignment)));
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: Colors.grey.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(1, 3),
          )
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(25),
        child: Row(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${classProps.className}'),
              SizedBox(
                height: 5,
              ),
              Text(' ${classProps.profName} 교수님')
            ]),
          ],
        ),
      ),
    ),
  );
}
