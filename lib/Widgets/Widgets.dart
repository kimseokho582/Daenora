import 'dart:async';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/crawl/customException.dart';
import 'package:deanora/object/assignment.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
import 'package:deanora/screen/MyAssignment.dart';
import 'package:flutter/material.dart';
import 'package:blinking_text/blinking_text.dart';

Container cover_Background() {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xff8C65EC), Color(0xff6D6CEB)])),
  );
}

/// [w] img width
/// [h] img height
/// [name] img just name not address
Container putimg(w, h, name) {
  return Container(
      child: (Image.asset(
    'assets/images/$name.png',
    width: w,
    height: h,
  )));
}

/// [_controller] id or pw controller
/// [hinttext] Input Text
/// [icon] Input Icon
/// [obscure] true or false //bool

Container loginTextF(_controller, hintext, icon, obscure) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: SizedBox(
        height: 30,
        width: 250,
        child: Stack(
          children: [
            TextFormField(
                // onChanged: (text) {
                //   print(text);
                // },
                controller: _controller,
                obscureText: obscure,
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

/// [props] crawl.crawlClasses(id.text, pw.text) //classPrpps
// List classes(props) {
//   List testclasses = [];
//   props
//       .map((x) => {
//             testclasses
//                 .add(Lecture(x["className"], x["profName"], x["classId"]))
//           })
//       .toList();
//   return testclasses;
// }

/// [props] crawl.crawlUser(id.text, pw.text) //userPrpps
// List user(props) {
//   List user = [];
//   user.add(User(props["name"], props["studentId"]));
//   //print(user[0].name);
//   return user;
// }

/// [props] await crawl.crawlAssignments(id, pw, cId); //assignmentProps
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

//for blinking login fault alert
Widget logindefault = new Text("");
Widget loginfault = Container(
    child: BlinkText(
  "????????? ????????? ???????????? ????????????",
  beginColor: Colors.red,
  endColor: Colors.white,
  times: 1,
  duration: Duration(milliseconds: 300),
  style:
      TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 12),
));
Widget loginfault2 = new BlinkText(
  "????????? ????????? ???????????? ????????????",
  beginColor: Colors.red,
  endColor: Colors.white,
  times: 1,
  duration: Duration(milliseconds: 300),
  style:
      TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 12),
);
Widget firstfault = Text(
  "????????? ????????? ???????????? ????????????",
  style:
      TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 12),
);

requestDnc(id, pw, props) async {
  var crawl = new Crawl();
  List<dynamic> _assignment = [];

  try {
    var _asp;
    try {
      _asp = await crawl.crawlAssignments(props.classId);
    } catch (e) {
      _asp = await crawl.crawlAssignments(props.classId);
    }
    if (_asp.length > 0) {
      _assignment = assignments(_asp);
      double tmp = 0.0;
      for (int i = 0; i < _assignment.length; i++) {
        if (_assignment[i].state == "????????????") {
          tmp++;
        }
      }

      return (tmp / _assignment.length);
    } else {
      return 0.0;
    }
  } catch (e) {
    return Future.error(e);
  }
}
