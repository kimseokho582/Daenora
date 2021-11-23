import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyYumMain extends StatefulWidget {

  @override
  _MyYumMainState createState() => _MyYumMainState();
}

class _MyYumMainState extends State<MyYumMain> {
  List _top5List= [];
 int _top5Index=0;
  @override
   void initState() {
     _top5List.add(Image.asset('assets/images/tutorial2.jpg',fit: BoxFit.cover));
     _top5List.add(Image.asset('assets/images/tutorial1.jpg',fit: BoxFit.cover,));
     _top5List.add(Image.asset('assets/images/tutorial3.jpg',fit: BoxFit.cover));
     _top5List.add(Image.asset('assets/images/tutorial4.jpg',fit: BoxFit.cover));
     _top5List.add(Image.asset('assets/images/yumTitle.png',fit: BoxFit.cover));
   }
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold (
       body: SafeArea(
          child: Container(
            //margin: EdgeInsets.only(left:25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                SizedBox(
                  height: 31,
                ),
                Text("이달의 Top 5"),
                CarouselSlider(options: CarouselOptions(height: 200,autoPlay:false,enableInfiniteScroll: false,
                onPageChanged: (index,reason){
                  setState(() {
                    _top5Index=index;
                  });
                }),
                items:_top5List.map((e){
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
                ),
                Center(child: Text('${_top5Index+1} Name')),
                Center(child:Text("${_top5Index+1} Description")),
              ]
            ),
          ),
        ),
      ),
    );
  }
}