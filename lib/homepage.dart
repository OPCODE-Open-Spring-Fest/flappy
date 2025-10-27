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

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: const Text('Game Over', style: TextStyle(color: Colors.white)),
          content: Text(
            'Your bird has fallen!\nScore: $score',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: resetGame,
              child: const Text(
                'Restart',
                style: TextStyle(color: Colors.white),
              ),
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

    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        time += 0.05;
        height = -4.9 * time * time + 2.8 * time;
        birdY = initialPos - height;

        // Move barriers
        barrierx1 -= 0.05;
        barrierx2 -= 0.05;

        // Reposition barriers and increase score
        if (barrierx1 < -1.5) {
          barrierx1 = 1.5;
          score++;
        }
        if (barrierx2 < -1.5) {
          barrierx2 = 1.5;
          score++;
        }
        // Score incremented by 1 for each barrier passed

        // Check if bird is dead
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
    }); // reset the game variables to their initial values

    gameTimer?.cancel();
    Navigator.of(context).pop();
  }

  void jump() {
    time = 0;
    initialPos = birdY;
  }

  bool birdisDead() {
    // Check if bird hits top or bottom of screen
    if (birdY > 1 || birdY < -1) {
      return true;
    }

    // Check collision with first barrier
    if (barrierx1 >= -0.15 && barrierx1 <= 0.15) {
      // Bottom barrier (size 50) - small barrier
      if (birdY > 0.6) {
        return true;
      }
      // Top barrier (size 200) - large barrier
      if (birdY < -0.2) {
        return true;
      }
    }

    // Check collision with second barrier
    if (barrierx2 >= -0.15 && barrierx2 <= 0.15) {
      // Bottom barrier (size 150) - large barrier
      if (birdY > 0.0) {
        return true;
      }
      // Top barrier (size 50) - small barrier
      if (birdY < -0.6) {
        return true;
      }
    }

    return false;
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
                        alignment: const Alignment(0, -0.5),
                        child: Text(
                          isGameStarted ? '' : 'T A P  T O  P L A Y',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (isGameStarted)
                        Container(
                          alignment: const Alignment(-0.8, -0.8),
                          child: Text(
                            'Score: $score',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
                        alignment: Alignment(barrierx1, 1),
                        child: const MyBarrier(size: 50.0),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
                        alignment: Alignment(barrierx1, -1),
                        child: const MyBarrier(size: 200.0),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
                        alignment: Alignment(barrierx2, 1),
                        child: const MyBarrier(size: 150.0),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
                        alignment: Alignment(barrierx2, -1),
                        child: const MyBarrier(size: 50.0),
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
