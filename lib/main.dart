import 'package:deanora/post.dart';
import 'package:deanora/screen/myClass.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'deanora',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          accentColor: Colors.white
        ),
       debugShowCheckedModeBanner: false, home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final id = TextEditingController();
  final pw = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 120.0),
            TextField(
              controller: id,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: pw,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    id.clear();
                    pw.clear();
                  },
                ),
                ElevatedButton(
                  child: Text('NEXT'),
                  onPressed: ()async {
                    var classes = await post.postClass(id.text, pw.text);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => myClass(id.text,pw.text,classes)));
                  },
               ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
