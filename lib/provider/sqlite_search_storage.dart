import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/enums.dart';
import '../models/search_criteria.dart';
import 'search_storage.dart';

class SqliteSearchStorage implements SearchStorage {
  SqliteSearchStorage._(this._db);
  final Database _db;

  static Future<SqliteSearchStorage> initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'serrainnova.db');

    final db = await openDatabase(
      path,
      version: 3,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON;'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE searches (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            query TEXT NOT NULL,
            operation TEXT NOT NULL,
            price_min INTEGER NOT NULL,
            price_max INTEGER NOT NULL,
            bedrooms_min INTEGER NOT NULL,
            bedrooms_max INTEGER NOT NULL,
            m2_min INTEGER NOT NULL,
            m2_max INTEGER NOT NULL,
            energy_rating TEXT,
            target_young INTEGER NOT NULL,
            target_older INTEGER NOT NULL,
            target_disabled INTEGER NOT NULL,
            created_at TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE search_certifications (
            search_id INTEGER NOT NULL,
            cert_code TEXT NOT NULL,
            PRIMARY KEY (search_id, cert_code),
            FOREIGN KEY (search_id) REFERENCES searches(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE search_services (
            search_id INTEGER NOT NULL,
            service_code TEXT NOT NULL,
            PRIMARY KEY (search_id, service_code),
            FOREIGN KEY (search_id) REFERENCES searches(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE search_adaptability (
            search_id INTEGER NOT NULL,
            adapt_code TEXT NOT NULL,
            PRIMARY KEY (search_id, adapt_code),
            FOREIGN KEY (search_id) REFERENCES searches(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE search_extras (
            search_id INTEGER NOT NULL,
            extra_code TEXT NOT NULL,
            PRIMARY KEY (search_id, extra_code),
            FOREIGN KEY (search_id) REFERENCES searches(id) ON DELETE CASCADE
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Para la práctica: si hay BD antigua, recreamos.
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS search_extras');
          await db.execute('DROP TABLE IF EXISTS search_services');
          await db.execute('DROP TABLE IF EXISTS search_certifications');
          await db.execute('DROP TABLE IF EXISTS searches');
          await db.execute('''
            CREATE TABLE searches (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              query TEXT NOT NULL,
              operation TEXT NOT NULL,
              price_min INTEGER NOT NULL,
              price_max INTEGER NOT NULL,
              bedrooms_min INTEGER NOT NULL,
              bedrooms_max INTEGER NOT NULL,
              m2_min INTEGER NOT NULL,
              m2_max INTEGER NOT NULL,
              energy_rating TEXT,
              target_young INTEGER NOT NULL,
              target_older INTEGER NOT NULL,
              target_disabled INTEGER NOT NULL,
              created_at TEXT NOT NULL
            );
          ''');
          await db.execute('''
            CREATE TABLE search_certifications (
              search_id INTEGER NOT NULL,
              cert_code TEXT NOT NULL,
              PRIMARY KEY (search_id, cert_code),
              FOREIGN KEY (search_id) REFERENCES searches(id) ON DELETE CASCADE
            );
          ''');
          await db.execute('''
            CREATE TABLE search_services (
              search_id INTEGER NOT NULL,
              service_code TEXT NOT NULL,
              PRIMARY KEY (search_id, service_code),
              FOREIGN KEY (search_id) REFERENCES searches(id) ON DELETE CASCADE
            );
          ''');
          await db.execute('''
            CREATE TABLE search_adaptability (
              search_id INTEGER NOT NULL,
              adapt_code TEXT NOT NULL,
              PRIMARY KEY (search_id, adapt_code),
              FOREIGN KEY (search_id) REFERENCES searches(id) ON DELETE CASCADE
            );
          ''');
          await db.execute('''
            CREATE TABLE search_extras (
              search_id INTEGER NOT NULL,
              extra_code TEXT NOT NULL,
              PRIMARY KEY (search_id, extra_code),
              FOREIGN KEY (search_id) REFERENCES searches(id) ON DELETE CASCADE
            );
          ''');
        }
      },
    );

    return SqliteSearchStorage._(db);
  }

  @override
  Future<void> init() async {
    // init happens through initDb; kept for interface
  }

  @override
  Future<int> insertSearch(SearchCriteria c) async {
    final id = await _db.insert('searches', {
      'name': c.name ?? 'Búsqueda',
      'query': c.query,
      'operation': c.operation.code,
      'price_min': c.priceMin,
      'price_max': c.priceMax,
      'bedrooms_min': c.bedroomsMin,
      'bedrooms_max': c.bedroomsMax,
      'm2_min': c.m2Min,
      'm2_max': c.m2Max,
      'energy_rating': c.energyRating?.code,
      'created_at': c.createdAt.toIso8601String(),
    });

    final batch = _db.batch();
    for (final cert in c.certifications) {
      batch.insert(
          'search_certifications', {'search_id': id, 'cert_code': cert.code});
    }
    for (final s in c.nearbyServices) {
      batch
          .insert('search_services', {'search_id': id, 'service_code': s.code});
    }
    for (final a in c.adaptabilityFeatures) {
      batch.insert(
          'search_adaptability', {'search_id': id, 'adapt_code': a.code});
    }

    for (final e in c.extras) {
      batch.insert('search_extras', {'search_id': id, 'extra_code': e.code});
    }
    await batch.commit(noResult: true);

    return id;
  }

  @override
  Future<List<SearchCriteria>> listSearches() async {
    final rows = await _db.query('searches', orderBy: 'created_at DESC');
    final out = <SearchCriteria>[];

    for (final r in rows) {
      final id = r['id'] as int;

      final certRows = await _db.query(
        'search_certifications',
        columns: ['cert_code'],
        where: 'search_id = ?',
        whereArgs: [id],
      );
      final serviceRows = await _db.query(
        'search_services',
        columns: ['service_code'],
        where: 'search_id = ?',
        whereArgs: [id],
      );
      final adaptRows = await _db.query(
        'search_adaptability',
        columns: ['adapt_code'],
        where: 'search_id = ?',
        whereArgs: [id],
      );
      final extraRows = await _db.query(
        'search_extras',
        columns: ['extra_code'],
        where: 'search_id = ?',
        whereArgs: [id],
      );

      out.add(
        SearchCriteria(
          id: id,
          name: r['name'] as String,
          query: r['query'] as String,
          operation: OperationTypeX.fromCode(r['operation'] as String),
          priceMin: r['price_min'] as int,
          priceMax: r['price_max'] as int,
          bedroomsMin: r['bedrooms_min'] as int,
          bedroomsMax: r['bedrooms_max'] as int,
          m2Min: r['m2_min'] as int,
          m2Max: r['m2_max'] as int,
          energyRating: r['energy_rating'] == null
              ? null
              : EnergyRatingX.fromCode(r['energy_rating'] as String),
          certifications: certRows
              .map((e) => CertificationX.fromCode(e['cert_code'] as String))
              .toList(),
          nearbyServices: serviceRows
              .map((e) => NearbyServiceX.fromCode(e['service_code'] as String))
              .toList(),
          adaptabilityFeatures: adaptRows
              .map((e) => AdaptabilityX.fromCode(e['adapt_code'] as String))
              .toList(),
          extras: extraRows
              .map((e) => ExtraFeatureX.fromCode(e['extra_code'] as String))
              .toList(),
          createdAt: DateTime.parse(r['created_at'] as String),
        ),
      );
    }

    return out;
  }

  @override
  Future<void> deleteSearch(int id) async {
    await _db.delete('searches', where: 'id = ?', whereArgs: [id]);
  }
}
