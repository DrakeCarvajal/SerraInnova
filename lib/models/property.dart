// lib/models/property.dart
import 'enums.dart';

class Property {
  Property({
    required this.id,
    required this.operation,
    required this.zone, // barrio/zona
    required this.typeLabel, // Piso, Ático, Casa...
    required this.price, // número (para filtrar)
    required this.bedrooms,
    required this.m2,
    required this.floor,
    required this.description,
    required this.energyRating,
    required this.certifications,
    required this.nearbyServices,
    required this.adaptabilityFeatures,
    required this.extras,
    this.imageUrl,
  });

  final int id;

  final OperationType operation;
  final String zone;

  final String typeLabel;
  final int price;
  final int bedrooms;
  final int m2;
  final int floor;

  final String description;

  final EnergyRating energyRating;
  final List<Certification> certifications;
  final List<NearbyService> nearbyServices;
  final List<Adaptability> adaptabilityFeatures;
  final List<ExtraFeature> extras;

  final String? imageUrl;

  String get title => '$typeLabel · $zone';

  String get priceLabel {
    if (operation == OperationType.alquilar) return '€$price/mes';
    return '€$price';
  }

  // Sin baños (como pediste)
  String get featuresLine => '$bedrooms hab · $m2 m² · ${floor}ª planta';

