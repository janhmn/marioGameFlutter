import 'package:flutter/material.dart';

class MyMario extends StatelessWidget {
  final double marioX;
  final double marioY;
  final double marioWidth;
  final double marioHeight;

  MyMario({
    required this.marioX,
    required this.marioY,
    required this.marioWidth,
    required this.marioHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * marioX + marioWidth) / (2 - marioWidth),
          (2 * marioY + marioHeight) / (2 - marioHeight)),
      child: Container(
        height: MediaQuery.of(context).size.height * 2 / 3 * marioHeight / 2,
        width: MediaQuery.of(context).size.width * marioWidth / 2,
        child: Image.asset(
          'lib/images/mario.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
