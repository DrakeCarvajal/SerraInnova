import '../models/search_criteria.dart';

/// Contrato común para la persistencia de búsquedas guardadas.
/// Permite cambiar la implementación (SQLite o SharedPreferences) sin tocar la UI.
abstract class SearchStorage {
  /// Prepara el storage (abrir BD, cargar prefs, etc.) antes de usarlo.
  Future<void> init();

  /// Inserta una búsqueda y devuelve el id generado/asignado.
  Future<int> insertSearch(SearchCriteria c);

  /// Devuelve la lista de búsquedas guardadas (normalmente ordenadas por fecha).
  Future<List<SearchCriteria>> listSearches();

  /// Elimina una búsqueda por id.
  Future<void> deleteSearch(int id);
}
