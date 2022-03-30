import 'package:deanora/Widgets/Widgets.dart';
import 'package:flutter/material.dart';

class MyYumMainTest extends StatefulWidget {
  const MyYumMainTest({Key? key}) : super(key: key);

  @override
  _MyYumMainTestState createState() => _MyYumMainTestState();
}

class _MyYumMainTestState extends State<MyYumMainTest> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25),
        child: Column(children: [
          SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: SizedBox(
              height: 75,
              child: Text("위치? 검색"),
            ),
          ),
          Text(
            "이달의 Top5",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ]),
      ),
    ));
  }
}
