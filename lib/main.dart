import 'package:deanora/screen/MyLogin.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';




void main() {
  runApp(MyApp());
}

Container cover_Background(){
  return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xff8C65EC),
            Color(0xff6D6CEB)
          ]
        )
      ),
      
    );
}

Container cover_img(w,h,name){
  return Container(
    child:(
      Image.asset('assets/images/${name}.png',width: w,height: h,)
    )
  );
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
      // debugShowCheckedModeBanner: false,
        home: Cover());
  }
}

class Cover extends StatefulWidget {
  const Cover({ Key? key }) : super(key: key);

  @override
  _CoverState createState() => _CoverState();
}

class _CoverState extends State<Cover> {
  @override
  Widget build(BuildContext context) {
    //myTimer(context);
    return Stack(
      children: <Widget>[
        Positioned(child: cover_Background()),
        Align(alignment: Alignment(0.0,-0.45),
              child:cover_img(181.0,151.7,"coverLogo")),
               Align(alignment: Alignment(0.0,0.11),
              child:cover_img(164.5,56.8,"coverTitle")),
        

      ],     
    );

  }
}

void myTimer(BuildContext context){
Timer timer= new Timer(new Duration(seconds: 2), () {
  print('object');
   Navigator.push(context,PageTransition(
     duration: Duration(milliseconds: 800),
     type: PageTransitionType.fade,
     alignment: Alignment.topCenter,
     child: MyLogin(),
     ),
 );
});
}

