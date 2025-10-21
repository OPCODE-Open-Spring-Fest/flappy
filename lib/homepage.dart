// import 'dart:async';

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
            'Your bird has fallen!',
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
    // TODO: Implement the game loop logic here.
    // Hint: Use a Timer to periodically update the bird's position and barriers.
    // Hint: Update the bird's position using physics equations.
    // Hint: Check if the bird is dead and stop the game if necessary.
  }

  void resetGame() {
    // TODO: Reset the game state to its initial values.
    // Hint: Reset birdY, initialPos, time, and isGameStarted.
  }

  void jump() {
    time = 0;
    initialPos = birdY;
  }

  bool birdisDead() {
    // TODO: Check if the bird is out of bounds.
    // Hint: Return true if birdY is greater than 1 or less than -1.
    return false; // Replace this with the correct condition.
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
