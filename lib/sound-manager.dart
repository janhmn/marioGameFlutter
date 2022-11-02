// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SoundManager {
  late final AudioPlayer musicPlayer;
  late final AudioPlayer sfxPlayer;
  bool musicOn = true;
  var i = 1;

  var currentSong;
  var songs = [
    "marioTheme",
    "marioKartTheme",
    "pokemonBattleMusic",
    "pokemonChampionMusic"
  ];

  SoundManager(AudioPlayer player1, AudioPlayer player2) {
    musicPlayer = player1;
    sfxPlayer = player2;
    musicOn = true;
    songs.shuffle();
    musicPlayer.setAsset("lib/sounds/" + songs[0] + ".mp3");
    musicPlayer.play();

    Timer.periodic(const Duration(minutes: 2), (timer) {
      if (songs[i].isEmpty) {
        i = 0;
      }
      currentSong = songs[i];
      i++;
      musicPlayer.setAsset("lib/sounds/" + currentSong + ".mp3");
      if (musicOn) {
        musicPlayer.play();
      }
    });
  }

  void startMusic() async {
    if (musicOn) {
      musicPlayer.play();
    }
  }

  void stopMusic() async {
    if (musicOn) {
      musicPlayer.pause();
    }
  }

  void toggleMusicSetting() {
    musicOn = !musicOn;
  }

  void playSFX(name) async {
    await sfxPlayer.setAsset("lib/sounds/" + name + ".mp3");
    sfxPlayer.play();
  }
}
