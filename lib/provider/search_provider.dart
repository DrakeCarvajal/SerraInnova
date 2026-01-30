import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/search_criteria.dart';
import 'search_storage.dart';

/// Provider principal del módulo de búsqueda.
/// Mantiene el estado de:
/// - barra superior (query + operación)
/// - filtros (rangos, selección única, selecciones múltiples)
/// - validación (mapa de errores por campo)
/// - persistencia de búsquedas guardadas (lista + CRUD vía SearchStorage)
class SearchProvider extends ChangeNotifier {
  /// Recibe una implementación de SearchStorage (SQLite o SharedPreferences).
  SearchProvider(this._db);

  final SearchStorage _db;

  // --- Barra superior / landing ---

  /// Texto de búsqueda por barrio/zona. Vacío => no filtra por texto.
  String query = '';

  /// Operación elegida (comprar o alquilar). Se usa como filtro base del catálogo.
  OperationType operation = OperationType.alquilar;

  // --- Rangos y límites permitidos (sliders) ---

  /// Límites dinámicos del slider de precio (calculados según resultados base).
  int priceMinAllowed = 0;
  int priceMaxAllowed = 5000;

  /// Rango actual seleccionado por el usuario.
  int priceMin = 0;
  int priceMax = 5000;

  /// Límites y rango para habitaciones (0 = estudio).
  int bedroomsMinAllowed = 0;
  int bedroomsMaxAllowed = 10;

  int bedroomsMin = 0;
  int bedroomsMax = 10;

  /// Límites y rango para superficie.
  int m2MinAllowed = 10;
  int m2MaxAllowed = 500;

  int m2Min = 10;
  int m2Max = 500;

  // --- Selección energética (única) ---

  /// Calificación energética seleccionada. Null significa "indiferente".
  EnergyRating? energyRating;

  // --- Selecciones múltiples (checkboxes) ---

  /// Sets para almacenar selecciones sin duplicados.
  /// Luego se convierten a lista al construir SearchCriteria.
  final Set<Certification> certifications = {};
  final Set<NearbyService> nearbyServices = {};
  final Set<Adaptability> adaptabilityFeatures = {};
  final Set<ExtraFeature> extras = {};

  // --- Adaptado para (legacy) ---
  // Estos booleans ya no son necesarios si estás usando adaptabilityFeatures,
  // pero se mantienen aquí si alguna parte del proyecto todavía los referencia.
  bool targetYoung = false;
  bool targetOlder = false;
  bool targetDisabled = false;

  // --- Validación ---

  /// Errores por campo para mostrarlos junto al filtro correspondiente.
  final Map<String, String?> errors = {};

  // --- Persistencia ---

  /// Lista en memoria de búsquedas guardadas (se alimenta desde el storage).
  List<SearchCriteria> saved = [];

  // --- setters / mutadores ---

  /// Actualiza el texto de búsqueda.
  void setQuery(String v) {
    query = v;
    notifyListeners();
  }

  /// Actualiza la operación (comprar/alquilar).
  void setOperation(OperationType v) {
    operation = v;
    notifyListeners();
  }

  /// Actualiza rango de precio y valida inmediatamente.
  void setPriceRange(RangeValues r) {
    priceMin = r.start.round();
    priceMax = r.end.round();
    _validateRange(
      'price',
      priceMin,
      priceMax,
      minAllowed: priceMinAllowed,
      maxAllowed: priceMaxAllowed,
    );
    notifyListeners();
  }

  /// Actualiza rango de habitaciones y valida inmediatamente.
  void setBedroomsRange(RangeValues r) {
    bedroomsMin = r.start.round();
    bedroomsMax = r.end.round();
    _validateRange(
      'bedrooms',
      bedroomsMin,
      bedroomsMax,
      minAllowed: bedroomsMinAllowed,
      maxAllowed: bedroomsMaxAllowed,
    );
    notifyListeners();
  }

  /// Actualiza rango de m² y valida. minStrict fuerza a que el mínimo sea > 0.
  void setM2Range(RangeValues r) {
    m2Min = r.start.round();
    m2Max = r.end.round();
    _validateRange(
      'm2',
      m2Min,
      m2Max,
      minAllowed: m2MinAllowed,
      maxAllowed: m2MaxAllowed,
      minStrict: true,
    );
    notifyListeners();
  }

  /// Activa/desactiva una certificación (checkbox).
  void toggleCertification(Certification c) {
    certifications.contains(c)
        ? certifications.remove(c)
        : certifications.add(c);
    notifyListeners();
  }

  /// Activa/desactiva un servicio cercano (checkbox).
  void toggleService(NearbyService s) {
    nearbyServices.contains(s)
        ? nearbyServices.remove(s)
        : nearbyServices.add(s);
    notifyListeners();
  }

