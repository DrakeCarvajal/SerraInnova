import 'package:flutter/material.dart';

import '../models/property.dart';
import '../pages/landing_page.dart';
import '../pages/listing_page.dart';
import '../pages/property_detail_page.dart';
import '../pages/saved_searches_page.dart';

class AppRoutes {
  static const landing = '/';
  static const listing = '/listing';
  static const saved = '/saved';
  static const detail = '/detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landing:
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case listing:
        return MaterialPageRoute(builder: (_) => const ListingPage());
      case saved:
        return MaterialPageRoute(builder: (_) => const SavedSearchesPage());
      case detail:
        final p = settings.arguments as Property?;
        return MaterialPageRoute(
            builder: (_) => PropertyDetailPage(property: p));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
