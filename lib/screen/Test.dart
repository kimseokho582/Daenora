import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
            body: SingleChildScrollView(
                child: WebView(
      initialUrl: 'https://www.google.com/',
      javascriptMode: JavascriptMode.unrestricted,
    ))));
  }
}
