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
                child: Text("${weatherData['main']['temp']}"),
                // child: Icon(
                //   weatherIcon,
                //   size: 100,
                // )
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
