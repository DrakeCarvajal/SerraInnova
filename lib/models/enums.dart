// Enums para los distintos tipos usados en la aplicación.
// Archivo: lib/models/enums.dart

// Tipo de operación: comprar o alquilar.
enum OperationType { comprar, alquilar }

// Extensiones para "OperationType" que proveen utilidades adicionales.
extension OperationTypeX on OperationType {
  // Etiqueta legible para mostrar en la UI.
  String get label => switch (this) {
        OperationType.comprar => 'Comprar',
        OperationType.alquilar => 'Alquilar',
      };

  // Código usado en la base de datos o API (valor constante).
  String get code => switch (this) {
        OperationType.comprar => 'COMPRA',
        OperationType.alquilar => 'ALQUILER',
      };

  // Crear "OperationType" a partir de un código (case-insensitive).
  // Si el código no coincide, se devuelve "alquilar" por defecto.
  static OperationType fromCode(String code) => switch (code.toUpperCase()) {
        'COMPRA' => OperationType.comprar,
        'ALQUILER' => OperationType.alquilar,
        _ => OperationType.alquilar,
      };
}

// Clasificación energética de la propiedad.
// Valores desde A (mejor) hasta G (peor).
enum EnergyRating { A, B, C, D, E, F, G }

// Extensiones para "EnergyRating" para convertir a/desde códigos.
extension EnergyRatingX on EnergyRating {
  // Código textual de la categoría (misma letra).
  String get code => switch (this) {
        EnergyRating.A => 'A',
        EnergyRating.B => 'B',
        EnergyRating.C => 'C',
        EnergyRating.D => 'D',
        EnergyRating.E => 'E',
        EnergyRating.F => 'F',
        EnergyRating.G => 'G',
      };

  // Crear "EnergyRating" desde un código. Si no coincide, devuelve "G".
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

// Certificaciones de la propiedad (ej.: LEED, BREEAM).
enum Certification { leed, breeam, passivhaus }

// Extensiones para "Certification" con etiqueta y código.
extension CertificationX on Certification {
  // Etiqueta legible para mostrar en la UI.
  String get label => switch (this) {
        Certification.leed => 'LEED',
        Certification.breeam => 'BREEAM',
        Certification.passivhaus => 'Passivhaus',
      };

  // Código usado en API/DB.
  String get code => switch (this) {
        Certification.leed => 'LEED',
        Certification.breeam => 'BREEAM',
        Certification.passivhaus => 'PASSIVHAUS',
      };

  // Crear "Certification" desde un código (case-insensitive).
  // Si no coincide, devuelve "leed" por defecto.
  static Certification fromCode(String code) => switch (code.toUpperCase()) {
        'LEED' => Certification.leed,
        'BREEAM' => Certification.breeam,
        'PASSIVHAUS' => Certification.passivhaus,
        _ => Certification.leed,
      };
}

// Servicios cercanos a la propiedad (transporte, salud, parques...).
enum NearbyService { autobus, metro, tranvia, zonasVerdes, centroMedico }

// Extensiones para "NearbyService" con etiqueta y código.
extension NearbyServiceX on NearbyService {
  // Etiqueta legible para la UI.
  String get label => switch (this) {
        NearbyService.autobus => 'Autobús',
        NearbyService.metro => 'Metro',
        NearbyService.tranvia => 'Tranvía',
        NearbyService.zonasVerdes => 'Zonas verdes',
        NearbyService.centroMedico => 'Centro médico',
      };

  // Código usado en almacenamiento/servicios externos.
  String get code => switch (this) {
        NearbyService.autobus => 'BUS',
        NearbyService.metro => 'METRO',
        NearbyService.tranvia => 'TRANVIA',
        NearbyService.zonasVerdes => 'ZONAS_VERDES',
        NearbyService.centroMedico => 'CENTRO_MEDICO',
      };

  // Crear "NearbyService" desde un código (case-insensitive).
  // Por defecto devuelve "autobus".
  static NearbyService fromCode(String code) => switch (code.toUpperCase()) {
        'BUS' => NearbyService.autobus,
        'METRO' => NearbyService.metro,
        'TRANVIA' => NearbyService.tranvia,
        'ZONAS_VERDES' => NearbyService.zonasVerdes,
        'CENTRO_MEDICO' => NearbyService.centroMedico,
        _ => NearbyService.autobus,
      };
}

// Adaptabilidad: público objetivo/adecuación de la vivienda.
enum Adaptability { jovenes, mayores, discapacitados }

// Extensiones para "Adaptability" con label, code y creador desde código.
extension AdaptabilityX on Adaptability {
  // Etiqueta legible.
  String get label => switch (this) {
        Adaptability.jovenes => 'Jóvenes',
        Adaptability.mayores => 'Mayores',
        Adaptability.discapacitados => 'Discapacitados',
      };

  // Código para persistencia/transferencia.
  String get code => switch (this) {
        Adaptability.jovenes => 'JOVENES',
        Adaptability.mayores => 'MAYORES',
        Adaptability.discapacitados => 'DISCAPACITADOS',
      };

  // Crear "Adaptability" desde un código. Por defecto "jovenes".
  static Adaptability fromCode(String code) => switch (code.toUpperCase()) {
        'JOVENES' => Adaptability.jovenes,
        'MAYORES' => Adaptability.mayores,
        'DISCAPACITADOS' => Adaptability.discapacitados,
        _ => Adaptability.jovenes,
      };
}

// Características adicionales de la propiedad (balcón, garaje, piscina...).
enum ExtraFeature { balconTerraza, garajeParking, trastero, piscina, ascensor }

// Extensiones para "ExtraFeature".
extension ExtraFeatureX on ExtraFeature {
  // Etiqueta legible para mostrar al usuario.
  String get label => switch (this) {
        ExtraFeature.balconTerraza => 'Balcón/Terraza',
        ExtraFeature.garajeParking => 'Garaje/Parking',
        ExtraFeature.trastero => 'Trastero',
        ExtraFeature.piscina => 'Piscina',
        ExtraFeature.ascensor => 'Ascensor',
      };

  // Código constante para API/DB.
  String get code => switch (this) {
        ExtraFeature.balconTerraza => 'BALCON_TERRAZA',
        ExtraFeature.garajeParking => 'GARAJE_PARKING',
        ExtraFeature.trastero => 'TRASTERO',
        ExtraFeature.piscina => 'PISCINA',
        ExtraFeature.ascensor => 'ASCENSOR',
      };

  // Crear "ExtraFeature" desde un código (case-insensitive).
  // Por defecto devuelve "trastero".
  static ExtraFeature fromCode(String code) => switch (code.toUpperCase()) {
        'BALCON_TERRAZA' => ExtraFeature.balconTerraza,
        'GARAJE_PARKING' => ExtraFeature.garajeParking,
        'TRASTERO' => ExtraFeature.trastero,
        'PISCINA' => ExtraFeature.piscina,
        'ASCENSOR' => ExtraFeature.ascensor,
        _ => ExtraFeature.trastero,
      };
}
