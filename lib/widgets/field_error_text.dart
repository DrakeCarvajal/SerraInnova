import 'package:flutter/material.dart';

/// Widget pequeño para mostrar mensajes de error debajo de un campo/filtro.
/// Si no hay texto, no ocupa espacio (SizedBox.shrink).
class FieldErrorText extends StatelessWidget {
  const FieldErrorText(this.text, {super.key});

  /// Texto del error. Si es null o vacío, no se renderiza.
  final String? text;

  @override
  Widget build(BuildContext context) {
    // Evita reservar altura cuando no hay error.
    if (text == null || text!.isEmpty) return const SizedBox.shrink();

    return Padding(
      // Separación superior para que el error quede pegado al campo.
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text!,
        // Usa el color de error del Theme para mantener consistencia.
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
