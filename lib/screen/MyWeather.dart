import 'package:deanora/screen/MyMenu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyWeather extends StatefulWidget {
  const MyWeather({Key? key}) : super(key: key);

  @override
  _MyWertherState createState() => _MyWertherState();
}

class _MyWertherState extends State<MyWeather> {
  @override
  IconData weatherIcon = Icons.light_mode_outlined;
  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  Widget build(BuildContext context) {
    //print(weatherData);
    //print(cityNameData);
    print(precipitationPercentDate['minutely'][60]['precipitation']);
    final PageController pageController = PageController(
      initialPage: 0,
    );

    Widget weatherCard(weather, cityName, precipitationPercent) {
      switch ("${weather['weather'][0]['main']}") {
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

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: Align(
                  alignment: Alignment(0, 1),
                  child: Text(
                    (cityName == "우리 학교") ? "우리 학교" : cityName['locality'],
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 36),
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: Stack(children: [
                Align(
                  alignment: Alignment(-0.9, 0.9),
                  child: Text.rich(TextSpan(
                      text: '${DateFormat('EEEE').format(DateTime.now())}\n',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 21),
                      children: [
                        TextSpan(
                          text:
                              '${DateFormat('dd').format(DateTime.now())} ${_monthNames[int.parse(DateFormat('MM').format(DateTime.now())) - 1]}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        )
                      ])),
                ),
                Align(
                  alignment: Alignment(0.9, 0.9),
                  child: (cityName != "우리 학교")
                      ? RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.place,
                                size: 20,
                              ),
                            ),
                            TextSpan(
                                text: "현재 위치",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black))
                          ]),
                        )
                      : Container(),
                )
              ])),
          Divider(color: Colors.black, thickness: 2.0),
          Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment(0.9, -0.8),
                child: Icon(
                  weatherIcon,
                  size: 110,
                ),
              )),
          Expanded(
            flex: 7,
            child: Align(
              alignment: Alignment(-0.8, -0.7),
              child: Text.rich(TextSpan(
                  text: '${weather['main']['temp'].toStringAsFixed(0)}°\n',
                  style: TextStyle(fontSize: 180),
                  children: [
                    TextSpan(
                        text: '${weather['weather'][0]['main']}',
                        style: TextStyle(fontSize: 27))
                  ])),
            ),
          ),
          Divider(color: Colors.black, thickness: 2.0),
          Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(-0.9, -0.2),
                    child: Text.rich(TextSpan(
                        text:
                            "${weather['main']['feels_like'].toStringAsFixed(1)}°",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: ' feels\n',
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text:
                                "${weather['main']['temp_max'].toStringAsFixed(1)}°",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: ' max\n',
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text:
                                "${weather['main']['temp_min'].toStringAsFixed(1)}°",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: ' min\n',
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w300),
                          )
                        ])),
                  ),
                  Align(
                    alignment: Alignment(0.9, -0.2),
                    child: Text.rich(TextSpan(
                        text:
                            "${precipitationPercent['minutely'][60]['precipitation'].toStringAsFixed(0)}%",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: ' precipitation\n',
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: "${weather['main']['humidity']}%",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: ' humidity\n',
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text:
                                "${weather['wind']['speed'].toStringAsFixed(0)}m/s",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: ' wind\n',
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w300),
                          )
                        ])),
                  ),
                ],
              )),
        ]),
      );
    }

    print(DateFormat('H').format(DateTime.now()));
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: (6 <= int.parse(DateFormat('H').format(DateTime.now())) &&
                    int.parse(DateFormat('H').format(DateTime.now())) < 18)
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xfffedcae), Color(0xffff5d8c)])
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xff524b74), Color(0xffff7a40)]),
          ),
          child: PageView(controller: pageController, children: [
            weatherCard(weatherData, cityNameData, precipitationPercentDate),
            weatherCard(
                anYangWeatherData, "우리 학교", anYangPrecipitationPercentDate)
          ]),
        ),
      ),
    );
  }
}
