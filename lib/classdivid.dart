import 'package:deanora/Widgets.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/custom_circlular_bar.dart';
import 'package:deanora/screen/myAssignment.dart';
import 'package:flutter/material.dart';

class ClassDivid extends StatefulWidget {
  var id, pw, classProps, userProps;

  ClassDivid(this.id, this.pw, this.classProps, this.userProps);

  @override
  _ClassDividState createState() =>
      _ClassDividState(this.id, this.pw, this.classProps, this.userProps);
}

class _ClassDividState extends State<ClassDivid> with TickerProviderStateMixin {
  var id, pw, classProps, userProps;
  var assignmentProps;

  _ClassDividState(this.id, this.pw, this.classProps, this.userProps);

  @override
  void initState() {
    super.initState();
    requestAssignment(id, pw, classProps.classId).whenComplete(() {
      setState(() {});
    });
  }


  List assignment=[];
  String nClassName = "";
  double progress=0.1;
  int progressCnt=0;
  Widget build(BuildContext context) {
    if (classProps.className.length > 16) {
      nClassName = classProps.className.substring(0, 16) + "...";
    } else {
      nClassName = classProps.className;
    }
    if(!(assignmentProps==null)){
    assignment = assignments(assignmentProps);
    }
    for(int i=0;i<assignment.length;i++){
      if(assignment[i].state!="진행중"){ //진행중, 지남, 제출 인가..? 그거 구분하는게 있나..?
        progressCnt++;
      }
    }
    if(assignment.length==0 ||progressCnt==0){
      progress=0.01;
    }else{
    progress = progressCnt/assignment.length;
    }
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyAssignment(classProps, userProps, assignmentProps)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: Colors.grey.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(15),
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
                  child: CustomCircularBar(vsync: this,upperBound:progress )),
            ],
          ),
        ),
      ),
    );
  }

  requestAssignment(id, pw, cId) async {
    var crawl = new Crawl();
    assignmentProps = await crawl.crawlAssignments(id, pw, cId);
  }
}
