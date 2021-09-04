import 'package:deanora/Widgets.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/custom_circlular_bar.dart';
import 'package:deanora/screen/myAssignment.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ClassDivid extends StatefulWidget {
  var id, pw, classProps, doneCnt, userProps;

  ClassDivid(this.id, this.pw, this.classProps, this.doneCnt, this.userProps);

  @override
  _ClassDividState createState() => _ClassDividState(
      this.id, this.pw, this.classProps, this.doneCnt, this.userProps);
}

class _ClassDividState extends State<ClassDivid> with TickerProviderStateMixin {
  var id, pw, classProps, doneCnt, userProps;
  var assignmentProps;
  double progressCnt = 0;
  List<dynamic> assignment = [];
  _ClassDividState(
      this.id, this.pw, this.classProps, this.doneCnt, this.userProps);

  @override
  void initState() {
    requestAssignment(id, pw, classProps.classId).whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  String nClassName = "";
  Widget build(BuildContext context) {
    if (classProps.className.length > 16) {
      nClassName = classProps.className.substring(0, 16) + "...";
    } else {
      nClassName = classProps.className;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: MyAssignment(classProps, assignmentProps, doneCnt)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: Colors.grey.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2.5,
              blurRadius: 1.5,
              offset: Offset(1, 3),
            )
          ],
        ),
        child: Container(
          margin:
              const EdgeInsets.only(top: 20, right: 30, left: 25, bottom: 18),
          child: Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      nClassName,
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(' ${classProps.profName} 교수님',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff707070)))
                  ]),
              Container(
                  alignment: Alignment.centerRight,
                  child: CustomCircularBar(vsync: this, upperBound: doneCnt)),
            ],
          ),
        ),
      ),
    );
  }

  requestAssignment(id, pw, cId) async {
    var crawl = new Crawl();
    assignmentProps = await crawl.crawlAssignments(id, pw, cId);
    if (!(assignmentProps == null)) {
      assignment = assignments(assignmentProps);
    }
  }
}
