import 'package:flutter/material.dart';

import '../models/property.dart';
import '../pages/landing_page.dart';
import '../pages/listing_page.dart';
import '../pages/property_detail_page.dart';
import '../pages/saved_searches_page.dart';

/// Centraliza las rutas de navegación de la app.
/// Define:
/// - nombres de rutas (strings)
/// - lógica de creación de pantallas (onGenerateRoute)
/// - paso de argumentos entre pantallas (Property en el detalle)
class AppRoutes {
  /// Ruta inicial (landing).
  static const landing = '/';

  /// Ruta del listado con filtros y resultados.
  static const listing = '/listing';

  /// Ruta de la pantalla de búsquedas guardadas.
  static const saved = '/saved';

  /// Ruta del detalle de una vivienda.
  static const detail = '/detail';

  /// Generador de rutas: decide qué pantalla abrir según settings.name.
  /// Permite también leer settings.arguments para pasar datos al detalle.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landing:
        // Pantalla inicial con buscador y toggle comprar/alquilar.
        return MaterialPageRoute(builder: (_) => const LandingPage());

      case listing:
        // Pantalla principal con filtros y cards de viviendas.
        return MaterialPageRoute(builder: (_) => const ListingPage());

      case saved:
        // Lista de búsquedas persistidas (SQLite/Prefs) para restaurarlas.
        return MaterialPageRoute(builder: (_) => const SavedSearchesPage());

      case detail:
        // Detalle de vivienda. Se espera recibir un Property como argumento.
        final p = settings.arguments as Property?;
        return MaterialPageRoute(
            builder: (_) => PropertyDetailPage(property: p));

      default:
        // Fallback si se intenta navegar a una ruta inexistente.
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
