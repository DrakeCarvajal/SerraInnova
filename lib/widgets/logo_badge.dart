import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar el logo de la app dentro de un “badge” circular.
/// Se usa en distintas pantallas (landing, top bar, detalle) para mantener identidad visual.
class LogoBadge extends StatelessWidget {
  const LogoBadge({super.key, this.size = 56});

  /// Tamaño total del círculo (ancho y alto).
  final double size;

  @override
  Widget build(BuildContext context) {
    // Contenedor circular que actúa como fondo del logo.
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),

      // Centra el logo y ajusta su tamaño relativo al badge.
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
