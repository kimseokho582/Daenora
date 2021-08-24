import 'dart:convert';
import 'package:deanora/post.dart';
import 'package:deanora/screen/MyClass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
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
                        MaterialPageRoute(builder: (context) => MyClass(id.text,pw.text,classes)));
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
