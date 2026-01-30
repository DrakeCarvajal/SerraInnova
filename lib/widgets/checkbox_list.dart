import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar una lista de checkboxes a partir de cualquier tipo T.
/// Se le pasan:
/// - items: la lista de opciones
/// - isChecked: función para saber si una opción está marcada
/// - labelOf: función para obtener el texto a mostrar
/// - onChanged: callback cuando se marca/desmarca una opción
class CheckboxList<T> extends StatelessWidget {
  /// Título de la sección (por ejemplo: "Certificación vivienda:").
  final String title;

  /// Opciones disponibles para mostrar.
  final List<T> items;

  /// Devuelve si un item está seleccionado según el estado externo (provider).
  final bool Function(T) isChecked;

  /// Devuelve el texto que se mostrará en la UI para cada item.
  final String Function(T) labelOf;

  /// Callback cuando el usuario cambia el estado de un checkbox.
  /// No guarda estado interno: delega la lógica al padre/provider.
  final void Function(T, bool) onChanged;

  const CheckboxList({
    super.key,
    required this.title,
    required this.items,
    required this.isChecked,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Separación inferior para que cada bloque de filtros respire.
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado del grupo de checkboxes.
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 8),

          // Genera un CheckboxListTile por cada opción.
          for (final item in items)
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,

              // Estado actual del checkbox.
              value: isChecked(item),

              // Etiqueta visible para el usuario.
              title: Text(labelOf(item), style: const TextStyle(fontSize: 16)),

              // Notifica el cambio al padre/provider.
              onChanged: (v) => onChanged(item, v ?? false),
            ),
        ],
      ),
    );
  }
}
