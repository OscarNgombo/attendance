import 'package:flutter/material.dart';

class AnimatedThankYouMessage extends StatefulWidget {
  const AnimatedThankYouMessage({super.key});

  @override
  _AnimatedThankYouMessageState createState() =>
      _AnimatedThankYouMessageState();
}

class _AnimatedThankYouMessageState extends State<AnimatedThankYouMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: _animation.value,
        child: const Text(
          'Thank you, you have successfully checked out from work today. \n Have a nice day!',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
