import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/enums.dart';
import '../models/property.dart';
import '../provider/search_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/app_theme.dart';
import '../widgets/checkbox_list.dart';
import '../widgets/energy_rating_selector.dart';
import '../widgets/logo_badge.dart';
import '../widgets/operation_toggle.dart';
import '../widgets/property_card.dart';
import '../widgets/range_filter.dart';
import '../widgets/search_field.dart';

/// Pantalla de listado de viviendas.
/// Incluye:
/// - barra superior con búsqueda y selector Comprar/Alquilar
/// - panel de filtros (lateral en web/escritorio, drawer en móvil)
/// - listado de tarjetas con navegación al detalle
/// - acciones para ver y guardar búsquedas persistidas
class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  /// Permite abrir/cerrar el drawer de filtros en modo móvil.
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Controla el input del buscador para sincronizarlo con el provider.
  late final TextEditingController _controller;

  /// Datos de prueba (catálogo) para la práctica.
  final _demo = Property.demo();

  /// Aplica todos los filtros del SearchProvider al catálogo.
  /// Se basa en un criterio completo (SearchCriteria) generado desde el provider.
  List<Property> _applyFilters(List<Property> all) {
    final c = context.read<SearchProvider>().buildCriteria();

    // Comprueba si una lista contiene todas las selecciones marcadas.
    bool containsAll<T>(List<T> haystack, List<T> needles) {
      for (final n in needles) {
        if (!haystack.contains(n)) return false;
      }
      return true;
    }

    final q = c.query.trim().toLowerCase();

    return all.where((p) {
      // Operación (comprar/alquilar)
      if (p.operation != c.operation) return false;

      // Búsqueda por texto: si está vacío no filtra.
      if (q.isNotEmpty) {
        final zone = p.zone.toLowerCase();
        final title = p.title.toLowerCase();
        if (!zone.contains(q) && !title.contains(q)) return false;
      }

      // Filtros por rango.
      if (p.price < c.priceMin || p.price > c.priceMax) return false;
      if (p.bedrooms < c.bedroomsMin || p.bedrooms > c.bedroomsMax)
        return false;
      if (p.m2 < c.m2Min || p.m2 > c.m2Max) return false;

      // Energía: selección única (null = no filtra).
      if (c.energyRating != null && p.energyRating != c.energyRating)
        return false;

      // Checkboxes: la vivienda debe cumplir todas las selecciones activas.
      if (!containsAll(p.certifications, c.certifications)) return false;
      if (!containsAll(p.nearbyServices, c.nearbyServices)) return false;
      if (!containsAll(p.adaptabilityFeatures, c.adaptabilityFeatures))
        return false;
      if (!containsAll(p.extras, c.extras)) return false;

      return true;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Precarga el input del buscador con el estado actual del provider.
    _controller =
        TextEditingController(text: context.read<SearchProvider>().query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Observa el provider para que UI y filtros se actualicen en tiempo real.
    final p = context.watch<SearchProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Layout responsive: en pantallas anchas se muestra panel lateral fijo.
        final wide = constraints.maxWidth >= 1000;

        // Texto actual del buscador para recalcular límites dinámicos.
        final q = p.query.trim().toLowerCase();

        // Base: conjunto que encaja con los filtros de topbar (operación + query).
        // Se usa para ajustar automáticamente los máximos/mínimos de los sliders.
        final base = _demo.where((prop) {
          if (prop.operation != p.operation) return false;
          if (q.isNotEmpty) {
            final z = prop.zone.toLowerCase();
            final t = prop.title.toLowerCase();
            if (!z.contains(q) && !t.contains(q)) return false;
          }
          return true;
        }).toList();

        // Recalcula límites permitidos si existe al menos un resultado base.
        // Se hace post-frame para evitar setState/notifies durante el build.
        if (base.isNotEmpty) {
          int minInt(Iterable<int> xs) => xs.reduce((a, b) => a < b ? a : b);
          int maxInt(Iterable<int> xs) => xs.reduce((a, b) => a > b ? a : b);

          final priceMinA = minInt(base.map((e) => e.price));
          final priceMaxA = maxInt(base.map((e) => e.price));

          final bedMinA = minInt(base.map((e) => e.bedrooms));
          final bedMaxA = maxInt(base.map((e) => e.bedrooms));

          final m2MinA = minInt(base.map((e) => e.m2));
          final m2MaxA = maxInt(base.map((e) => e.m2));

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<SearchProvider>().setAllowedBounds(
                  priceMinA: priceMinA,
                  priceMaxA: priceMaxA,
                  bedroomsMinA: bedMinA,
                  bedroomsMaxA: bedMaxA,
                  m2MinA: m2MinA,
                  m2MaxA: m2MaxA,
                );
          });
        }

        // Aplica el criterio completo (topbar + filtros).
        final filtered = _applyFilters(_demo);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.pageGray,

          // Barra superior responsive: en estrecho se divide en dos filas.
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(wide ? 92 : 150),
            child: Container(
              color: AppColors.topBar,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: SafeArea(
                bottom: false,
                child: LayoutBuilder(
                  builder: (context, c) {
                    final narrow = c.maxWidth < 860;

                    // Ancho: buscador + toggle + logo en una fila.
                    if (!narrow) {
                      return Row(
                        children: [
                          Expanded(
                            child: SearchField(
                              controller: _controller,
                              hintText:
                                  'Ingrese el barrio o zona donde quiere vivir...',
                              onSubmitted: (v) => p.setQuery(v),
                            ),
                          ),
                          const SizedBox(width: 18),
                          OperationToggle(
                              value: p.operation, onChanged: p.setOperation),
                          const SizedBox(width: 18),
                          const LogoBadge(size: 66),
                        ],
                      );
                    }

                    // Estrecho: buscador arriba y controles abajo.
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SearchField(
                          controller: _controller,
                          hintText:
                              'Ingrese el barrio o zona donde quiere vivir...',
                          onSubmitted: (v) => p.setQuery(v),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OperationToggle(
                                value: p.operation,
                                onChanged: p.setOperation,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const LogoBadge(size: 56),
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: 'Filtros',
                              onPressed: () =>
                                  _scaffoldKey.currentState?.openEndDrawer(),
                              icon: const Icon(Icons.tune),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // En móvil: filtros en drawer con scroll.
          endDrawer: wide
              ? null
              : Drawer(
                  child: SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [
                        _FiltersPanel(wide: false),
                      ],
                    ),
                  ),
                ),

          // Cuerpo: panel de filtros fijo (solo wide) + listado.
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (wide)
                SizedBox(
                  width: 340,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _FiltersPanel(wide: true),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Recuento de resultados visibles.
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Resultados: ${filtered.length}'),
                      ),
                      const SizedBox(height: 10),

                      // Lista de tarjetas; al tocar navega al detalle.
                      for (final prop in filtered)
                        PropertyCard(
                          property: prop,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.detail,
                            arguments: prop,
                          ),
                        ),

                      const SizedBox(height: 10),

                      // Acciones relacionadas con persistencia de búsquedas.
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, AppRoutes.saved),
                              icon: const Icon(Icons.bookmarks_outlined),
                              label: const Text('Búsquedas guardadas'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _openSaveDialog(context),
                              icon: const Icon(Icons.bookmark_add_outlined),
                              label: const Text('Guardar búsqueda'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Diálogo para pedir un nombre y persistir el criterio actual.
  Future<void> _openSaveDialog(BuildContext context) async {
    final p = context.read<SearchProvider>();
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Guardar búsqueda'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre de la búsqueda',
            hintText: 'Ej: Centro + Metro + LEED',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              await p.saveSearch(controller.text);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Búsqueda guardada')),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

/// Panel de filtros reutilizado en lateral (wide) y en drawer (móvil).
/// Todos los cambios se aplican sobre el SearchProvider y se reflejan en el listado.
class _FiltersPanel extends StatelessWidget {
  const _FiltersPanel({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SearchProvider>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: EdgeInsets.all(wide ? 18 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera del panel: título y reset.
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Filtros',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                  ),
                ),
                IconButton(
                  tooltip: 'Reset',
                  onPressed: p.resetAll,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Sliders: usan límites dinámicos y muestran errorText si hay validación.
            RangeFilter(
              title: 'Precio:',
              min: p.priceMinAllowed.toDouble(),
              max: p.priceMaxAllowed.toDouble(),
              divisions: (p.priceMaxAllowed - p.priceMinAllowed) ~/ 50,
              values: RangeValues(p.priceMin.toDouble(), p.priceMax.toDouble()),
              onChanged: p.setPriceRange,
              label: (r) => '€${r.start.round()} – €${r.end.round()}',
              errorText: p.errors['price'],
            ),
            RangeFilter(
              title: 'Número habitaciones:',
              min: p.bedroomsMinAllowed.toDouble(),
              max: p.bedroomsMaxAllowed.toDouble(),
              divisions: p.bedroomsMaxAllowed - p.bedroomsMinAllowed,
              values: RangeValues(
                  p.bedroomsMin.toDouble(), p.bedroomsMax.toDouble()),
              onChanged: p.setBedroomsRange,
              label: (r) => '${r.start.round()} – ${r.end.round()}',
              errorText: p.errors['bedrooms'],
            ),
            RangeFilter(
              title: 'Tamaño en m²:',
              min: p.m2MinAllowed.toDouble(),
              max: p.m2MaxAllowed.toDouble(),
              divisions: (p.m2MaxAllowed - p.m2MinAllowed) ~/ 10,
              values: RangeValues(p.m2Min.toDouble(), p.m2Max.toDouble()),
              onChanged: p.setM2Range,
              label: (r) => '${r.start.round()} – ${r.end.round()} m²',
              errorText: p.errors['m2'],
            ),

            // Selector de calificación energética (selección única).
            EnergyRatingSelector(
              selected: p.energyRating,
              onToggle: p.toggleEnergy,
            ),

            // Checkboxes por categoría.
            CheckboxList<Certification>(
              title: 'Certificación vivienda:',
              items: Certification.values,
              isChecked: (c) => p.certifications.contains(c),
              labelOf: (c) => c.label,
              onChanged: (c, v) => p.toggleCertification(c),
            ),
            CheckboxList<NearbyService>(
              title: 'Cercano a:',
              items: NearbyService.values,
              isChecked: (s) => p.nearbyServices.contains(s),
              labelOf: (s) => s.label,
              onChanged: (s, v) => p.toggleService(s),
            ),
            CheckboxList<Adaptability>(
              title: 'Adaptado para:',
              items: Adaptability.values,
              isChecked: (a) => p.adaptabilityFeatures.contains(a),
              labelOf: (a) => a.label,
              onChanged: (a, v) => p.toggleAdaptability(a),
            ),
            CheckboxList<ExtraFeature>(
              title: 'Tiene:',
              items: ExtraFeature.values,
              isChecked: (e) => p.extras.contains(e),
              labelOf: (e) => e.label,
              onChanged: (e, v) => p.toggleExtra(e),
            ),

            const SizedBox(height: 6),

            // Botón de "Aplicar filtros" eliminado porque el listado se actualiza automáticamente.
          ],
        ),
      ),
    );
  }
}
