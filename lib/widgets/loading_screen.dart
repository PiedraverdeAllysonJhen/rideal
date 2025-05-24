import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatelessWidget {
  final double size;
  final Color color;

  const LoadingScreen({
    super.key,
    this.size = 50.0,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: color,
          size: size,
        ),
      ),
    );
  }
}