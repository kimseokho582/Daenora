import 'dart:ffi';

import 'package:deanora/custom_circlular_bar.dart';
import 'package:deanora/object/assignment.dart';
import 'package:deanora/screen/myClass.dart';
import 'package:flutter/material.dart';
import 'package:deanora/Widgets.dart';

class MyAssignment extends StatefulWidget {
  var classProps, userProps, assignmentProps;
  MyAssignment(this.classProps, this.userProps, this.assignmentProps);

  @override
  _MyAssignmentState createState() =>
      _MyAssignmentState(this.classProps, this.userProps, this.assignmentProps);
}

class _MyAssignmentState extends State<MyAssignment>
    with TickerProviderStateMixin {
  var classProps, userProps, assignmentProps;

  _MyAssignmentState(this.classProps, this.userProps, this.assignmentProps);

  @override
  void initState() {
    super.initState();
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

  Widget build(BuildContext context) {
    List<dynamic> myAssignment = assignments(assignmentProps);
    myAssignment.add(assignments(assignmentProps)[0]);
    myAssignment.add(assignments(assignmentProps)[0]);
    myAssignment.add(assignments(assignmentProps)[0]);
    myAssignment.add(assignments(assignmentProps)[0]);
    //print(myAssignment[0].title);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: <Color>[
                            Color(0xff6D6CEB),
                            Color(0xff7C4DF1)
                          ]),
                      borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(30.0),
                          bottomRight: const Radius.circular(30.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () => {
                                Navigator.pop(context),
                              },
                          child: Icon(Icons.arrow_back)),
                      Center(
                          child: Text("${classProps.className}",
                              style: TextStyle(color: Colors.white))),
                      Center(
                          child: Text("${classProps.profName}",
                              style: TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 24),
                    child: Text("과제 목록")),
                Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: myAssignment.length,
                    itemBuilder: (BuildContext context, int index) {
                      return assignmentDivided(context, myAssignment[index]);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget assignmentDivided(BuildContext context, myAssignment) {
  return Container(
    height: 100,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(border: Border.all(color: Colors.red)),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(myAssignment.title),
            SizedBox(
              height: 10,
            ),
            Text(
                "${myAssignment.startDate.replaceAll("-", ". ")} ~ ${myAssignment.endDate.replaceAll("-", ". ")}"),
          ],
        ),
      ],
    ),
  );
}
