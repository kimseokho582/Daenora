import 'package:deanora/screen/MyCalendar.dart';
import 'package:deanora/screen/myClass.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

bool checkbackbutton = false;
Widget tt = new Container();


class MenuTabBar extends StatefulWidget {
  BuildContext mycontext;
  final Color colorMenuIconDefault;
  final Color colorMenuIconActivated;
  final Color backgroundMenuIconDefault;
  final Color backgroundMenuIconActivated;
  final Color background;

  MenuTabBar(
      {required this.mycontext,
      this.background = Colors.blue,
      this.colorMenuIconActivated = Colors.blue,
      this.colorMenuIconDefault = Colors.white,
      this.backgroundMenuIconActivated = Colors.white,
      this.backgroundMenuIconDefault = Colors.blue});
      

  _MenuTabBar createState() => _MenuTabBar(this.mycontext);
}

class _MenuTabBar extends State<MenuTabBar> with TickerProviderStateMixin {
BuildContext mycontext;

_MenuTabBar(this.mycontext);
  //-1 button is quiet
  //0 button is moving
  //1 button is activated
  late BehaviorSubject<int> _isActivated;
  late BehaviorSubject<double> _positionButton;
  late PublishSubject<double> _opacity;
  late AnimationController _animationControllerUp;
  late AnimationController _animationControllerDown;
  late AnimationController _animationControllerRotate;
  late Animation<double> _animationUp;
  late Animation<double> _animationDown;
  late Animation<double> _animationRotate;
  late final void Function() _listenerDown;
  late final void Function() _listenerUp;

  List<RadioCustom> radioModel = [];

