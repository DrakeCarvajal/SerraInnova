enum OperationType { comprar, alquilar }

extension OperationTypeX on OperationType {
  String get label => switch (this) {
        OperationType.comprar => 'Comprar',
        OperationType.alquilar => 'Alquilar',
      };

  String get code => switch (this) {
        OperationType.comprar => 'COMPRA',
        OperationType.alquilar => 'ALQUILER',
      };

  static OperationType fromCode(String code) => switch (code.toUpperCase()) {
        'COMPRA' => OperationType.comprar,
        'ALQUILER' => OperationType.alquilar,
        _ => OperationType.alquilar,
      };
}

enum EnergyRating { A, B, C, D, E, F, G }

extension EnergyRatingX on EnergyRating {
  String get code => switch (this) {
        EnergyRating.A => 'A',
        EnergyRating.B => 'B',
        EnergyRating.C => 'C',
        EnergyRating.D => 'D',
        EnergyRating.E => 'E',
        EnergyRating.F => 'F',
        EnergyRating.G => 'G',
      };

  static EnergyRating fromCode(String code) => switch (code.toUpperCase()) {
        'A' => EnergyRating.A,
        'B' => EnergyRating.B,
        'C' => EnergyRating.C,
        'D' => EnergyRating.D,
        'E' => EnergyRating.E,
        'F' => EnergyRating.F,
        'G' => EnergyRating.G,
        _ => EnergyRating.G,
      };
}

enum Certification { leed, breeam, passivhaus }

extension CertificationX on Certification {
  String get label => switch (this) {
        Certification.leed => 'LEED',
        Certification.breeam => 'BREEAM',
        Certification.passivhaus => 'Passivhaus',
      };

  String get code => switch (this) {
        Certification.leed => 'LEED',
        Certification.breeam => 'BREEAM',
        Certification.passivhaus => 'PASSIVHAUS',
      };

  static Certification fromCode(String code) => switch (code.toUpperCase()) {
        'LEED' => Certification.leed,
        'BREEAM' => Certification.breeam,
        'PASSIVHAUS' => Certification.passivhaus,
        _ => Certification.leed,
      };
}

enum NearbyService { autobus, metro, tranvia, zonasVerdes, centroMedico }

extension NearbyServiceX on NearbyService {
  String get label => switch (this) {
        NearbyService.autobus => 'Autobús',
        NearbyService.metro => 'Metro',
        NearbyService.tranvia => 'Tranvía',
        NearbyService.zonasVerdes => 'Zonas verdes',
        NearbyService.centroMedico => 'Centro médico',
      };

  String get code => switch (this) {
        NearbyService.autobus => 'BUS',
        NearbyService.metro => 'METRO',
        NearbyService.tranvia => 'TRANVIA',
        NearbyService.zonasVerdes => 'ZONAS_VERDES',
        NearbyService.centroMedico => 'CENTRO_MEDICO',
      };

  static NearbyService fromCode(String code) => switch (code.toUpperCase()) {
        'BUS' => NearbyService.autobus,
        'METRO' => NearbyService.metro,
        'TRANVIA' => NearbyService.tranvia,
        'ZONAS_VERDES' => NearbyService.zonasVerdes,
        'CENTRO_MEDICO' => NearbyService.centroMedico,
        _ => NearbyService.autobus,
      };
}

enum Adaptability { jovenes, mayores, discapacitados }

extension AdaptabilityX on Adaptability {
  String get label => switch (this) {
        Adaptability.jovenes => 'Jóvenes',
        Adaptability.mayores => 'Mayores',
        Adaptability.discapacitados => 'Discapacitados',
      };

  String get code => switch (this) {
        Adaptability.jovenes => 'JOVENES',
        Adaptability.mayores => 'MAYORES',
        Adaptability.discapacitados => 'DISCAPACITADOS',
      };

  static Adaptability fromCode(String code) => switch (code.toUpperCase()) {
        'JOVENES' => Adaptability.jovenes,
        'MAYORES' => Adaptability.mayores,
        'DISCAPACITADOS' => Adaptability.discapacitados,
        _ => Adaptability.jovenes,
      };
}

enum ExtraFeature { balconTerraza, garajeParking, trastero, piscina, ascensor }

extension ExtraFeatureX on ExtraFeature {
  String get label => switch (this) {
        ExtraFeature.balconTerraza => 'Balcón/Terraza',
        ExtraFeature.garajeParking => 'Garaje/Parking',
        ExtraFeature.trastero => 'Trastero',
        ExtraFeature.piscina => 'Piscina',
        ExtraFeature.ascensor => 'Ascensor',
      };

  String get code => switch (this) {
        ExtraFeature.balconTerraza => 'BALCON_TERRAZA',
        ExtraFeature.garajeParking => 'GARAJE_PARKING',
        ExtraFeature.trastero => 'TRASTERO',
        ExtraFeature.piscina => 'PISCINA',
        ExtraFeature.ascensor => 'ASCENSOR',
      };

  static ExtraFeature fromCode(String code) => switch (code.toUpperCase()) {
        'BALCON_TERRAZA' => ExtraFeature.balconTerraza,
        'GARAJE_PARKING' => ExtraFeature.garajeParking,
        'TRASTERO' => ExtraFeature.trastero,
        'PISCINA' => ExtraFeature.piscina,
        'ASCENSOR' => ExtraFeature.ascensor,
        _ => ExtraFeature.trastero,
      };
}
