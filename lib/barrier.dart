// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double barrierX;
  final double barrierY;
  final double barrierWidth;
  final double barrierHeight;
  final bool barrierType;

  MyBarrier(
      {required this.barrierX,
      required this.barrierY,
      required this.barrierWidth,
      required this.barrierHeight,
      required this.barrierType});

  @override
  Widget build(BuildContext context) {
    if (barrierType) {
      return Container(
        alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
            (2 * barrierY + barrierHeight) / (2 - barrierHeight)),
        child: Container(
            height:
                MediaQuery.of(context).size.height * 2 / 3 * barrierHeight / 2,
            width: MediaQuery.of(context).size.width * barrierWidth / 2,
            child: Image.asset(
              'lib/images/pylone.png',
              fit: BoxFit.fill,
            )),
      );
    } else {
      return Container(
        alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
            (2 * (barrierY - 0.7) + barrierHeight) / (2 - barrierHeight)),
        child: Container(
            height:
                MediaQuery.of(context).size.height * 2 / 3 * barrierHeight / 2,
            width: MediaQuery.of(context).size.width * barrierWidth / 2,
            child: Image.asset(
              'lib/images/rocket.png',
              fit: BoxFit.fill,
            )),
      );
    }
  }
}