  /// Activa/desactiva un filtro de adaptabilidad (checkbox).
  void toggleAdaptability(Adaptability a) {
    adaptabilityFeatures.contains(a)
        ? adaptabilityFeatures.remove(a)
        : adaptabilityFeatures.add(a);
    notifyListeners();
  }

  /// Activa/desactiva un extra (checkbox).
  void toggleExtra(ExtraFeature e) {
    extras.contains(e) ? extras.remove(e) : extras.add(e);
    notifyListeners();
  }

  /// Selección única: si se vuelve a tocar la misma letra, se desmarca.
  void toggleEnergy(EnergyRating e) {
    energyRating = (energyRating == e) ? null : e;
    notifyListeners();
  }

  /// Ajusta límites permitidos de los sliders según el "conjunto base" de resultados.
  /// También normaliza el rango actual (full-range o clamp) y revalida.
  void setAllowedBounds({
    required int priceMinA,
    required int priceMaxA,
    required int bedroomsMinA,
    required int bedroomsMaxA,
    required int m2MinA,
    required int m2MaxA,
  }) {
    // Evita estados inválidos.
    if (priceMaxA < priceMinA) return;
    if (bedroomsMaxA < bedroomsMinA) return;
    if (m2MaxA < m2MinA) return;

    final oldPriceMinA = priceMinAllowed;
    final oldPriceMaxA = priceMaxAllowed;
    final oldBedMinA = bedroomsMinAllowed;
    final oldBedMaxA = bedroomsMaxAllowed;
    final oldM2MinA = m2MinAllowed;
    final oldM2MaxA = m2MaxAllowed;

    final changed = oldPriceMinA != priceMinA ||
        oldPriceMaxA != priceMaxA ||
        oldBedMinA != bedroomsMinA ||
        oldBedMaxA != bedroomsMaxA ||
        oldM2MinA != m2MinA ||
        oldM2MaxA != m2MaxA;

    if (!changed) return;

    // Actualiza allowed bounds.
    priceMinAllowed = priceMinA;
    priceMaxAllowed = priceMaxA;
    bedroomsMinAllowed = bedroomsMinA;
    bedroomsMaxAllowed = bedroomsMaxA;
    m2MinAllowed = m2MinA;
    m2MaxAllowed = m2MaxA;

    // Ajusta los rangos actuales para que sigan siendo válidos con los nuevos límites.
    void adjustRange({
      required int oldAllowedMin,
      required int oldAllowedMax,
      required int newAllowedMin,
      required int newAllowedMax,
      required int currentMin,
      required int currentMax,
      required void Function(int, int) set,
    }) {
      final wasFullOld =
          (currentMin == oldAllowedMin && currentMax == oldAllowedMax);
      if (wasFullOld) {
        set(newAllowedMin, newAllowedMax);
        return;
      }
      final clampedMin = currentMin.clamp(newAllowedMin, newAllowedMax);
      final clampedMax = currentMax.clamp(newAllowedMin, newAllowedMax);
      set(clampedMin, clampedMax);
    }

    adjustRange(
      oldAllowedMin: oldPriceMinA,
      oldAllowedMax: oldPriceMaxA,
      newAllowedMin: priceMinAllowed,
      newAllowedMax: priceMaxAllowed,
      currentMin: priceMin,
      currentMax: priceMax,
      set: (a, b) {
        priceMin = a;
        priceMax = b;
      },
    );

    adjustRange(
      oldAllowedMin: oldBedMinA,
      oldAllowedMax: oldBedMaxA,
      newAllowedMin: bedroomsMinAllowed,
      newAllowedMax: bedroomsMaxAllowed,
      currentMin: bedroomsMin,
      currentMax: bedroomsMax,
      set: (a, b) {
        bedroomsMin = a;
        bedroomsMax = b;
      },
    );

    adjustRange(
      oldAllowedMin: oldM2MinA,
      oldAllowedMax: oldM2MaxA,
      newAllowedMin: m2MinAllowed,
      newAllowedMax: m2MaxAllowed,
      currentMin: m2Min,
      currentMax: m2Max,
      set: (a, b) {
        m2Min = a;
        m2Max = b;
      },
    );

    _validateAllRanges();
    notifyListeners();
  }

