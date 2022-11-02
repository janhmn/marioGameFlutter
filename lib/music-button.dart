// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:dino/sound-manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MusicButton extends StatelessWidget {
  late SoundManager soundmanager;
  late void Function() onPressed;
  bool musicOn = true;

  MusicButton(SoundManager soundmanager, onPressed) {
    this.soundmanager = soundmanager;
    this.onPressed = onPressed;
    musicOn = soundmanager.musicOn;
  }

  @override
  Widget build(BuildContext context) {
    if (musicOn) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: onPressed,
            child: const Icon(Icons.music_off),
          )
        ]),
      );
    } else {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: onPressed,
              child: const Icon(
                Icons.music_note,
              ))
        ]),
      );
    }
  }
}
