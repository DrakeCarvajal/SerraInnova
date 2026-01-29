import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/search_provider.dart';
import '../routes/app_routes.dart';

class SavedSearchesPage extends StatefulWidget {
  const SavedSearchesPage({super.key});

  @override
  State<SavedSearchesPage> createState() => _SavedSearchesPageState();
}

class _SavedSearchesPageState extends State<SavedSearchesPage> {
  @override
  void initState() {
    super.initState();
    // cargar lista al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().loadSavedSearches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SearchProvider>();
    final list = p.saved;

    return Scaffold(
      appBar: AppBar(title: const Text('Búsquedas guardadas')),
      body: list.isEmpty
          ? const Center(child: Text('No hay búsquedas guardadas'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final s = list[i];

                return ListTile(
                  title: Text(s.name ?? 'Búsqueda'),
                  subtitle: Text(s.summaryLine()),
                  onTap: () {
                    // cargar búsqueda y volver al listado
                    context.read<SearchProvider>().loadIntoForm(s);
                    Navigator.pushNamed(context, AppRoutes.listing);
                  },
                  trailing: IconButton(
                    tooltip: 'Eliminar',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Eliminar búsqueda'),
                          content: const Text(
                              '¿Seguro que quieres eliminar esta búsqueda?'),
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