  /* Demo data */
  static List<Property> demo() => [
        // ---- ALQUILER ----
        Property(
          id: 101,
          operation: OperationType.alquilar,
          zone: 'Calle de Castellón, Russafa',
          typeLabel: 'Piso',
          price: 950,
          bedrooms: 2,
          m2: 74,
          floor: 3,
          energyRating: EnergyRating.B,
          certifications: [Certification.leed],
          nearbyServices: [NearbyService.metro, NearbyService.autobus],
          extras: [ExtraFeature.balconTerraza, ExtraFeature.ascensor],
          adaptabilityFeatures: [Adaptability.jovenes],
          imageUrl: 'https://picsum.photos/id/1067/800/600',
          description:
              'Piso reformado en Russafa, muy luminoso y con ventilación cruzada. '
              'A 5 minutos caminando de paradas de bus y con acceso rápido a metro. '
              'Carpintería con buen aislamiento y climatización eficiente. Ideal para parejas o profesionales.',
        ),
        Property(
          id: 102,
          operation: OperationType.alquilar,
          zone: 'Avenida del Puerto, Camins al Grau',
          typeLabel: 'Estudio',
          price: 720,
          bedrooms: 0,
          m2: 42,
          floor: 2,
          energyRating: EnergyRating.C,
          certifications: [],
          nearbyServices: [NearbyService.autobus],
          extras: [ExtraFeature.ascensor],
          adaptabilityFeatures: [Adaptability.jovenes],
          imageUrl: 'https://picsum.photos/id/1068/800/600',
          description:
              'Estudio funcional, amueblado y listo para entrar. Orientación agradable y buena luz natural. '
              'Zona con comercios, cafeterías y conexión directa al centro. Gastos de comunidad incluidos.',
        ),
        Property(
          id: 103,
          operation: OperationType.alquilar,
          zone: 'Calle de la Paz, Ciutat Vella',
          typeLabel: 'Piso',
          price: 1350,
          bedrooms: 3,
          m2: 98,
          floor: 4,
          energyRating: EnergyRating.A,
          certifications: [Certification.passivhaus],
          nearbyServices: [NearbyService.metro, NearbyService.centroMedico],
          extras: [ExtraFeature.ascensor, ExtraFeature.trastero],
          adaptabilityFeatures: [Adaptability.mayores],
          imageUrl: 'https://picsum.photos/id/1069/800/600',
          description:
              'Vivienda amplia en pleno centro, con acabados de alta eficiencia y confort térmico. '
              'Edificio con ascensor y accesos cómodos. Próxima a servicios sanitarios, comercios y transporte. '
              'Perfecta para familias o convivencia tranquila.',
        ),
        Property(
          id: 104,
          operation: OperationType.alquilar,
          zone: 'Calle de Dolores Marqués, Benimaclet',
          typeLabel: 'Piso',
          price: 890,
          bedrooms: 2,
          m2: 68,
          floor: 1,
          energyRating: EnergyRating.D,
          certifications: [Certification.breeam],
          nearbyServices: [NearbyService.metro, NearbyService.zonasVerdes],
          extras: [ExtraFeature.balconTerraza],
          adaptabilityFeatures: [
            Adaptability.jovenes,
            Adaptability.discapacitados
          ],
          imageUrl: 'https://picsum.photos/id/1070/800/600',
          description:
              'Piso acogedor en Benimaclet, barrio con vida y muy bien comunicado. '
              'Accesos sin escalones y distribución cómoda. Cercano a zonas verdes y con buen ambiente de barrio.',
        ),
        Property(
          id: 105,
          operation: OperationType.alquilar,
          zone: 'Calle de Quart, Extramurs',
          typeLabel: 'Piso',
          price: 1100,
          bedrooms: 3,
          m2: 92,
          floor: 2,
          energyRating: EnergyRating.B,
          certifications: [Certification.leed],
          nearbyServices: [NearbyService.autobus, NearbyService.centroMedico],
          extras: [ExtraFeature.garajeParking, ExtraFeature.ascensor],
          adaptabilityFeatures: [Adaptability.mayores],
          imageUrl: 'https://picsum.photos/id/1071/800/600',
          description:
              'Vivienda cómoda y bien distribuida en Extramurs. Plaza de parking incluida. '
              'Buena eficiencia energética y materiales de calidad. A un paso de servicios, centros médicos y supermercados.',
        ),

        // ---- COMPRA ----
        Property(
          id: 201,
          operation: OperationType.comprar,
          zone: 'Calle de la Reina, El Cabanyal',
          typeLabel: 'Piso',
          price: 219000,
          bedrooms: 2,
          m2: 78,
          floor: 2,
          energyRating: EnergyRating.C,
          certifications: [],
          nearbyServices: [NearbyService.autobus],
          extras: [ExtraFeature.balconTerraza],
          adaptabilityFeatures: [Adaptability.jovenes],
          imageUrl: 'https://picsum.photos/id/1072/800/600',
          description:
              'Piso con encanto en zona cercana al mar, ideal para vivir o invertir. '
              'Balcón exterior y estancias bien proporcionadas. Entorno con comercio local y buena conexión con el centro.',
        ),
        Property(
          id: 202,
          operation: OperationType.comprar,
          zone: 'Avenida de Blasco Ibáñez, Algirós',
          typeLabel: 'Piso',
          price: 265000,
          bedrooms: 3,
          m2: 96,
          floor: 5,
          energyRating: EnergyRating.B,
          certifications: [Certification.breeam],
          nearbyServices: [NearbyService.metro, NearbyService.autobus],
          extras: [ExtraFeature.piscina, ExtraFeature.trastero],
          adaptabilityFeatures: [Adaptability.jovenes, Adaptability.mayores],
          imageUrl: 'https://picsum.photos/id/1073/800/600',
          description: 'Piso amplio con ascensor y buena altura, muy luminoso. '
              'Excelente comunicación para universidad, centro y playa. '
              'Aislamiento mejorado y consumo eficiente, ideal para familias.',
        ),
        Property(
          id: 203,
          operation: OperationType.comprar,
          zone: 'Calle del Doctor Zamenhof, Campanar',
          typeLabel: 'Piso',
          price: 310000,
          bedrooms: 4,
          m2: 122,
          floor: 6,
          energyRating: EnergyRating.A,
          certifications: [Certification.leed, Certification.passivhaus],
          nearbyServices: [
            NearbyService.centroMedico,
            NearbyService.zonasVerdes
          ],
          extras: [ExtraFeature.garajeParking, ExtraFeature.ascensor],
          adaptabilityFeatures: [
            Adaptability.mayores,
            Adaptability.discapacitados
          ],
          imageUrl: 'https://picsum.photos/id/1074/800/600',
          description:
              'Vivienda de alta eficiencia (A) con gran confort térmico y bajo consumo. '
              'Edificio con accesibilidad cuidada y ascensor. Garaje incluido. '
              'Zona tranquila, con parques cercanos y servicios esenciales.',
        ),
        Property(
          id: 204,
          operation: OperationType.comprar,
          zone: 'Calle de Jerónimo Muñoz, Quatre Carreres',
          typeLabel: 'Ático',
          price: 395000,
          bedrooms: 3,
          m2: 105,
          floor: 8,
          energyRating: EnergyRating.B,
          certifications: [Certification.leed],
          nearbyServices: [NearbyService.metro, NearbyService.zonasVerdes],
          extras: [
            ExtraFeature.balconTerraza,
            ExtraFeature.piscina,
            ExtraFeature.garajeParking
          ],
          adaptabilityFeatures: [Adaptability.jovenes],
          imageUrl: 'https://picsum.photos/id/1075/800/600',
          description:
              'Ático con terraza y zonas comunes, muy cerca de áreas verdes. '
              'Distribución moderna, buen aislamiento y acabados actuales. '
              'Ideal si buscas luz, vistas y espacios exteriores.',
        ),
        Property(
          id: 205,
          operation: OperationType.comprar,
          zone: 'Calle de Sagunto, La Saïdia',
          typeLabel: 'Piso',
          price: 179000,
          bedrooms: 2,
          m2: 67,
          floor: 1,
          energyRating: EnergyRating.D,
          certifications: [],
          nearbyServices: [NearbyService.autobus, NearbyService.centroMedico],
          extras: [ExtraFeature.trastero],
          adaptabilityFeatures: [Adaptability.mayores],
          imageUrl: 'https://picsum.photos/id/1076/800/600',
          description:
              'Piso práctico y bien ubicado en La Saïdia, perfecto para primera vivienda. '
              'Cercano a servicios sanitarios y transporte. Buen potencial de mejora para eficiencia energética.',
        ),
      ];

