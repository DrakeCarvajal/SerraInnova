import 'package:flutter/material.dart';

import 'field_error_text.dart';

/// Filtro reutilizable basado en RangeSlider (mínimo–máximo).
/// Se usa para rangos numéricos como:
/// - precio
/// - número de habitaciones
/// - tamaño en m²
/// El estado real (values) lo gestiona el provider; este widget solo pinta y notifica cambios.
class RangeFilter extends StatelessWidget {
  const RangeFilter({
    super.key,
    required this.title,
    required this.values,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.label,
    this.errorText,
  });

  /// Título del filtro (por ejemplo: "Precio:").
  final String title;

  /// Valores actuales del rango (start/end) que vienen del provider.
  final RangeValues values;

  /// Límite mínimo permitido del slider.
  final double min;

  /// Límite máximo permitido del slider.
  final double max;

  /// Número de pasos del slider (cuanto mayor, más preciso).
  final int divisions;

  /// Callback cuando el usuario arrastra los manejadores del slider.
  final void Function(RangeValues) onChanged;

  /// Función para formatear el texto del rango seleccionado (ej: "€500 – €1200").
  final String Function(RangeValues) label;

  /// Texto de error opcional para validaciones (se muestra debajo si existe).
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Separación entre filtros para que no queden pegados.
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado del filtro.
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 10),

          // Slider de doble manejador (mínimo y máximo).
          RangeSlider(
            min: min,
            max: max,
            values: values,
            divisions: divisions,
            onChanged: onChanged,
          ),

          // Etiquetas orientativas bajo el slider.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('Min'), Text('Max')],
          ),

          // Texto central con el rango actual formateado.
          Align(
            alignment: Alignment.center,
            child: Text(
              label(values),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          // Mensaje de error (si aplica) debajo del filtro.
          FieldErrorText(errorText),
        ],
      ),
    );
  }
}
