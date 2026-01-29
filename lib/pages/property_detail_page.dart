import 'package:flutter/material.dart';
import 'package:serrainnova_form/models/enums.dart';

import '../models/property.dart';
import '../widgets/app_theme.dart';
import '../widgets/logo_badge.dart';

class PropertyDetailPage extends StatelessWidget {
  const PropertyDetailPage({super.key, required this.property});

  final Property? property;

  @override
  Widget build(BuildContext context) {
    final p = property ??
        Property(
          id: 0,
          operation: OperationType.comprar,
          zone: 'Piso en Calle de Castellón, Russafa',
          typeLabel: 'Piso',
          price: 150000,
          bedrooms: 3,
          m2: 85,
          floor: 2,
          description:
              'Vivienda demo con distribución cómoda, buena luz natural y ubicación excelente. '
              'A pocos minutos de transporte y servicios. Ideal para probar el detalle y el scroll.',
          energyRating: EnergyRating.C,
          certifications: const [],
          nearbyServices: const [],
          adaptabilityFeatures: const [],
          extras: const [],
          imageUrl: 'https://picsum.photos/seed/demo/1200/800',
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.topBar,
        title: const Text('Detalle de vivienda'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: LogoBadge(size: 54),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final wide = c.maxWidth >= 860;

                    final left = _ImageAndButtons(p: p);
                    final right = _Details(p: p);

                    if (wide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 440, child: left),
                          const SizedBox(width: 18),
                          Expanded(child: right),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        left,
                        const SizedBox(height: 18),
                        right,
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageAndButtons extends StatelessWidget {
  const _ImageAndButtons({required this.p});

  final Property p;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Imagen grande
        SizedBox(
          height: 420,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Container(
              color: const Color(0xFFD6F0FF),
              child: (p.imageUrl == null || p.imageUrl!.isEmpty)
                  ? const Center(
                      child: Text(
                        'Imagen de la vivienda',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Image.network(
                      p.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stack) {
                        debugPrint('Image error: $error');
                        return const Center(
                            child: Text('No se pudo cargar la imagen'));
                      },
                    ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Botones adaptativos
        LayoutBuilder(
          builder: (context, c) {
            final stacked = c.maxWidth < 420;

            final callBtn = _ActionButton(
              icon: Icons.call,
              label: 'Llamar',
              onPressed: () {},
              compact: stacked,
            );

            final contactBtn = _ActionButton(
              icon: Icons.mail_outline,
              label: 'Contactar',
              onPressed: () {},
              compact: stacked,
            );

            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 54, child: callBtn),
                  const SizedBox(height: 12),
                  SizedBox(height: 54, child: contactBtn),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: SizedBox(height: 54, child: callBtn)),
                const SizedBox(width: 12),
                Expanded(child: SizedBox(height: 54, child: contactBtn)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.p});
  final Property p;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      _Chip(text: 'Energía ${p.energyRating.code}'),
      ...p.certifications.map((e) => _Chip(text: e.label)),
      ...p.nearbyServices.map((e) => _Chip(text: e.label)),
      ...p.extras.map((e) => _Chip(text: e.label)),
      ...p.adaptabilityFeatures.map((e) => _Chip(text: 'Adaptado: ${e.label}')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.title, // ✅ tipo + zona
          style: TextStyle(
            color: AppColors.deepBlueTitle,
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          p.priceLabel.toUpperCase(),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        Text(p.featuresLine,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (chips.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips,
          ),
        const SizedBox(height: 18),
        const Text(
          'Descripción de la vivienda',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(
          p.description,
          style: const TextStyle(fontSize: 16, height: 1.35),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.callGreen,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(
          fontSize: compact ? 18 : 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: compact ? 22 : 24),
          SizedBox(width: compact ? 8 : 10),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
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
