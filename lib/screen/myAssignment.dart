import 'package:deanora/custom_circlular_bar.dart';
import 'package:deanora/object/assignment.dart';
import 'package:deanora/screen/myClass.dart';
import 'package:flutter/material.dart';
import 'package:deanora/Widgets.dart';

class MyAssignment extends StatefulWidget {
  var classProps, assignmentProps, progress;
  MyAssignment(this.classProps, this.assignmentProps, this.progress);

  @override
  _MyAssignmentState createState() =>
      _MyAssignmentState(this.classProps, this.assignmentProps, this.progress);
}

class _MyAssignmentState extends State<MyAssignment>
    with TickerProviderStateMixin {
  var classProps, userProps, assignmentProps, progress;
  _MyAssignmentState(this.classProps, this.assignmentProps, this.progress);

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    List<dynamic> myAssignment = assignments(assignmentProps);
    int doneCnt = (progress * myAssignment.length).toInt();
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220,
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
                      Container(
                        margin: const EdgeInsets.only(left: 22, top: 10),
                        child: GestureDetector(
                            onTap: () => {
                                  Navigator.pop(context),
                                },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text("${classProps.className}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center),
                      )),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                          child: Text("${classProps.profName} 교수님",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18))),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          doneNmiss(Color(0xffB2C3FF), "done  ", doneCnt),
                          SizedBox(
                            width: 40,
                          ),
                          doneNmiss(Color(0xffF2A7C5), "missed  ",
                              myAssignment.length - doneCnt),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: Text(
                    "과제 목록",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height - 300,
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
  Color boxColor = Color(0xffF2A7C5);
  Color textColor = Color(0xff191919);
  if (myAssignment.state != "진행중") {
    boxColor = Color(0xffB2C3FF);
    textColor = Color(0xffD6D6D6);
  }

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Stack(
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width - 20,
          padding: const EdgeInsets.only(left: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(1, 3),
                )
              ],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(myAssignment.title,
                  style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height: 15,
              ),
              Text(
                  "${myAssignment.startDate.replaceAll("-", ". ")} ~ ${myAssignment.endDate.replaceAll("-", ". ")}",
                  style: TextStyle(fontSize: 14, color: textColor)),
            ],
          ),
        ),
        Positioned(
            child: Container(
          width: 20,
          height: 100,
          color: boxColor,
        ))
      ],
    ),
  );
}

Widget doneNmiss(color, name, cnt) {
  return Container(
      width: 100,
      height: 38,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
      child: Center(
          child: Text.rich(TextSpan(children: <TextSpan>[
        TextSpan(
            text: name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            )),
        TextSpan(
            text: "${cnt}",
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900))
      ]))));
}
