// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CalorieCounter extends StatelessWidget {
  final calories;

  const CalorieCounter({Key? key, this.calories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'CALORIES',
                    style: TextStyle(color: Colors.red[400], fontSize: 20),
                  ),
                  Text(
                    calories.toString(),
                    style: TextStyle(color: Colors.red[600], fontSize: 30),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
