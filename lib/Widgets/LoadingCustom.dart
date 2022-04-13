import 'dart:async';

import 'package:flutter/material.dart';

class LoadingCustom extends StatefulWidget {
  const LoadingCustom({Key? key}) : super(key: key);

  @override
  State<LoadingCustom> createState() => _LoadingCustomState();
}

class _LoadingCustomState extends State<LoadingCustom> {
  Timer? timer;
  bool _visible1 = true;
  bool _visible2 = true;
  bool _visible3 = true;
  bool _visible4 = true;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          _visible1 = !_visible1;
        });
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          _visible2 = !_visible2;
        });
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _visible3 = !_visible3;
        });
      });

      setState(() {
        _visible4 = !_visible4;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: RotationTransition(
        turns: new AlwaysStoppedAnimation(90 / 360),
        child: Container(
          width: 200,
          height: 300,
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 30,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _visible1 ? 1.0 : 0.0,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(340 / 360),
                    child: Image.asset(
                      'assets/images/logoNoBackground.png',
                      width: 10,
                      height: 10,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 25,
                left: 35,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _visible2 ? 1.0 : 0.0,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(20 / 360),
                    child: Image.asset(
                      'assets/images/logoNoBackground.png',
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: _visible3 ? 1.0 : 0.0,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(340 / 360),
                    child: Image.asset(
                      'assets/images/logoNoBackground.png',
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 80,
                left: 30,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _visible4 ? 1.0 : 0.0,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(20 / 360),
                    child: Image.asset(
                      'assets/images/logoNoBackground.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
