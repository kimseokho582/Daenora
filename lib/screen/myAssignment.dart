import 'package:flutter/material.dart';

class MyAssignment extends StatefulWidget {
  var props;
  MyAssignment(this.props);

  @override
  _MyAssignmentState createState() => _MyAssignmentState(this.props);
}

class _MyAssignmentState extends State<MyAssignment> {
  var props;
  _MyAssignmentState(this.props);
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: <Color>[Color(0xff6D6CEB), Color(0xff7C4DF1)]),
                borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(30.0),
                    bottomRight: const Radius.circular(30.0))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                  onTap: () => {
                        Navigator.pop(context),
                      },
                  child: Icon(Icons.arrow_back)),
              Center(
                  child: Text("${props.className}",
                      style: TextStyle(color: Colors.white))),
              Center(
                  child: Text("${props.profName}",
                      style: TextStyle(color: Colors.white))),
            

            ]),
          ),
        ),
      ),
    );
  }
}


