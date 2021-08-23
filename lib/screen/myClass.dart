import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class myClass extends StatefulWidget {
  String id, pw;
  List classes;
  myClass(this.id, this.pw, this.classes);
  @override
  _myClassState createState() => _myClassState(this.id, this.pw, this.classes);
}

class _myClassState extends State<myClass> {
  String id, pw;
  List classes;
  _myClassState(this.id, this.pw, this.classes);

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


