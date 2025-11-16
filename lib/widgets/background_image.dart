import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final double opacity;
  const BackgroundImage({super.key, this.opacity = 0.4});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/car_background.jpeg',
        fit: BoxFit.cover,
        color: Colors.black.withOpacity(opacity),
        colorBlendMode: BlendMode.darken,
      ),
    );
  }
}