import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/prefs_search_storage.dart';
import 'provider/search_provider.dart';
import 'provider/sqlite_search_storage.dart';
import 'provider/search_storage.dart';
import 'routes/app_routes.dart';
import 'widgets/app_theme.dart';

/// Punto de entrada de la app.
/// Inicializa Flutter, selecciona el sistema de persistencia según plataforma
/// y arranca la aplicación con el Provider configurado.
Future<void> main() async {
  // Necesario porque se hace trabajo async antes de runApp (inicializar storage).
  WidgetsFlutterBinding.ensureInitialized();

  // Se elige el almacenamiento dependiendo de si es web o no.
  // - Web: SharedPreferences (porque SQLite no está soportado en web con sqflite)
  // - Móvil/desktop: SQLite con sqflite
  final SearchStorage storage;
  if (kIsWeb) {
    storage = PrefsSearchStorage();
    await storage.init();
  } else {
    // SQLite solo en móvil/desktop (en web no funciona)
    final s = await SqliteSearchStorage.initDb();
    storage = s;
  }

  // Lanza el árbol principal de widgets pasando el storage ya preparado.
  runApp(App(storage: storage));
}

/// Widget raíz de la app.
/// Configura Provider(s), tema global y sistema de rutas.
class App extends StatelessWidget {
  const App({super.key, required this.storage});

  /// Implementación concreta de persistencia (SQLite o Prefs).
  final SearchStorage storage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider principal de estado: filtros, criterios, búsquedas guardadas.
        // Se precarga la lista de guardadas para que esté disponible al entrar.
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(storage)..loadSavedSearches(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SERRAINNOVA',

        // Tema global (colores, inputs, cards, appbar...).
        theme: AppTheme.theme,

        // Navegación centralizada por rutas (Landing/Listado/Guardadas/Detalle).
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRoutes.landing,
      ),
    );
  }
}
