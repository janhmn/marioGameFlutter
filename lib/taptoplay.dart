import 'package:flutter/material.dart';

class TapToPlay extends StatelessWidget {
  final bool gameHasStarted;

  TapToPlay({required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return gameHasStarted
        ? Container()
        : Stack(
            children: [
              Container(
                alignment: Alignment(0, 0.2),
                child: Text(
                  'JUMP TO PLAY',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
  }
}
