import 'package:flutter/material.dart';

/// Campo de búsqueda reutilizable.
/// Se usa en la landing y en la barra superior del listado.
/// Recibe un controller externo para que el estado del texto lo gestione el padre/provider.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSubmitted,
  });

  /// Controlador del texto (permite leer/escribir el valor desde fuera).
  final TextEditingController controller;

  /// Texto de ayuda que se muestra cuando el campo está vacío.
  final String hintText;

  /// Callback al pulsar “enter”/submit en teclado.
  /// Normalmente se usa para lanzar la búsqueda o actualizar el provider.
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,

      // La decoración se apoya en el InputDecorationTheme global (AppTheme),
      // aquí solo se personalizan detalles específicos del buscador.
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontStyle: FontStyle.italic),
        prefixIcon: const Icon(Icons.search),

        // Padding interno para que el campo tenga altura y “aire” uniforme.
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
