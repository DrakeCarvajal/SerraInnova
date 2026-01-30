import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/search_provider.dart';
import '../routes/app_routes.dart';

/// Pantalla que muestra las búsquedas guardadas por el usuario.
/// Permite:
/// - listar las búsquedas persistidas
/// - cargar una búsqueda para restaurar filtros y volver al listado
/// - eliminar una búsqueda con confirmación
class SavedSearchesPage extends StatefulWidget {
  const SavedSearchesPage({super.key});

  @override
  State<SavedSearchesPage> createState() => _SavedSearchesPageState();
}

class _SavedSearchesPageState extends State<SavedSearchesPage> {
  @override
  void initState() {
    super.initState();
    // Carga la lista al entrar a la pantalla.
    // Se ejecuta post-frame para asegurar que el Provider ya está disponible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().loadSavedSearches();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Observa el provider para refrescar la lista cuando se guarda o elimina.
    final p = context.watch<SearchProvider>();
    final list = p.saved;

    return Scaffold(
      appBar: AppBar(title: const Text('Búsquedas guardadas')),

      // Estado vacío si no existen búsquedas persistidas.
      body: list.isEmpty
          ? const Center(child: Text('No hay búsquedas guardadas'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final s = list[i];

                return ListTile(
                  // Nombre asignado por el usuario (o valor por defecto).
                  title: Text(s.name ?? 'Búsqueda'),

                  // Resumen compacto de filtros para identificarla rápidamente.
                  subtitle: Text(s.summaryLine()),

                  // Al tocar una búsqueda se restauran filtros y se navega al listado.
                  onTap: () {
                    context.read<SearchProvider>().loadIntoForm(s);
                    Navigator.pushNamed(context, AppRoutes.listing);
                  },

                  // Acción de borrado con confirmación.
                  trailing: IconButton(
                    tooltip: 'Eliminar',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      // Confirmación para evitar borrados accidentales.
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Eliminar búsqueda'),
                          content: const Text(
                            '¿Seguro que quieres eliminar esta búsqueda?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      // Si el usuario confirma, se borra por id y el provider actualiza la lista.
                      if (ok == true) {
                        if (s.id != null) {
                          await context
                              .read<SearchProvider>()
                              .deleteSaved(s.id!);
                        }
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
