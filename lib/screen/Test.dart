import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Test extends StatefulWidget {
  Test();

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("FCM-test"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("확인"))
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text("FCM TEST")),
    );
  }
}
