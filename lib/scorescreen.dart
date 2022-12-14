import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {
  final score;
  final highscore;

  ScoreScreen({
    this.score,
    this.highscore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'SCORE',
                style: TextStyle(color: Colors.grey[400], fontSize: 20),
              ),
              Text(
                score.toString(),
                style: TextStyle(color: Colors.grey[600], fontSize: 30),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'HIGHSCORE',
                style: TextStyle(color: Colors.grey[400], fontSize: 20),
              ),
              Text(
                highscore.toString(),
                style: TextStyle(color: Colors.grey[600], fontSize: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