  @override
  initState() {
    super.initState();
    radioModel.add(new RadioCustom(true, "tabbarClass", "내 강의실", 0));
    radioModel.add(new RadioCustom(false, "tabbarFood", "맛집 찾기", 1));
    _isActivated = new BehaviorSubject.seeded(-1);
    _opacity = new PublishSubject<double>();
    _positionButton = new BehaviorSubject.seeded(10);

    _animationControllerUp = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _animationControllerDown = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _animationControllerRotate = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));

    _animationRotate = new Tween<double>(begin: 0, end: 2.3).animate(
        new CurvedAnimation(
            parent: _animationControllerRotate, curve: Curves.ease));

    _listenerUp = () {
      _opacity.sink.add(1.0);
      _positionButton.sink.add(_animationUp.value);
    };
    _animationControllerUp.addListener(_listenerUp);

    _listenerDown = () {
      _positionButton.sink.add(_animationDown.value);
    };
    _animationControllerDown.addListener(_listenerDown);
  }

  void _calculateOpacity(double dy) {
    var opacity = (MediaQuery.of(context).size.height - dy) /
        (MediaQuery.of(context).size.height * 0.3 - 60);
    if (opacity >= 0 && opacity <= 1) _opacity.sink.add(opacity);
  }

  void _updateButtonPosition(double dy) {
    var position = (MediaQuery.of(context).size.height - dy);

    if (position > 0) _positionButton.sink.add(position);

    _animationUp = new Tween<double>(
            begin: position, end: MediaQuery.of(context).size.height * 0.7)
        .animate(new CurvedAnimation(
            parent: _animationControllerUp, curve: Curves.ease));
    _animationDown = new Tween<double>(begin: position, end: 10).animate(
        new CurvedAnimation(
            parent: _animationControllerDown, curve: Curves.ease));
  }

  void _moveButtonDown() {
    _animationControllerDown.forward().whenComplete(() {
      _animationControllerDown.removeListener(_listenerDown);
      _animationControllerDown.reset();
      _animationDown.addListener(_listenerDown);
    });

    _animationControllerRotate.reverse();
    _isActivated.sink.add(-1);
  }

  void _moveButtonUp() {
    _animationControllerUp.forward().whenComplete(() {
      _animationControllerUp.removeListener(_listenerUp);
      _animationControllerUp.reset();
      _animationUp.addListener(_listenerUp);
    });

    _animationControllerRotate.forward();
    _isActivated.sink.add(1);
  }

  void _movementCancel(double dy) {
    if ((MediaQuery.of(context).size.height - dy) <
        MediaQuery.of(context).size.height * 0.3) {
      _moveButtonDown();
    } else {
      _moveButtonUp();
    }
  }

  void _finishedMovement(double dy) {
    if ((MediaQuery.of(context).size.height - dy).round() ==
        (MediaQuery.of(context).size.height * 0.3).round())
      _isActivated.sink.add(1);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> classList = [
      GestureDetector(
        onTap: () {
          Navigator.push(
              mycontext, MaterialPageRoute(builder: (mycontext) => MyCalendar()));
        },
        child: new Container(
            child: new Text("Calendar",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            margin: EdgeInsets.all(10)),
      ),
      GestureDetector(
        onTap: (){
          _moveButtonDown();
        },
        child: new Container(
            child: new Text("Note",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            margin: EdgeInsets.all(10)),
      ),
      new Container(
          child: new Text("기타",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          margin: EdgeInsets.all(10)),
      new Container(
          child: new Text("등등...",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          margin: EdgeInsets.all(10))
    ];
    List<Widget> foodList = [
      new Container(
          child: new Text("음식",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          margin: EdgeInsets.all(10)),
      new Container(
          child: new Text("맛집",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          margin: EdgeInsets.all(10)),
      new Container(
          child: new Text("기타",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          margin: EdgeInsets.all(10)),
      new Container(
          child: new Text("등등...",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          margin: EdgeInsets.all(10))
    ];

    return Stack(children: <Widget>[
      new Stack(children: <Widget>[
        new Align(
          //아이콘 들어가는곳
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 80,
            //color: Colors.green,
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                //children: _buildMenuIcons()
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          radioModel[0].isSelected = true;
                          radioModel[1].isSelected = false;
                        });
                      },
                      child: RadioItem(radioModel[0]),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          radioModel[0].isSelected = false;
                          radioModel[1].isSelected = true;
                        });
                      },
                      child: RadioItem(radioModel[1]),
                    ),
                  ),
                ]),
          ),
        ),
        new StreamBuilder(
            stream: _isActivated.stream,
            builder: (context, AsyncSnapshot<int> snapshot) {
              if (snapshot.data == -1) {
                print("닫힘");
                checkbackbutton = false;
                tt = Container(height: 0, width: 0);
              } else {
                checkbackbutton = true;
                print("보라돌이");
                tt = StreamBuilder(
                    initialData: 0.0,
                    stream: _opacity.stream,
                    builder: (context, AsyncSnapshot<double> snapshot) {
                      return new Opacity(
                          opacity: snapshot.data ?? 0,
                          child: new StreamBuilder(
                              initialData: 0.0,
                              stream: _positionButton.stream,
                              builder:
                                  (context, AsyncSnapshot<double> snapshot) {
                                var positon = snapshot.data! >=
                                        MediaQuery.of(context).size.height * 0.3
                                    ? (MediaQuery.of(context).size.height *
                                            0.3) -
                                        (snapshot.data! -
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3))
                                    : snapshot.data;
                                return new ClipPath(
                                    clipper: ContainerClipper(positon!),
                                    child: new Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      //color:background
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: <Color>[
                                              Color(0xff6D6CEB),
                                              Color(0xff7C4DF1)
                                            ]),
                                      ),
                                    ));
                              }));
                    });
              }
              return tt;
            }),
        Container(
          margin: EdgeInsets.only(bottom: 40), // 플러스 버튼 위치
          child: new Align(
              alignment: Alignment.bottomCenter,
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Listener(
                        onPointerDown: (c) {
                          _isActivated.sink.add(0);
                        },
                        onPointerUp: (event) {
                          _movementCancel(event.position.dy);
                        },
                        onPointerMove: (event) async {
                          _updateButtonPosition(event.position.dy);
                          _calculateOpacity(event.position.dy);
                          _finishedMovement(event.position.dy);
                        },
                        child: new StreamBuilder(
                            stream: _positionButton.stream,
                            initialData: 10.0,
                            builder: (context, AsyncSnapshot snapshot) {
                              return new Padding(
                                  padding:
                                      EdgeInsets.only(bottom: snapshot.data),
                                  child: new StreamBuilder(
                                      stream: _isActivated.stream,
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        print(_isActivated.stream.value);
                                        return new FloatingActionButton(
                                            elevation: 0,
                                            onPressed: () {
                                              _updateButtonPosition(0);
                                              if (_isActivated.stream.value ==
                                                  1) {
                                                _moveButtonDown();
                                              } else {
                                                _moveButtonUp();
                                              }
                                            },
                                            child: new Transform.rotate(
                                                angle: _animationRotate.value,
                                                child: new Icon(Icons.add,
                                                    color: snapshot.data == -1
                                                        ? widget
                                                            .colorMenuIconDefault
                                                        //: widget.colorMenuIconActivated)),
                                                        : Color(0xff6D6CEB))),
                                            backgroundColor: snapshot.data == -1
                                                // ? widget.backgroundMenuIconDefault
                                                ? Color(0xff6D6CEB)
                                                : widget
                                                    .backgroundMenuIconActivated);
                                      }));
                            }))
                  ])),
        ),
        new Align(
          alignment: Alignment.topCenter,
          child: new StreamBuilder(
              stream: _isActivated.stream,
              builder: (context, AsyncSnapshot<int> snapshot) {
                return snapshot.data == 1
                    ? Column(
                      children: [SizedBox(height:MediaQuery.of(context).size.height * 0.25),
                        new Column(
                            children: (radioModel[0].isSelected == true)
                                ? classList
                                : foodList),
                      ],
                    )
                    : new Container(width: 0, height: 0);
              }),
        )
      ])
    ]);
  }

  @override
  void dispose() {
    _isActivated.close();
    _positionButton.close();
    _opacity.close();
    super.dispose();
  }
}

