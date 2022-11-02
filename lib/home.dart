// ignore_for_file: prefer_final_fields, prefer_typing_uninitialized_variables

import 'package:dino/game-logic.dart';
import 'package:dino/reconnect-button.dart';
import 'package:dino/scorescreen.dart';
import 'package:dino/sound-manager.dart';
import 'package:dino/taptoplay.dart';
import 'package:flutter/material.dart';
import 'package:esense_flutter/esense.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';

import 'barrier.dart';
import 'caloriesCounter.dart';
import 'cloud.dart';
import 'gameover.dart';
import 'mario.dart';
import 'music-button.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  //Variables
  final String _eSenseName = "eSense-0320";
  var _streamSubscription = <StreamSubscription<dynamic>>[];
  var _buttonDataSubscription = <StreamSubscription<dynamic>>[];

  late SoundManager soundmanager;
  late AudioPlayer player;
  late AudioPlayer soundEffectPlayer;

  var secondTracker = 0;

  GameLogic logic = GameLogic(0, 0);

  void startGame() {
    setState(() {
      logic.gameHasStarted = true;
    });

    soundmanager.startMusic();

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // check for if mario hits barrier
      if (logic.detectCollision()) {
        soundmanager.stopMusic();
        soundmanager.playSFX("gameOver");
        logic.gameOver = true;
        timer.cancel();
        setState(() {
          if (logic.score > logic.highscore) {
            logic.highscore = logic.score;
          }
        });
      }

      secondTracker += 10;
      if (secondTracker >= 7200) {
        logic.calories++;
        secondTracker = 0;
      }

      // loop barrier to keep the map going
      logic.loopBarriers(this);

      //loop the cloud
      logic.loopCloud(this);

      // update score
      logic.updateScore(this);

      setState(() {
        if (logic.barrierType) {
          logic.barrierX -= 0.01;
        } else {
          logic.barrierX -= 0.02;
        }

        logic.cloudX -= 0.001;
        logic.cloudTwoX -= 0.0015;
      });

      if (logic.barrierX <= 1 && !logic.barrierType) {}
    });
  }

  void jump() {
    logic.midJump = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      logic.height = -logic.gravity / 2 * logic.time * logic.time +
          logic.velocity * logic.time;

      setState(() {
        if (1 - logic.height > 1) {
          logic.resetJump();
          logic.marioY = 1;
          timer.cancel();
        } else {
          logic.marioY = 1 - logic.height;
        }
      });

      // check if dead
      if (logic.gameOver) {
        timer.cancel();
      }

      // keep the time going
      logic.time += 0.01;
    });
  }

  void playAgain() {
    setState(() {
      var lastHighScore = logic.highscore;
      var calories = logic.calories;
      logic = GameLogic(lastHighScore, calories);
    });
  }

  @override
  void initState() {
    super.initState();
    _connectToESense();
    player = AudioPlayer();
    player.setLoopMode(LoopMode.all);
    soundEffectPlayer = AudioPlayer();
    soundmanager = SoundManager(player, soundEffectPlayer);
  }

  Future<void> _connectToESense() async {
    await ESenseManager().disconnect();
    await ESenseManager().connect(_eSenseName);
    ESenseManager().setSamplingRate(10);
  }

  void setUpListener() {
    _streamSubscription.add(ESenseManager().Screen Rercording KeyCode.NUM_ZERO.listen((event) {
      if (!logic.gameHasStarted) {
        if (abs(_handleAccel(event)[0]) + abs(_handleAccel(event)[1]) > 20000) {
          startGame();
        }
      } else {
        if (abs(_handleAccel(event)[0]) + abs(_handleAccel(event)[1]) > 20000) {
          if (!logic.midJump) {
            jump();
          }
        }
      }
    }));
  }

  void setUpButtonListener() {
    _buttonDataSubscription.add(ESenseManager().eSenseEvents.listen((event) {
      if (logic.gameOver && event.runtimeType == ButtonEventChanged) {
        playAgain();
      }
    }));
  }

  List<double> _handleAccel(SensorEvent event) {
    if (event.accel != null) {
      return [
        event.accel![0].toDouble(),
        event.accel![1].toDouble(),
        event.accel![2].toDouble(),
      ];
    } else {
      return [0.0, 0.0, 0.0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ConnectionEvent>(
        stream: ESenseManager().connectionEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.type) {
              case ConnectionType.connected:
                setUpListener();
                setUpButtonListener();
                return GestureDetector(
                  onTap: logic.gameOver
                      ? (playAgain)
                      : (logic.gameHasStarted
                          ? (logic.midJump ? null : jump)
                          : startGame),
                  child: Scaffold(
                    backgroundColor: Colors.blue[300],
                    body: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Center(
                              child: Stack(
                                children: [
                                  // tap to play
                                  TapToPlay(
                                    gameHasStarted: logic.gameHasStarted,
                                  ),

                                  // game over screen
                                  GameOverScreen(
                                    gameOver: logic.gameOver,
                                  ),

                                  // scores
                                  ScoreScreen(
                                    score: logic.score,
                                    highscore: logic.highscore,
                                  ),

                                  // dino
                                  MyMario(
                                    marioX: logic.marioX,
                                    marioY: logic.marioY - logic.marioHeight,
                                    marioWidth: logic.marioWidth,
                                    marioHeight: logic.marioHeight,
                                  ),

                                  // barrier
                                  MyBarrier(
                                    barrierX: logic.barrierX,
                                    barrierY:
                                        logic.barrierY - logic.barrierHeight,
                                    barrierWidth: logic.barrierWidth,
                                    barrierHeight: logic.barrierHeight,
                                    barrierType: logic.barrierType,
                                  ),

                                  MyCloud(
                                    cloudX: logic.cloudX,
                                    cloudY: logic.cloudY,
                                    cloudWidth: logic.cloudWidth,
                                    cloudHeight: logic.cloudHeight,
                                  ),

                                  MyCloud(
                                      cloudX: logic.cloudTwoX,
                                      cloudY: logic.cloudTwoY,
                                      cloudWidth: logic.cloudTwoWidth,
                                      cloudHeight: logic.cloudTwoHeight),

                                  CalorieCounter(
                                    calories: logic.calories,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.green[600],
                            child: MusicButton(soundmanager, toggleMusic),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              case ConnectionType.unknown:
                return GestureDetector(
                  child: Scaffold(
                    backgroundColor: Colors.blue[300],
                    body: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Stack(
                              children: [
                                ReconnectButton(
                                    child: const Text("Reconnect!"),
                                    onPressed: _connectToESense)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.green[600],
                            child: MusicButton(soundmanager, toggleMusic),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              case ConnectionType.disconnected:
                return Scaffold(
                    backgroundColor: Colors.blue[300],
                    body: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'The device was not found!',
                          textAlign: TextAlign.center,
                        )));
              case ConnectionType.device_found:
                return GestureDetector(
                  onTap: logic.gameOver
                      ? (playAgain)
                      : (logic.gameHasStarted
                          ? (logic.midJump ? null : jump)
                          : startGame),
                  child: Scaffold(
                    backgroundColor: Colors.blue[300],
                    body: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Center(
                              child: Stack(
                                children: [
                                  // scores
                                  ScoreScreen(
                                    score: logic.score,
                                    highscore: logic.highscore,
                                  ),

                                  // dino
                                  MyMario(
                                    marioX: logic.marioX,
                                    marioY: logic.marioY - logic.marioHeight,
                                    marioWidth: logic.marioWidth,
                                    marioHeight: logic.marioHeight,
                                  ),

                                  MyBarrier(
                                      barrierX: 0,
                                      barrierY: 1,
                                      barrierWidth: 0.2,
                                      barrierHeight: 0.4,
                                      barrierType: true),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.green[600],
                            child: MusicButton(soundmanager, toggleMusic),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              case ConnectionType.device_not_found:
                return GestureDetector(
                  child: Scaffold(
                    backgroundColor: Colors.blue[300],
                    body: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Stack(
                              children: [
                                ReconnectButton(
                                    child: const Text("Reconnect!"),
                                    onPressed: _connectToESense)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.green[600],
                            child: MusicButton(soundmanager, toggleMusic),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }
          } else {
            return const Center(child: Text("Waiting for Connection Data..."));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    ESenseManager().disconnect();
    for (final subscription in _streamSubscription) {
      subscription.cancel();
    }
    for (final subscription in _buttonDataSubscription) {
      subscription.cancel();
    }
    player.dispose();
    soundEffectPlayer.dispose();
  }

  void toggleMusic() {
    setState(() {
      if (soundmanager.musicOn) {
        soundmanager.toggleMusicSetting();
        soundmanager.musicPlayer.setVolume(0);
      } else {
        soundmanager.toggleMusicSetting();
        soundmanager.musicPlayer.setVolume(1);
      }
    });
  }
}

abs(double number) {
  if (number >= 0) return number;
  return -number;
}
