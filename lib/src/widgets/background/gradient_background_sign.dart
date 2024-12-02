// gradient_background.dart
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({ super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 185, 203, 1), // Couleur du haut (blanc)
            Color.fromRGBO(0, 96, 121, 1), // Couleur du bas
          ],
        ),
      ),
      child: child,
    );
  }
}
