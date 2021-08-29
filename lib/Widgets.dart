import 'package:flutter/material.dart';
import 'dart:ui';

Container cover_Background() {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xff8C65EC), Color(0xff6D6CEB)])),
  );
}

// ignore: non_constant_identifier_names
Container putimg(w, h, name) {
  return Container(
      child: (Image.asset(
    'assets/images/$name.png',
    width: w,
    height: h,
  )));
}

Container loginTextF(_controller, hintext, icon, obscure) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: SizedBox(
        height: 30,
        width: 250,
        child: TextField(
            controller: _controller,
            obscureText: obscure,
            decoration: InputDecoration(
                hintText: hintext,
                prefixIcon: Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.only(bottom: 8),
                  child: putimg(10.0, 10.0, icon),
                )))),
  );
}

BoxDecoration classContainerDeco() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      )
    ],
  );
}
