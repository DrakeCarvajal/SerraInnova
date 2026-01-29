import '../models/search_criteria.dart';

abstract class SearchStorage {
  Future<void> init();
  Future<int> insertSearch(SearchCriteria c);
  Future<List<SearchCriteria>> listSearches();
  Future<void> deleteSearch(int id);
}
