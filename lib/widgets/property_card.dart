import 'package:flutter/material.dart';
import 'package:serrainnova_form/models/enums.dart';

import '../models/property.dart';
import 'app_theme.dart';

/// Tarjeta de vivienda usada en el listado.
/// Muestra una previsualización con:
/// - imagen (si existe)
/// - botones de acción rápidos (llamar/contactar)
/// - información principal (título, precio, resumen, chips)
/// Además adapta el layout según el ancho (columna en móvil, fila en pantallas anchas).
class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property, required this.onTap});

  /// Modelo de datos de la vivienda que se renderiza.
  final Property property;

  /// Acción al pulsar la tarjeta (normalmente abre el detalle).
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // InkWell hace la tarjeta clicable y muestra feedback táctil.
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.all(12),

          // LayoutBuilder permite cambiar el diseño según el espacio disponible.
          child: LayoutBuilder(
            builder: (context, c) {
              final narrow = c.maxWidth < 820;

              // Bloque visual: imagen grande + botones debajo.
              final imageBlock = Column(
                children: [
                  SizedBox(
                    height: 240, // más altura para mejorar la imagen
                    width: double.infinity,
                    child: _PropertyImage(url: property.imageUrl),
                  ),
                  const SizedBox(height: 10),

                  // Acciones rápidas (no navegan, son acciones locales).
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

              // Bloque de texto: datos principales de la vivienda.
              final infoBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title, // tipo + zona
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
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Descripción recortada para que la tarjeta no sea infinita.
                  const Text(
                    'Descripción',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _short(property.description, 220),
                    style: const TextStyle(height: 1.25),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    property.featuresLine, // hab + m2 + planta
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 10),

                  // Chips con información rápida (energía + certificaciones + extras).
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

              // Layout móvil: todo apilado.
              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageBlock,
                    const SizedBox(height: 14),
                    infoBlock,
                  ],
                );
              }

              // Layout ancho: imagen a la izquierda, info a la derecha.
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

  /// Recorta texto largo para evitar tarjetas excesivamente grandes.
  String _short(String s, int max) {
    final t = s.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (t.length <= max) return t;
    return '${t.substring(0, max)}…';
  }
}

/// Widget de imagen con placeholder y manejo básico de carga/errores.
/// Se usa tanto cuando hay url válida como cuando no existe imagen.
class _PropertyImage extends StatelessWidget {
  const _PropertyImage({this.url});

  /// URL remota de la imagen (puede ser null).
  final String? url;

  @override
  Widget build(BuildContext context) {
    // Si no hay imagen, se muestra un placeholder centrado.
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
            // Indicador de carga para UX.
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            // Mensaje simple si falla la carga (y log en consola para depurar).
            errorBuilder: (context, error, stack) {
              debugPrint('Image error: $error');
              return const Center(child: Text('No se pudo cargar la imagen'));
            },
          );

    // Recorta la imagen al contenedor (si luego usas bordes redondeados, se respeta).
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Container(
        color: const Color(0xFFD6F0FF),
        child: child,
      ),
    );
  }
}

/// Botón de acción pequeño, usado para “Llamar” y “Contactar”.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

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

        // Icono dentro de un CircleAvatar para mantener estilo consistente.
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

/// Chip visual para etiquetas rápidas en la tarjeta.
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
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
