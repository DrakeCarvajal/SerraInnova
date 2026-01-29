import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/prefs_search_storage.dart';
import 'provider/search_provider.dart';
import 'provider/sqlite_search_storage.dart';
import 'provider/search_storage.dart';
import 'routes/app_routes.dart';
import 'widgets/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SearchStorage storage;
  if (kIsWeb) {
    storage = PrefsSearchStorage();
    await storage.init();
  } else {
    // SQLite solo en móvil/desktop (en web no funciona)
    final s = await SqliteSearchStorage.initDb();
    storage = s;
  }

  runApp(App(storage: storage));
}

class App extends StatelessWidget {
  const App({super.key, required this.storage});

  final SearchStorage storage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(storage)..loadSavedSearches(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SERRAINNOVA',
        theme: AppTheme.theme,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRoutes.landing,
      ),
    );
  }
}
