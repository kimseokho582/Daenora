import 'package:deanora/Widgets/MenuTabBar.dart';
import 'package:flutter/material.dart';

class Test2 extends StatefulWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ClipPath(
            child: Container(
              width: 300,
              height: 300,
              color: Colors.blue,
            ),
            clipper: CustomPath(0),
          ),
        ),
      ),
    );
  }
}

class CustomPath extends CustomClipper<Path> {
  final int index;
  CustomPath(this.index);
  var radius = 40.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    if (index == 0) {
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, radius);
      path.arcToPoint(Offset(size.width - radius, 0.0),
          clockwise: true, radius: Radius.circular(radius));
    }else if(index==1){
    path.moveTo(radius, 0.0);
    path.arcToPoint(Offset(0.0, radius),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
