import 'dart:async';

import 'package:flappy_bird/barriers.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static double birdY = 0.0;
  double initialPos = birdY;
  double height = 0, time = 0;
  bool isGameStarted = false;
  static double barrierx1 = 1;
  double barrierx2 = barrierx1 + 1.5;
  Timer? gameTimer;
  int score = 0;
  // ignore: unused_element
  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Text('Game Over', style: TextStyle(color: Colors.white)),
          content: Text(
            'Your bird has fallen!\nScore: $score',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: resetGame,
              child: Text('Restart', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void startGame() {
    setState(() {
      isGameStarted = true;
    });
    gameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        time += 0.05;
        height = -4.9 * time * time + 2.8 * time;
        birdY = initialPos - height;
        barrierx1 -= 0.05;
        barrierx2 -= 0.05;

        if (barrierx1 < -1.5) {
          barrierx1 = 1.5;
          score++;
        }
        if (barrierx2 < -1.5) {
          barrierx2 = 1.5;
          score++;
        }

        if (birdisDead()) {
          gameTimer?.cancel();
          _showDialog();
        }
      });
    });
  }

  void resetGame() {
    setState(() {
      birdY = 0.0;
      initialPos = birdY;
      time = 0;
      height = 0;
      isGameStarted = false;
      barrierx1 = 1;
      barrierx2 = barrierx1 + 1.5;
      score = 0;
    });
    gameTimer?.cancel();
    Navigator.of(context).pop();
  }

  void jump() {
    time = 0;
    initialPos = birdY;
  }

  bool birdisDead() {
    return birdY > 1 || birdY < -1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isGameStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(birdY: birdY),
                      Container(
                        alignment: Alignment(0, -0.5),
                        child: Text(
                          isGameStarted ? '' : 'T A P  T O  P L A Y',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if (isGameStarted)
                        Container(
                          alignment: Alignment(-0.8, -0.8),
                          child: Text(
                            'Score: $score',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        alignment: Alignment(barrierx1, 1),
                        child: MyBarrier(size: 50.0),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        alignment: Alignment(barrierx1, -1),
                        child: MyBarrier(size: 200.0),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        alignment: Alignment(barrierx2, 1),
                        child: MyBarrier(size: 150.0),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        alignment: Alignment(barrierx2, -1),
                        child: MyBarrier(size: 50.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(height: 15, color: Colors.green),
            Expanded(child: Container(color: Colors.brown)),
          ],
        ),
      ),
    );
  }
}
