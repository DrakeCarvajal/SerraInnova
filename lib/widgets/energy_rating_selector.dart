import 'package:flutter/material.dart';

import '../models/enums.dart';

/// Selector de calificación energética inspirado en el “diagrama” típico (A→G).
/// Muestra una lista de barras con forma de flecha, donde:
/// - A es la más corta (mejor eficiencia)
/// - G es la más larga (peor eficiencia)
/// Permite seleccionar una única letra (tap para seleccionar / tap de nuevo para deseleccionar en el provider).
class EnergyRatingSelector extends StatelessWidget {
  const EnergyRatingSelector({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  /// Valor actualmente seleccionado. Null significa "sin preferencia".
  final EnergyRating? selected;

  /// Callback cuando el usuario toca una letra.
  final void Function(EnergyRating r) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        // Título del bloque de filtros.
        const Text(
          'Calificación energética:',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 10),

        // LayoutBuilder permite calcular el ancho máximo disponible en este panel
        // y escalar las barras según el espacio real.
        LayoutBuilder(
          builder: (context, c) {
            final maxW = c.maxWidth;

            return Column(
              children: [
                // Genera una fila por cada letra A..G.
                for (final r in EnergyRating.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _EnergyArrowRow(
                      rating: r,
                      width: _widthFor(r, maxW),
                      color: _colorFor(r),
                      selected: selected == r,
                      onTap: () => onToggle(r),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Calcula el ancho de cada barra según la letra (A más corta, G más larga).
  double _widthFor(EnergyRating r, double maxW) {
    final factor = switch (r) {
      EnergyRating.A => 0.55,
      EnergyRating.B => 0.62,
      EnergyRating.C => 0.69,
      EnergyRating.D => 0.76,
      EnergyRating.E => 0.83,
      EnergyRating.F => 0.91,
      EnergyRating.G => 1.00,
    };
    return maxW * factor;
  }

  /// Colores aproximados del estándar (verde→rojo) para reforzar el significado visual.
  Color _colorFor(EnergyRating r) {
    return switch (r) {
      EnergyRating.A => const Color(0xFF0a9343),
      EnergyRating.B => const Color(0xFF2bb673),
      EnergyRating.C => const Color(0xFF8ec63f),
      EnergyRating.D => const Color(0xFFf6ee31),
      EnergyRating.E => const Color(0xFFfcb042),
      EnergyRating.F => const Color(0xFFf6931c),
      EnergyRating.G => const Color(0xFFed1b24),
    };
  }
}

/// Fila individual (una letra) con forma de flecha y estado seleccionado.
class _EnergyArrowRow extends StatelessWidget {
  const _EnergyArrowRow({
    required this.rating,
    required this.width,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  /// Letra A..G.
  final EnergyRating rating;

  /// Ancho calculado para esta fila.
  final double width;

  /// Color de fondo (verde→rojo).
  final Color color;

  /// Si está seleccionada, se marca con borde y check.
  final bool selected;

  /// Acción al tocar.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? Colors.black : Colors.transparent;

    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: width,
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
          ),
          // ClipPath recorta el contenedor con forma de flecha.
          child: ClipPath(
            clipper: _ArrowClipper(),
            child: Container(
              color: color,
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Row(
                children: [
                  // Letra (usa code para mantener consistencia con enums.dart).
                  Text(
                    rating.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  // Indicador visual de selección.
                  if (selected)
                    const Icon(
                      Icons.check_circle,
                      size: 22,
                      color: Colors.black,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Clipper que dibuja una flecha hacia la derecha (rectángulo + punta).
/// Incluye un pequeño “notch” a la izquierda para parecerse más a la etiqueta real.
class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final arrowHead = size.height * 0.55;
    final notch = size.height * 0.20;

    final w = size.width;
    final h = size.height;

    return Path()
      ..moveTo(0, 0)
      ..lineTo(w - arrowHead, 0)
      ..lineTo(w, h / 2)
      ..lineTo(w - arrowHead, h)
      ..lineTo(0, h)
      ..lineTo(notch, h / 2)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
