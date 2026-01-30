import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/search_criteria.dart';
import 'search_storage.dart';

/// Implementación de SearchStorage basada en SharedPreferences.
/// Se usa como persistencia ligera (sin SQL) guardando la lista completa en JSON.
class PrefsSearchStorage implements SearchStorage {
  /// Clave única donde se guarda el JSON con las búsquedas.
  static const _key = 'saved_searches_v1';

  /// Instancia de SharedPreferences inicializada en init().
  late SharedPreferences _prefs;

  @override
  Future<void> init() async {
    // Carga la instancia de preferencias antes de poder leer/escribir.
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<int> insertSearch(SearchCriteria c) async {
    // Lee la lista actual para poder añadir una nueva búsqueda.
    final list = await listSearches();

    // Genera un id incremental (similar a autoincrement) para mantener compatibilidad con la UI.
    final nextId = (list.isEmpty)
        ? 1
        : (list.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);

    // Crea una copia del criterio con el id asignado (reutiliza fromJson/toJson).
    final withId = SearchCriteria.fromJson({
      ...c.toJson(),
      'id': nextId,
    });

    // Inserta al principio para que aparezca como "más reciente".
    list.insert(0, withId);

    // Persiste toda la lista actualizada.
    await _saveList(list);
    return nextId;
  }

  @override
  Future<List<SearchCriteria>> listSearches() async {
    // Recupera el JSON de preferencias y lo transforma en lista de SearchCriteria.
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => SearchCriteria.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> deleteSearch(int id) async {
    // Filtra la lista quitando la búsqueda por id y vuelve a guardar.
    final list = await listSearches();
    list.removeWhere((e) => e.id == id);
    await _saveList(list);
  }

  /// Guarda la lista completa como JSON en una única clave.
  /// Es simple, pero para listas grandes no es tan eficiente como SQLite.
  Future<void> _saveList(List<SearchCriteria> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, raw);
  }
}
