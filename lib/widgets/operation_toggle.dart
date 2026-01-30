import 'package:flutter/material.dart';

import '../models/enums.dart';
import 'app_theme.dart';

/// Toggle simple de 2 opciones (Comprar / Alquilar).
/// No guarda estado interno: recibe el valor actual y notifica cambios al padre/provider.
class OperationToggle extends StatelessWidget {
  const OperationToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// Opción seleccionada actualmente.
  final OperationType value;

  /// Callback al tocar una opción.
  final void Function(OperationType) onChanged;

  @override
  Widget build(BuildContext context) {
    // Construye un botón del toggle para un OperationType concreto.
    Widget button(OperationType type) {
      final selected = value == type;

      return Expanded(
        child: InkWell(
          onTap: () => onChanged(type),
          child: Container(
            // Altura fija para que el toggle tenga tamaño consistente.
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // Fondo amarillo cuando está seleccionado, blanco cuando no.
              color: selected ? AppColors.selectedYellow : Colors.white,
              // Borde cian para mantener el estilo del mockup.
              border: Border.all(color: AppColors.borderCyan, width: 2),
            ),
            child: Text(
              type.label,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    }

    // Ancho fijo para que ambos botones tengan buen tamaño y no se "aplasten".
    return SizedBox(
      width: 260,
      child: Row(
        children: [
          button(OperationType.comprar),
          button(OperationType.alquilar),
        ],
      ),
    );
  }
}
