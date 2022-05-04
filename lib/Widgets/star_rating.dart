import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  const StarRating({Key? key}) : super(key: key);

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating>
    with SingleTickerProviderStateMixin {
  int idx = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        lowerBound: 0.5,
        upperBound: 3.0,
        vsync: this,
        duration: Duration(milliseconds: 300));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
            children: [1, 2, 3, 4, 5].map((e) {
          print(idx);
          return GestureDetector(
            onTap: () {
              setState(() {
                idx = e;
              });
            },
            child: SizeTransition(
              sizeFactor: _animationController,
              child: Container(
                margin: const EdgeInsets.only(left: 2.0),
                color: idx < e ? Colors.grey : Colors.yellow,
                width: 44,
                height: 44,
              ),
            ),
          );
        }).toList()),
      ),
    );
  }
}
