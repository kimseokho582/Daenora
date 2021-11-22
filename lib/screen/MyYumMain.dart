import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyYumMain extends StatefulWidget {

  @override
  _MyYumMainState createState() => _MyYumMainState();
}

class _MyYumMainState extends State<MyYumMain> {
  List top5List= [];
  @override
   void initState() {
     top5List.add(Image.asset('assets/images/tutorial1.jpg',fit: BoxFit.cover,));
     top5List.add(Image.asset('assets/images/tutorial2.jpg',fit: BoxFit.cover));
     top5List.add(Image.asset('assets/images/tutorial3.jpg',fit: BoxFit.cover));
     top5List.add(Image.asset('assets/images/tutorial4.jpg',fit: BoxFit.cover));
     top5List.add(Image.asset('assets/images/yumTitle.png',fit: BoxFit.cover));
   }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            //margin: EdgeInsets.only(left:25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                SizedBox(
                  height: 31,
                ),
                Text("이달의 Top 5"),
                CarouselSlider(options: CarouselOptions(height: 150,autoPlay:false,enableInfiniteScroll: false),
                items:top5List.map((e){
                  return Builder(
                    builder: (BuildContext context){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: e,
                        ),
                      );
                    },
                  );
                }).toList(),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}