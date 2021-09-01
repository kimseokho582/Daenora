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
  _ClassDividState(this.id, this.pw, this.classProps, this.userProps);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var crawl = new Crawl();
        var assignment =
            await crawl.crawlAssignments(id, pw, classProps.classId);
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
              CustomCircularBar(vsync: this),
            ],
          ),
        ),
      ),
    );
  }
}
