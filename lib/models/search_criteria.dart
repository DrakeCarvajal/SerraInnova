import 'package:flutter/material.dart';

import 'enums.dart';

class SearchCriteria {
  SearchCriteria({
    this.id,
    required this.query,
    required this.operation,
    required this.priceMin,
    required this.priceMax,
    required this.bedroomsMin,
    required this.bedroomsMax,
    required this.m2Min,
    required this.m2Max,
    required this.energyRating, // selección única (para imitar checkboxes del mockup)
    required this.certifications,
    required this.nearbyServices,
    required this.extras,
    required this.adaptabilityFeatures,
    required this.createdAt,
    this.name,
  });

  final int? id;
  final String query; // barrio / zona
  final OperationType operation;

  final int priceMin;
  final int priceMax;

  final int bedroomsMin;
  final int bedroomsMax;

  final int m2Min;
  final int m2Max;

  final EnergyRating? energyRating; // null = indiferente

  final List<Certification> certifications;
  final List<NearbyService> nearbyServices;
  final List<Adaptability> adaptabilityFeatures;
  final List<ExtraFeature> extras;

  final DateTime createdAt;
  final String? name;

  RangeValues get priceRange =>
      RangeValues(priceMin.toDouble(), priceMax.toDouble());
  RangeValues get bedroomsRange =>
      RangeValues(bedroomsMin.toDouble(), bedroomsMax.toDouble());
  RangeValues get m2Range => RangeValues(m2Min.toDouble(), m2Max.toDouble());

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
