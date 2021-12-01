import 'package:deanora/screen/MyMenu.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    print(weatherData);
    //print(cityNameData);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Color(0xfff1c40f),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              Flexible(
                  flex: 1,
                  child: Container(
                    child: Center(
                      child: Text(
                        cityNameData['locality'],
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 36),
                      ),
                    ),
                  )),
              Divider(color: Colors.black, thickness: 2.0),
              Flexible(
                flex: 3,
                child: Image.network(
                  'http://openweathermap.org/img/w/02d.png',
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
