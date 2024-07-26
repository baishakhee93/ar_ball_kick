import 'package:flutter/material.dart';
// Ball widget representing the ball on the screen
class Ball extends StatelessWidget {
  final Color color;
  final double size;

  // Constructor to customize ball properties
  Ball({this.color = Colors.blue, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

/*class Ball extends StatefulWidget {
  @override
  _BallState createState() => _BallState();
}

class _BallState extends State<Ball> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value * MediaQuery.of(context).size.height,
          left: MediaQuery.of(context).size.width / 2,
          child: Icon(Icons.sports_soccer, size: 50),
        );
      },
    );
  }
}*/
