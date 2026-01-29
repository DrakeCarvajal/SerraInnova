import 'package:flutter/material.dart';

import '../models/enums.dart';

class EnergyRatingSelector extends StatelessWidget {
  const EnergyRatingSelector({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  final EnergyRating? selected;
  final void Function(EnergyRating r) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'Calificación energética:',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, c) {
            // ancho máximo disponible para la barra más larga (G)
            final maxW = c.maxWidth;

            return Column(
              children: [
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

  double _widthFor(EnergyRating r, double maxW) {
    // A corta → G larga (estilo etiqueta energía)
    // Ajusta estos factores a tu gusto para que “se vea como tu mockup”
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

  Color _colorFor(EnergyRating r) {
    // Colores aproximados del estándar (puedes cambiarlos)
    return switch (r) {
      EnergyRating.A => const Color(0xFF0a9343), // verde
      EnergyRating.B => const Color(0xFF2bb673), // verde claro
      EnergyRating.C => const Color(0xFF8ec63f), // verde lima
      EnergyRating.D => const Color(0xFFf6ee31), // amarillo
      EnergyRating.E => const Color(0xFFfcb042), // naranja
      EnergyRating.F => const Color(0xFFf6931c), // naranja oscuro
      EnergyRating.G => const Color(0xFFed1b24), // rojo
    };
  }
}

class _EnergyArrowRow extends StatelessWidget {
  const _EnergyArrowRow({
    required this.rating,
    required this.width,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final EnergyRating rating;
  final double width;
  final Color color;
  final bool selected;
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
          child: ClipPath(
            clipper: _ArrowClipper(),
            child: Container(
              color: color,
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Row(
                children: [
                  Text(
                    rating.code, // usa tu extension EnergyRatingX
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (selected)
                    const Icon(Icons.check_circle,
                        size: 22, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Flecha hacia la derecha: rectángulo + triángulo
    final arrowHead = size.height * 0.55; // tamaño de punta
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
