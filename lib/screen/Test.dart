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
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl:
              'https://cyber.anyang.ac.kr/MReport.do?cmd=viewReportInfoPageList&boardInfoDTO.boardInfoGubun=report&courseDTO.courseId=$text',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
