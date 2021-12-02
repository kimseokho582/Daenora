import 'package:deanora/screen/MyMenu.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  IconData weatherIcon = Icons.light_mode_outlined;
  Widget build(BuildContext context) {
    switch ("${weatherData['weather'][0]['main']}") {
      case 'Clear':
        weatherIcon = Icons.light_mode_outlined;
        break;
      case 'Clouds':
        weatherIcon = Icons.cloud_outlined;
        break;
      case 'Snow':
        weatherIcon = Icons.ac_unit;
        break;
      case 'Rain':
        weatherIcon = Icons.umbrella_outlined;
        break;
      case 'Drizzle':
        weatherIcon = Icons.umbrella_outlined;
        break;
      case 'Thunderstorm':
        weatherIcon = Icons.bolt_outlined;
        break;
      default:
        weatherIcon = Icons.waves;
    }
    print(weatherData);
    //print(cityNameData);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Color(0xfff1c40f),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Center(
                      child: Text(
                        cityNameData['locality'],
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 36),
                      ),
                    ),
                  )),
              Divider(color: Colors.black, thickness: 2.0),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    alignment: Alignment.topRight,
                    child: Icon(
                      weatherIcon,
                      size: 100,
                    ),
                  )),
              Expanded(
                  flex: 5,
                  child: Container(
                      child: Text('${weatherData['main']['temp']}°'))),
              Divider(color: Colors.black, thickness: 2.0),
              Expanded(
                flex: 2,
                child: Container(),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
