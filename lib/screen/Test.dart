import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  var text;
  Test(this.text);

  @override
  _TestState createState() => _TestState(this.text);
}

class _TestState extends State<Test> {
  var text;
  _TestState(this.text);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: SingleChildScrollView(child: Center(child: Text(text))),
        ),
      ),
    );
  }
}
 