import 'package:flutter/material.dart';
import 'package:serrainnova_form/models/enums.dart';

import '../models/property.dart';
import 'app_theme.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property, required this.onTap});

  final Property property;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, c) {
              final narrow = c.maxWidth < 820;

              final imageBlock = Column(
                children: [
                  SizedBox(
                    height: 240, // ✅ más altura para la imagen
                    width: double.infinity,
                    child: _PropertyImage(url: property.imageUrl),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.call,
                          label: 'Llamar',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.mail_outline,
                          label: 'Contactar',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              );

              final infoBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: TextStyle(
                      color: AppColors.deepBlueTitle,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    property.priceLabel.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  const Text('Descripción',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(
                    _short(property.description, 220),
                    style: const TextStyle(height: 1.25),
                  ),
                  const SizedBox(height: 12),
                  Text(property.featuresLine,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Chip(text: 'Energía ${property.energyRating.code}'),
                      ...property.certifications
                          .map((c) => _Chip(text: c.label)),
                      ...property.extras
                          .take(2)
                          .map((e) => _Chip(text: e.label)),
                    ],
                  ),
                ],
              );

              if (narrow) {
                // ✅ móvil/estrecho: primero imagen+botones, luego info
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageBlock,
                    const SizedBox(height: 14),
                    infoBlock,
                  ],
                );
              }

              // ✅ ancho: izquierda imagen+botones, derecha info
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 360, child: imageBlock),
                  const SizedBox(width: 16),
                  Expanded(child: infoBlock),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _short(String s, int max) {
    final t = s.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (t.length <= max) return t;
    return '${t.substring(0, max)}…';
  }
}

class _PropertyImage extends StatelessWidget {
  const _PropertyImage({this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    final child = (url == null || url!.isEmpty)
        ? const Center(
            child: Text(
              'Imagen de la vivienda',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
          )
        : Image.network(
            url!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stack) {
              // Esto ayuda a ver el motivo real en la consola
              debugPrint('Image error: $error');
              return const Center(child: Text('No se pudo cargar la imagen'));
            },
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Container(
        color: const Color(0xFFD6F0FF),
        child: child,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton(
      {required this.icon, required this.label, required this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.callGreen,
          foregroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPressed,
        icon: CircleAvatar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          child: Icon(icon),
        ),
        label: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF76D6E0), width: 1),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}
