import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {

    return PlayAnimationBuilder<double>(
        tween: Tween(begin: 50.0, end: 200.0), // set tween
    duration: const Duration(seconds: 5), // set duration
    builder: (context, value, _) {
     return child;

  }
    );
}}