class MenuTabBarItem extends StatelessWidget {
  final Text label;
  final void Function() onTap;

  MenuTabBarItem({required this.label, required this.onTap})
      : assert(label != null);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(child: this.label, onTap: this.onTap);
  }
}

class ContainerClipper extends CustomClipper<Path> {
  final double dy;
  ContainerClipper(this.dy);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(0.0, size.height);
    if (dy > -20)
      path.quadraticBezierTo((size.width / 2) - 28, size.height - 20,
          size.width / 2, size.height - dy - 56);
    path.lineTo(size.width / 2, size.height - (dy == 0 ? 0 : (dy + 56)));
    if (dy > -20)
      path.quadraticBezierTo(
          (size.width / 2) + 28, size.height - 20, size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0.0, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

enum Contents { CLASS, FOOD }

class RadioItem extends StatelessWidget {
  final RadioCustom _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: CustomPath(_item.idx),
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            color: Color(0xfff4f4f4),
            child: Opacity(
                opacity: (_item.isSelected) ? 1 : 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/${_item.icon}.png',
                      width: 20,
                      height: 25,
                    ),
                    Text(_item.title),
                  ],
                ))),
      ),
    );
  }
}

class RadioCustom {
  bool isSelected;
  final String icon;
  final String title;
  final int idx;

  RadioCustom(this.isSelected, this.icon, this.title, this.idx);
}

// ignore: must_be_immutable
class CustomPath extends CustomClipper<Path> {
  final int index;
  CustomPath(this.index);
  var radius = 40.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    if (index == 0) {
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, radius);
      path.arcToPoint(Offset(size.width - radius, 0.0),
          clockwise: true, radius: Radius.circular(radius));
    } else if (index == 1) {
      path.moveTo(radius, 0.0);
      path.arcToPoint(Offset(0.0, radius),
          clockwise: true, radius: Radius.circular(radius));
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