  /// Restaura filtros a su estado por defecto.
  /// No reinicia operation porque se decidió que el reset no afecte a comprar/alquilar.
  void resetAll() {
    query = '';

    priceMin = priceMinAllowed;
    priceMax = priceMaxAllowed;

    bedroomsMin = bedroomsMinAllowed;
    bedroomsMax = bedroomsMaxAllowed;

    m2Min = m2MinAllowed;
    m2Max = m2MaxAllowed;

    energyRating = null;

    certifications.clear();
    nearbyServices.clear();
    extras.clear();

    // Si estás usando adaptabilityFeatures, conviene también limpiarlo.
    adaptabilityFeatures.clear();

    targetYoung = false;
    targetOlder = false;
    targetDisabled = false;

    errors.clear();
    notifyListeners();
  }

  // --- Construcción de criterios / persistencia ---

  /// Genera un SearchCriteria a partir del estado actual del provider.
  SearchCriteria buildCriteria({String? name}) {
    return SearchCriteria(
      name: name,
      query: query.trim(),
      operation: operation,
      priceMin: priceMin,
      priceMax: priceMax,
      bedroomsMin: bedroomsMin,
      bedroomsMax: bedroomsMax,
      m2Min: m2Min,
      m2Max: m2Max,
      energyRating: energyRating,
      certifications: certifications.toList(),
      nearbyServices: nearbyServices.toList(),
      adaptabilityFeatures: adaptabilityFeatures.toList(),
      extras: extras.toList(),
      createdAt: DateTime.now(),
    );
  }

  /// Valida rangos (útil si alguna pantalla necesita comprobar antes de aplicar/guardar).
  bool validateForApply() {
    final ok = _validateAllRanges();
    notifyListeners();
    return ok;
  }

  /// Valida nombre y rangos antes de permitir guardar la búsqueda.
  bool validateForSave(String name) {
    final okRanges = _validateAllRanges();

    if (name.trim().length < 3 || name.trim().length > 30) {
      errors['name'] = 'El nombre debe tener 3–30 caracteres.';
    } else {
      errors.remove('name');
    }

    notifyListeners();
    return okRanges && errors['name'] == null;
  }

  /// Guarda el criterio actual en el storage y recarga la lista.
  Future<void> saveSearch(String name) async {
    if (!validateForSave(name)) return;
    await _db.insertSearch(buildCriteria(name: name.trim()));
    await loadSavedSearches();
  }

  /// Recarga la lista desde el storage para refrescar la UI.
  Future<void> loadSavedSearches() async {
    saved = await _db.listSearches();
    notifyListeners();
  }

  /// Borra una búsqueda por id y recarga la lista.
  Future<void> deleteSaved(int id) async {
    await _db.deleteSearch(id);
    await loadSavedSearches();
  }

  /// Carga un SearchCriteria guardado dentro del estado del provider (restaura filtros).
  void loadIntoForm(SearchCriteria c) {
    query = c.query;
    operation = c.operation;

    priceMin = c.priceMin;
    priceMax = c.priceMax;

    bedroomsMin = c.bedroomsMin;
    bedroomsMax = c.bedroomsMax;

    m2Min = c.m2Min;
    m2Max = c.m2Max;

    energyRating = c.energyRating;

    certifications
      ..clear()
      ..addAll(c.certifications);

    nearbyServices
      ..clear()
      ..addAll(c.nearbyServices);

    adaptabilityFeatures
      ..clear()
      ..addAll(c.adaptabilityFeatures);

    extras
      ..clear()
      ..addAll(c.extras);

    errors.clear();
    notifyListeners();
  }

  // --- Validación interna ---

  /// Valida todos los rangos y mantiene el mapa errors actualizado.
  bool _validateAllRanges() {
    final a = _validateRange(
      'price',
      priceMin,
      priceMax,
      minAllowed: priceMinAllowed,
      maxAllowed: priceMaxAllowed,
    );
    final b = _validateRange(
      'bedrooms',
      bedroomsMin,
      bedroomsMax,
      minAllowed: bedroomsMinAllowed,
      maxAllowed: bedroomsMaxAllowed,
    );
    final c = _validateRange(
      'm2',
      m2Min,
      m2Max,
      minAllowed: m2MinAllowed,
      maxAllowed: m2MaxAllowed,
      minStrict: true,
    );
    return a && b && c;
  }

  /// Valida un rango min/max y genera un mensaje de error si no es válido.
  bool _validateRange(
    String key,
    int minVal,
    int maxVal, {
    required int minAllowed,
    required int maxAllowed,
    bool minStrict = false,
  }) {
    if (minVal > maxVal) {
      errors[key] = 'El mínimo no puede ser mayor que el máximo.';
      return false;
    }
    if (minStrict ? minVal <= 0 : minVal < minAllowed) {
      errors[key] = 'El valor mínimo no es válido.';
      return false;
    }
    if (maxVal > maxAllowed) {
      errors[key] = 'El valor máximo no es válido.';
      return false;
    }
    errors.remove(key);
    return true;
  }
}
