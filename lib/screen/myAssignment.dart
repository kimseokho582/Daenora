import 'package:deanora/Widgets/MemoData.dart';
import 'package:deanora/Widgets/MenuTabBar.dart';
import 'package:deanora/Widgets/FCMsample.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:deanora/Widgets/Widgets.dart';

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

  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   super.dispose();
  // }
  String mymemo = "";
  String tmpmemo = "";
  Future<bool> _willPopCallback() async {
    if (checkbackbutton == false) {
      return Future.value(true);
    } else {
      MenuTabBar(mycontext: context);
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: MyAssignment(classProps, assignmentProps, progress),
              type: PageTransitionType.fade));
      return Future.value(false);
    }
  }

  var saveloadMemo = new MemoData();
  Widget buildBottomSheet(BuildContext context) {
    return FutureBuilder(
      future: loadmemo(),
      builder: (context, snap) {
        if (snap.hasData) {
          String tmpstring = snap.data!.toString();
          return SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "과목 메모",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                    Container(
                      margin: EdgeInsets.all(30),
                      height: 280,
                      child: TextFormField(
                        onChanged: (text) async {
                          await saveloadMemo.saveMemo(text, classProps.classId);
                        },
                        initialValue: tmpstring,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: "과목에 대한 메모를 자유롭게 남겨보세요!",
                          fillColor: Color(0xfff3f3f3),
                          filled: true,
                        ),
                      ),
                    ),
                  ])));
        } else {
          return Text("now loading....");
        }
      },
    );
  }

  loadmemo() async {
    var getmemo = await saveloadMemo.loadMemo(classProps.classId);
    //  mymemo = getmemo['memoText'] ?? "";
    return getmemo['memoText'] ?? "";
  }

  Widget build(BuildContext context) {
    List<dynamic> myAssignment = assignments(assignmentProps);
    int doneCnt = (progress * myAssignment.length).toInt();
    Widget _child = new Text("");
    setState(() {
      if (assignmentProps.length > 0) {
        _child = haveassignment(context, myAssignment, classProps);
      } else {
        _child = notassignment;
      }
    });
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 245,
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
                          children: [
                            Container(
                              height: 225,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 30,
                                        margin: const EdgeInsets.only(left: 20),
                                        child: GestureDetector(
                                            onTap: () => {
                                                  Navigator.pop(context),
                                                },
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                              size: 25,
                                            )),
                                      ),
                                      Container(
                                          height: 20,
                                          margin: EdgeInsets.only(right: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    30.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    30.0)),
                                                  ),
                                                  context: context,
                                                  builder: buildBottomSheet,
                                                  isScrollControlled: true);
                                            },
                                            child: Image.asset(
                                                'assets/images/memoIcon.png'),
                                          ))
                                    ],
                                  ),
                                  Center(
                                      child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 100),
                                    child: Text("${classProps.className}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center),
                                  )),
                                  Center(
                                      child: Text("${classProps.profName} 교수님",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18))),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      doneNmiss(
                                          Color(0xffB2C3FF), "done  ", doneCnt),
                                      SizedBox(
                                        width: 23,
                                      ),
                                      doneNmiss(Color(0xffF2A7C5), "missed  ",
                                          myAssignment.length - doneCnt),
                                    ],
                                  )
                                ],
                              ),
                            ),
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: MediaQuery.of(context).size.height - 405,
                        child: _child,
                      )
                    ],
                  ),
                ),
                MenuTabBar(mycontext: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget notassignment = new Center(
  child: Text("아직 과제가 없습니다"),
);

// Widget haveassignment(myAssignment) {
//   return ListView.builder(
//       itemCount: myAssignment.length,
//       itemBuilder: (BuildContext context, int index) {
//         return Builder(builder: (context) {
//           return assignmentDivided(context, myAssignment[index]);
//         });
//       });
// }

Widget haveassignment(context, List<dynamic> myAssignment, classProps) {
  return ListView(
      children: myAssignment.map((e) {
    return assignmentDivided(context, e, classProps);
  }).toList());
}

Widget assignmentDivided(context, myAssignment, classProps) {
  var dateformatter = new DateFormat('yyyy-MM-dd');
  Color boxColor = Color(0xffF2A7C5);
  Color textColor;
  if (myAssignment.state == "제출완료") {
    boxColor = Color(0xffB2C3FF);
  }
  String today = dateformatter.format(DateTime.now());
  if (today.compareTo(myAssignment.endDate) == 1) {
    textColor = Color(0xffD6D6D6);
    //지남
  } else {
    textColor = Color(0xff191919);
    //안지남
  }

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Stack(
      children: [
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width - 20,
          padding: const EdgeInsets.only(left: 30),
          decoration: BoxDecoration(
              border:
                  Border.all(width: 2, color: Colors.grey.withOpacity(0.02)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
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
          width: 15,
          height: 90,
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
