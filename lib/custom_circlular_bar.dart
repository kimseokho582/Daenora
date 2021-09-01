import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


/// *[vsync] Input 'this'
/// *[duration] Millisecond
/// *[upperBound] 0.0 ~ 1.0
/// 
// ignore: must_be_immutable
class CustomCircularBar extends StatefulWidget {
  final TickerProvider vsync;
  final double upperBound;
  final int duration;
  final double fontSize;
  final double size;
  const CustomCircularBar({ required this.vsync, this.upperBound = 1.0, this.duration = 300, this.size = 50, this.fontSize = 12});

  @override
  State<CustomCircularBar> createState() => 
    _CustomCircularBar(this.vsync, this.upperBound, this.duration, this.size, this.fontSize);
}

class _CustomCircularBar extends State<CustomCircularBar> {
  late AnimationController _controller;
  final ColorTween progressColor = ColorTween(begin: Colors.red, end: new Color.fromRGBO(124, 77, 241, 1));
  final double fontSize;
  final double size;
  
  _CustomCircularBar(TickerProvider vsync, double upperBound, int duration, this.size, this.fontSize) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
      upperBound: upperBound
    )..addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    print(this.fontSize);
    return Stack(
        children: [
          SizedBox(
            width: this.size,
            height: this.size,
            child: CircularProgressIndicator( 
              value: _controller.value,
              valueColor: _controller.drive(progressColor)
            ),
          ),
          SizedBox(
            width: this.size,
            height: this.size,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${(_controller.value * 100).floor()}%',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: this.fontSize),
              )
            ),
          ),
        ],
      );
  }

  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}