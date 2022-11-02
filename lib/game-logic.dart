// ignore_for_file: file_names

import 'dart:math';

class GameLogic {
  //GameLogic
  bool gameHasStarted = false;
  bool gameOver = false;
  bool midJump = false;
  bool passedBarrier = false;

  //jump variables
  double time = 0;
  double height = 0;
  double gravity = 9.8;
  double velocity = 5;

  //scores
  int score = 0;
  int highscore = 0;
  int calories = 0;

  //player variables
  double marioX = -0.5;
  double marioY = 1;
  double marioWidth = 0.2;
  double marioHeight = 0.4;

  //barrier variables
  double barrierX = 1.5;
  double barrierY = 1;
  double barrierWidth = 0.2;
  double barrierHeight = 0.4;
  bool barrierType = true;

  //cloud number 1 variables
  double cloudX = 1;
  double cloudY = -1.1;
  double cloudWidth = 0.5;
  double cloudHeight = 0.5;

  //cloud number 2 variables
  double cloudTwoX = 1.5;
  double cloudTwoY = -0.7;
  double cloudTwoWidth = 0.3;
  double cloudTwoHeight = 0.3;

  GameLogic(int lastHighScore, int burnedCalories) {
    highscore = lastHighScore;
    calories = burnedCalories;
  }

  bool detectCollision() {
    if (barrierType) {
      if (barrierX <= marioX + marioWidth &&
          barrierX + barrierWidth >= marioX &&
          marioY >= barrierY - barrierHeight) {
        return true;
      }
    } else {
      if (barrierX <= marioX + marioWidth &&
          barrierX + barrierWidth >= marioX &&
          marioY <= barrierY - (barrierHeight / 2)) {
        return true;
      }
    }
    return false;
  }

  void resetJump() {
    midJump = false;
    time = 0;
  }

  void loopBarriers(home) {
    home.setState(() {
      if (barrierX <= -1.2) {
        barrierType = makeNextBarrierType();
        if (!barrierType) {
          home.soundmanager.playSFX("rocket");
        }
        var newX = randomiseX(1.5);
        barrierX = newX;
        passedBarrier = false;
      }
    });
  }

  void loopCloud(home) {
    home.setState(() {
      if (cloudX <= -1.5) {
        cloudX = 1;
      }
      if (cloudTwoX <= -1.1) {
        cloudTwoX = 1.1;
      }
    });
  }

  void updateScore(home) {
    if (barrierX < marioX && passedBarrier == false) {
      home.setState(() {
        passedBarrier = true;
        if (barrierType) {
          score++;
        }
      });
    }
  }

  double randomiseX(value) {
    bool direction = Random().nextBool();
    if (direction) {
      return (value + Random().nextDouble());
    } else {
      var returnValue = value - Random().nextDouble();
      if (returnValue < 1.1) {
        returnValue = 1.1;
      }
      return returnValue;
    }
  }
}

//returns true in 75% of the cases
bool makeNextBarrierType() {
  var firstBool = Random().nextBool();
  if (firstBool) {
    return Random().nextBool();
  }
  return true;
}
