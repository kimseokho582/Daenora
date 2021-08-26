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
