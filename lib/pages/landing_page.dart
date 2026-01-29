import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/search_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/logo_badge.dart';
import '../widgets/operation_toggle.dart';
import '../widgets/search_field.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late final TextEditingController _controller;

  static const _bgBlue = Color(0xFF1E5D80); // ajusta si quieres otro azul
  static const _cardGreen = Color(0xFFB7F7B0); // verde del mockup aprox

  @override
  void initState() {
    super.initState();
    final p = context.read<SearchProvider>();
    _controller = TextEditingController(text: p.query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToListing(BuildContext context) {
    final p = context.read<SearchProvider>();
    p.setQuery(_controller.text.trim()); // si está vacío => muestra todo
    Navigator.pushNamed(context, AppRoutes.listing);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SearchProvider>();

    return Scaffold(
      backgroundColor: _bgBlue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760, minHeight: 520),
              child: Card(
                color: _cardGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 34, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo centrado
                      const Align(
                        alignment: Alignment.center,
                        child: LogoBadge(size: 200),
                      ),
                      const SizedBox(height: 18),

                      // Título / subtítulo (opcional pero ayuda a “estructurar”)
                      const Text(
                        'Encuentra tu vivienda sostenible',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Busca por barrio o zona y filtra por criterios sociales y ambientales.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 18),

                      // Buscador (más protagonista)
                      SearchField(
                        controller: _controller,
                        hintText:
                            'Ingrese el barrio o zona donde quiere vivir...',
                        onSubmitted: (_) => _goToListing(context),
                      ),
                      const SizedBox(height: 14),

                      // Toggle + botón en fila (o apilado según ancho)
                      LayoutBuilder(
                        builder: (context, c) {
                          final narrow = c.maxWidth < 520;

                          final toggle = OperationToggle(
                            value: p.operation,
                            onChanged: p.setOperation,
                          );

                          final button = SizedBox(
                            height: 52,
                            child: FilledButton.icon(
                              onPressed: () => _goToListing(context),
                              icon: const Icon(Icons.search),
                              label: const Text(
                                'Buscar',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            ),
                          );

                          if (narrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                toggle,
                                const SizedBox(height: 12),
                                button,
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(child: toggle),
                              const SizedBox(width: 12),
                              SizedBox(width: 200, child: button),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      // “Hint” pequeño para UX
                      const Text(
                        'Tip: si dejas el buscador vacío, verás todas las viviendas disponibles.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
