import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class MyClass extends StatefulWidget {
  String id, pw;
  List classes;
  MyClass(this.id, this.pw, this.classes);
  @override
  _MyClassState createState() => _MyClassState(this.id, this.pw, this.classes);
}

class _MyClassState extends State<MyClass> {
  String id, pw;
  List classes;
  _MyClassState(this.id, this.pw, this.classes);

  @override

 Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        margin: const EdgeInsets.only(top:40,left:20),
        child: 
          Text('안녕하세요!, $id 님'),
      )
    );
  }
}


