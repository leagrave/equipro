// gradient_background.dart
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({ super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF28313E),Color(0xFF1BD5DB)], // couleurs de fond
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
