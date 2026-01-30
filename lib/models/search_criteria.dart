import 'package:flutter/material.dart';

import 'enums.dart';

/// Modelo que representa el estado completo de una búsqueda guardada.
/// Se usa para:
/// - reconstruir filtros (cuando el usuario carga una búsqueda)
/// - persistir en SQLite/Prefs (toJson/fromJson)
/// - mostrar un resumen corto en la lista de guardados (summaryLine)
class SearchCriteria {
  SearchCriteria({
    this.id, // id asignado por SQLite (null si aún no se ha guardado)
    required this.query, // texto de búsqueda por zona/barrio
    required this.operation, // comprar o alquilar
    required this.priceMin,
    required this.priceMax,
    required this.bedroomsMin,
    required this.bedroomsMax,
    required this.m2Min,
    required this.m2Max,
    required this.energyRating, // selección única; null significa "indiferente"
    required this.certifications, // selección múltiple
    required this.nearbyServices, // selección múltiple
    required this.extras, // selección múltiple
    required this.adaptabilityFeatures, // selección múltiple
    required this.createdAt, // fecha de creación para ordenar guardados
    this.name, // nombre opcional asignado por el usuario al guardar
  });

  /// Identificador de la búsqueda en la BD.
  final int? id;

  /// Texto libre usado por el buscador (zona/barrio).
  final String query;

  /// Operación a filtrar: compra o alquiler.
  final OperationType operation;

  /// Rangos numéricos usados por sliders.
  final int priceMin;
  final int priceMax;
  final int bedroomsMin;
  final int bedroomsMax;
  final int m2Min;
  final int m2Max;

  /// Calificación energética elegida (A-G). Si es null, no filtra por energía.
  final EnergyRating? energyRating;

  /// Listas de filtros multiselección (checkboxes).
  final List<Certification> certifications;
  final List<NearbyService> nearbyServices;
  final List<Adaptability> adaptabilityFeatures;
  final List<ExtraFeature> extras;

  /// Metadatos de la búsqueda guardada.
  final DateTime createdAt;
  final String? name;

  /// Helpers para conectar con widgets de tipo RangeSlider (requieren doubles).
  RangeValues get priceRange =>
      RangeValues(priceMin.toDouble(), priceMax.toDouble());
  RangeValues get bedroomsRange =>
      RangeValues(bedroomsMin.toDouble(), bedroomsMax.toDouble());
  RangeValues get m2Range => RangeValues(m2Min.toDouble(), m2Max.toDouble());

  /// Resumen compacto para mostrar en la lista de "Búsquedas guardadas".
  /// No enumera cada filtro, solo da una idea rápida de lo seleccionado.
  String summaryLine() {
    final parts = <String>[
      operation.label,
      if (query.trim().isNotEmpty) 'Zona: $query',
      '€$priceMin–€$priceMax',
      '${bedroomsMin}–${bedroomsMax} hab',
      '${m2Min}–${m2Max} m²',
      if (energyRating != null) 'Energía ${energyRating!.code}',
      if (certifications.isNotEmpty) '${certifications.length} cert',
      if (nearbyServices.isNotEmpty) '${nearbyServices.length} cerca',
      if (extras.isNotEmpty) '${extras.length} extras',
    ];
    return parts.join(' · ');
  }

  /// Serialización genérica (útil para Preferences o como formato intermedio).
  /// Se guardan enums mediante sus códigos estables (code) para no depender del orden del enum.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'query': query,
      'operation': operation.code,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'bedroomsMin': bedroomsMin,
      'bedroomsMax': bedroomsMax,
      'm2Min': m2Min,
      'm2Max': m2Max,
      'energyRating': energyRating?.code,
      'certifications': certifications.map((e) => e.code).toList(),
      'nearbyServices': nearbyServices.map((e) => e.code).toList(),
      'extras': extras.map((e) => e.code).toList(),
      'adaptability': adaptabilityFeatures.map((e) => e.code).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Deserialización: reconstruye el criterio convirtiendo códigos a enums.
  /// Incluye valores por defecto para evitar fallos si faltan campos.
  static SearchCriteria fromJson(Map<String, dynamic> j) {
    return SearchCriteria(
      id: j['id'] as int?,
      name: j['name'] as String?,
      query: (j['query'] as String?) ?? '',
      operation:
          OperationTypeX.fromCode((j['operation'] as String?) ?? 'ALQUILER'),
      priceMin: (j['priceMin'] as num?)?.toInt() ?? 0,
      priceMax: (j['priceMax'] as num?)?.toInt() ?? 0,
      bedroomsMin: (j['bedroomsMin'] as num?)?.toInt() ?? 0,
      bedroomsMax: (j['bedroomsMax'] as num?)?.toInt() ?? 0,
      m2Min: (j['m2Min'] as num?)?.toInt() ?? 0,
      m2Max: (j['m2Max'] as num?)?.toInt() ?? 0,
      energyRating: (j['energyRating'] as String?) == null
          ? null
          : EnergyRatingX.fromCode(j['energyRating'] as String),
      certifications: ((j['certifications'] as List?) ?? const [])
          .map((e) => CertificationX.fromCode(e as String))
          .toList(),
      nearbyServices: ((j['nearbyServices'] as List?) ?? const [])
          .map((e) => NearbyServiceX.fromCode(e as String))
          .toList(),
      extras: ((j['extras'] as List?) ?? const [])
          .map((e) => ExtraFeatureX.fromCode(e as String))
          .toList(),
      adaptabilityFeatures: ((j['adaptability'] as List?) ?? const [])
          .map((e) => AdaptabilityX.fromCode(e as String))
          .toList(),
      createdAt: DateTime.tryParse((j['createdAt'] as String?) ?? '') ??
          DateTime.now(),
    );
  }
}
