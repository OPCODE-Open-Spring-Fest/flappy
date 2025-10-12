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
    setState(() {
      isGameStarted = true;
      time = 0;
      initialPos = birdY;
    });

    const double gravity = -4.9; 
    const double velocity = 2.8; 

    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      time += 0.03;

      final double displacement = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - displacement;
        barrierx1 -= 0.05;
        barrierx2 -= 0.05;

        if (barrierx1 < -2) barrierx1 += 3.5;
        if (barrierx2 < -2) barrierx2 += 3.5;
      });

      if (birdisDead()) {
        timer.cancel();
        setState(() => isGameStarted = false);
        _showDialog();
      }
    });
  }

  void resetGame() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    setState(() {
      birdY = 0.0;
      initialPos = birdY;
      time = 0;
      isGameStarted = false;
      barrierx1 = 1;
      barrierx2 = barrierx1 + 1.5;
    });

    startGame();
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
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
