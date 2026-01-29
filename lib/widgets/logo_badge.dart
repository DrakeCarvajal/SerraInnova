import 'package:flutter/material.dart';

//import 'app_theme.dart';

class LogoBadge extends StatelessWidget {
  const LogoBadge({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    // Placeholder circular (pon tu logo como Image.asset si quieres)
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Image.asset(
          '../../assets/logo.png',
          width: size * 0.7,
          height: size * 0.7,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
