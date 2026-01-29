import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/search_criteria.dart';
import 'search_storage.dart';

class PrefsSearchStorage implements SearchStorage {
  static const _key = 'saved_searches_v1';

  late SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<int> insertSearch(SearchCriteria c) async {
    final list = await listSearches();
    final nextId = (list.isEmpty)
        ? 1
        : (list.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);

    final withId = SearchCriteria.fromJson({
      ...c.toJson(),
      'id': nextId,
    });

    list.insert(0, withId);
    await _saveList(list);
    return nextId;
  }

  @override
  Future<List<SearchCriteria>> listSearches() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => SearchCriteria.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> deleteSearch(int id) async {
    final list = await listSearches();
    list.removeWhere((e) => e.id == id);
    await _saveList(list);
  }

  Future<void> _saveList(List<SearchCriteria> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, raw);
  }
}
