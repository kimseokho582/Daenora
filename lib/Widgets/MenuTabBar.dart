import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MenuTabBar extends StatefulWidget {
  final Widget classChild;
  final Widget foodChild;
  final Color colorMenuIconDefault;
  final Color colorMenuIconActivated;
  final Color backgroundMenuIconDefault;
  final Color backgroundMenuIconActivated;
  final Color background;
  final List<IconButton> iconButtons;

  MenuTabBar(
      {required this.classChild,
      required this.foodChild,
      this.background = Colors.blue,
      required this.iconButtons,
      this.colorMenuIconActivated = Colors.blue,
      this.colorMenuIconDefault = Colors.white,
      this.backgroundMenuIconActivated = Colors.white,
      this.backgroundMenuIconDefault = Colors.blue})
      : assert(iconButtons != null &&
            iconButtons.length > 1 &&
            iconButtons.length % 2 == 0 &&
            classChild != null &&
            foodChild != null);

  _MenuTabBar createState() => _MenuTabBar();
}

class _MenuTabBar extends State<MenuTabBar> with TickerProviderStateMixin {
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
  Contents _content = Contents.CLASS;
  bool backbutton = false;
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

  List<Widget> _buildMenuIcons() {
    List<Widget> icons = [];

    for (var i = 0; i < widget.iconButtons.length; i++) {
      if (i == widget.iconButtons.length / 2) {
        icons.add(new Container(
            width: MediaQuery.of(context).size.width /
                (widget.iconButtons.length + 1),
            height: 0));
      }
      icons.add(new Container(
          width: MediaQuery.of(context).size.width /
              (widget.iconButtons.length + 1),
          child: widget.iconButtons[i]));
    }

    return icons;
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
    return new Stack(children: <Widget>[
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
              return snapshot.data == -1
                  ? new Container(height: 0, width: 0)
                  : new StreamBuilder(
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
                                          MediaQuery.of(context).size.height *
                                              0.3
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
                                                setState(() {
                                                  backbutton = false;
                                                });
                                              } else {
                                                _moveButtonUp();
                                                setState(() {
                                                  backbutton = true;
                                                });
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
                    ? new Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: (radioModel[0].isSelected == true)
                            ? widget.classChild
                            : widget.foodChild)
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
    if (_item.isSelected == true) {
      print(_item.title);
    }
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
