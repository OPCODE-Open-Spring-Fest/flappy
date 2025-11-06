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
  double barrierx2 = barrierx1 + 2.5; // Increased offset for delayed entry

  Timer? gameTimer;
  double gravity = 4.5; // Gravity constant (positive, pulls down)
  // <-- CORRECTION 1: Velocity must be negative for an upward jump
  double velocity = -2.5; // Jump velocity (negative, pushes up)
  double barrierSpeed = 0.05; // Speed of barriers moving

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
    isGameStarted = true;

    gameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      // Update time
      time += 0.05;

      // <-- CORRECTION 2: Use standard kinematic equation s = v_0*t + 0.5*a*t^2
      // Calculate vertical displacement (height)
      height = (0.5 * gravity * time * time) + (velocity * time);

      setState(() {
        // <-- CORRECTION 3: Update birdY by ADDING displacement
        // A negative displacement (jump) makes birdY smaller (moves up)
        // A positive displacement (gravity) makes birdY larger (moves down)
        birdY = initialPos + height;
      });

      // Move barriers
      setState(() {
        if (barrierx1 < -1.5) {
          barrierx1 = 1.5;
        } else {
          barrierx1 -= barrierSpeed;
        }

        if (barrierx2 < -1.5) {
          barrierx2 = 1.5;
        } else {
          barrierx2 -= barrierSpeed;
        }
      });

      // Check if bird is dead
      if (birdisDead()) {
        timer.cancel();
        _showDialog();
      }
    });
  }

  void resetGame() {
    
  }

  void jump() {
    setState(() {
      time = 0; // Reset time for the physics equation
      initialPos =
          birdY; // Set the start of the jump to the bird's current position
    });
  }

  bool birdisDead() {
    // Check if bird is out of bounds (top or bottom)
    if (birdY > 1 || birdY < -1) {
      return true;
    }

    // <-- CORRECTION 4: Swapped collision logic to match build() method.

    // Check collision with first set of barriers (Top: 200, Bottom: 50)
    // This has *more* barrier, so it should have the *smaller* gap.
    if ((barrierx1 >= -0.1 && barrierx1 <= 0.1)) {
      if (birdY <= -0.4 || birdY >= 0.4) {
        // Small gap
        return true;
      }
    }

    // Check collision with second set of barriers (Top: 50, Bottom: 150)
    // This has *less* barrier, so it should have the *larger* gap.
    if ((barrierx2 >= -0.1 && barrierx2 <= 0.1)) {
      if (birdY <= -0.6 || birdY >= 0.6) {
        // Large gap
        return true;
      }
    }

    return false;
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
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

                      // Barrier 1 (Top: 200, Bottom: 50) -> Small Gap
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        alignment: Alignment(barrierx1, -1),
                        child: MyBarrier(size: 200.0), // Large top
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        alignment: Alignment(barrierx1, 1),
                        child: MyBarrier(size: 50.0), // Small bottom
                      ),

                      // Barrier 2 (Top: 50, Bottom: 150) -> Large Gap
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        alignment: Alignment(barrierx2, -1),
                        child: MyBarrier(size: 50.0), // Small top
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        alignment: Alignment(barrierx2, 1),
                        child: MyBarrier(size: 150.0), // Large bottom
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
