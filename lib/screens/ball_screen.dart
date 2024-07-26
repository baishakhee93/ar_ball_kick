import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../leg_detector.dart';
import '../widgets/ball.dart';

class BallScreen extends StatefulWidget {
  @override
  _BallScreenState createState() => _BallScreenState();
}

class _BallScreenState extends State<BallScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isAnimationRunning = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(300, 600), // End position of the ball; customize as needed
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LegDetector>(context, listen: false).resetDetection();
      _startBallMovement();
    });
  }

  void _startBallMovement() {
    if (_isAnimationRunning) return; // Prevent starting the animation again
    _isAnimationRunning = true;
    _animationController.forward().then((_) {
      // Ball movement finished, check if leg is detected
      if (!Provider.of<LegDetector>(context, listen: false).isLegDetected) {
        _animationController.reset();
        _startBallMovement();
      } else {
        _isAnimationRunning = false; // Stop the animation if leg is detected
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ball Interaction')),
      body: Stack(
        children: [
          Consumer<LegDetector>(
            builder: (context, legDetector, child) {
              if (legDetector.isLegDetected) {
                return Positioned(
                  top: _animation.value.dy,
                  left: _animation.value.dx,
                  child: Ball(color: Colors.red, size: 70.0),
                );
              } else {
                return Center(child: Text("Leg not detected"));
              }
            },
          ),
          Positioned(
            bottom: 50,
            left: 50,
            child: ElevatedButton(
              onPressed: () {
                Provider.of<LegDetector>(context, listen: false).resetDetection();
                _animationController.reset();
                _startBallMovement(); // Restart ball movement
              },
              child: Text('Reset Detection'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}