  /*
  static List<Property> demo() => [
        Property(
          id: 1,
          operation: OperationType.alquilar,
          zone: 'Centro',
          typeLabel: 'Piso',
          price: 850,
          bedrooms: 2,
          m2: 70,
          floor: 3,
          description:
              'Luminoso, bien comunicado y con buena eficiencia energética.',
          energyRating: EnergyRating.B,
          certifications: [Certification.leed],
          nearbyServices: [NearbyService.metro, NearbyService.autobus],
          adaptabilityFeatures: [
            Adaptability.jovenes,
            Adaptability.discapacitados
          ],
          extras: [ExtraFeature.balconTerraza],
        ),
        Property(
          id: 2,
          operation: OperationType.alquilar,
          zone: 'Norte',
          typeLabel: 'Ático',
          price: 1250,
          bedrooms: 3,
          m2: 95,
          floor: 5,
          description:
              'Terraza amplia, zonas verdes cercanas y acabados sostenibles.',
          energyRating: EnergyRating.A,
          certifications: [Certification.breeam, Certification.leed],
          nearbyServices: [NearbyService.zonasVerdes, NearbyService.autobus],
          adaptabilityFeatures: [Adaptability.jovenes],
          extras: [ExtraFeature.balconTerraza, ExtraFeature.garajeParking],
        ),
        Property(
          id: 3,
          operation: OperationType.comprar,
          zone: 'Sur',
          typeLabel: 'Casa',
          price: 215000,
          bedrooms: 4,
          m2: 140,
          floor: 0,
          description:
              'Vivienda con alta eficiencia y buen aislamiento térmico.',
          energyRating: EnergyRating.C,
          certifications: [Certification.passivhaus],
          nearbyServices: [NearbyService.centroMedico],
          adaptabilityFeatures: [
            Adaptability.mayores,
            Adaptability.discapacitados
          ],
          extras: [ExtraFeature.garajeParking, ExtraFeature.piscina],
        ),
      ];
  */
}
