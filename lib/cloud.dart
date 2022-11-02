import 'package:flutter/material.dart';

class MyCloud extends StatelessWidget {
  final double cloudX;
  final double cloudY;
  final double cloudWidth;
  final double cloudHeight;

  MyCloud({
    required this.cloudX,
    required this.cloudY,
    required this.cloudWidth,
    required this.cloudHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * cloudX + cloudWidth / (2 - cloudWidth)),
          (2 * cloudY + cloudHeight) / (2 - cloudHeight)),
      child: Container(
          height: MediaQuery.of(context).size.height * 2 / 3 * cloudHeight / 2,
          width: MediaQuery.of(context).size.width * cloudWidth / 2,
          child: Image.asset(
            'lib/images/cloud.png',
            fit: BoxFit.fill,
          )),
    );
  }
}
