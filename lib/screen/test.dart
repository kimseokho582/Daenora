import 'package:flutter/material.dart';
import 'package:deanora/Widgets.dart';

class Test extends StatefulWidget {
  var props;
  Test(this.props);

  @override
  _TestState createState() => _TestState(this.props);
}

class _TestState extends State<Test> {
  var props;
  List names = [];
  List filteredNames = [];
  List fname= [];
  String _searchText = "";
  _TestState(this.props);
  @override
  void initState() {
    super.initState();
    this._getNames(props);
  }

  // Column my(){
  //   return Column(children: [

  //   ],)
  // }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Text("hi"),
              Center(
                child: TextField(
                  onChanged: (text) {
                    _searchText = text;
                    print(_searchText);
                    if (!(_searchText == "")) {
                      List tmp = [];
                      //if (filteredNames[6].contains("하")) print("아이 시발");
                      for (int i = 0; i < fname.length; i++) {
                        if (fname[i].contains(_searchText)) {
                          tmp.add(fname[i]);
                        }
                        //rint(tmp);
                      }
                      setState(() {
                        filteredNames = tmp;
                      });
                      print(filteredNames);
                    } else {
                      setState(() {
                        filteredNames = fname;
                      });
                    }
                  },
                ),
              ),
              Column(
                children: filteredNames.map((text) => new Text(text)).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getNames(props) {
    // print(classes(props)[0].className);
    // print(classes(props).length);
    for (int i = 0; i < classes(props).length; i++) {
      names.add(classes(props)[i].className);

    }

    setState(() {
      filteredNames = names;
      fname = names;
    });
    //print(filteredNames);
  }
}
