import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/search_criteria.dart';
import 'search_storage.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider(this._db);

  final SearchStorage _db;

  // --- Barra superior / landing ---
  String query = '';
  OperationType operation = OperationType.alquilar;

  // --- Filtros izquierda ---
  // Ajusta límites a tu inventario si lo tienes
  int priceMinAllowed = 0;
  int priceMaxAllowed = 5000;

  int priceMin = 0;
  int priceMax = 5000;

  int bedroomsMinAllowed = 0; // 0 = estudio
  int bedroomsMaxAllowed = 10;

  int bedroomsMin = 0;
  int bedroomsMax = 10;

  int m2MinAllowed = 10;
  int m2MaxAllowed = 500;

  int m2Min = 10;
  int m2Max = 500;

  // selección única (para imitar checkboxes A..G)
  EnergyRating? energyRating; // null = indiferente

  final Set<Certification> certifications = {};
  final Set<NearbyService> nearbyServices = {};
  final Set<Adaptability> adaptabilityFeatures = {};
  final Set<ExtraFeature> extras = {};

  // Adaptado para (checkboxes)
  bool targetYoung = false;
  bool targetOlder = false;
  bool targetDisabled = false;

  // errores por campo (para mostrar junto al filtro si lo deseas)
  final Map<String, String?> errors = {};

  // búsquedas guardadas
  List<SearchCriteria> saved = [];

  // --- setters ---
  void setQuery(String v) {
    query = v;
    notifyListeners();
  }

  void setOperation(OperationType v) {
    operation = v;
    notifyListeners();
  }

  void setPriceRange(RangeValues r) {
    priceMin = r.start.round();
    priceMax = r.end.round();
    _validateRange('price', priceMin, priceMax,
        minAllowed: priceMinAllowed, maxAllowed: priceMaxAllowed);
    notifyListeners();
  }

  void setBedroomsRange(RangeValues r) {
    bedroomsMin = r.start.round();
    bedroomsMax = r.end.round();
    _validateRange('bedrooms', bedroomsMin, bedroomsMax,
        minAllowed: bedroomsMinAllowed, maxAllowed: bedroomsMaxAllowed);
    notifyListeners();
  }

  void setM2Range(RangeValues r) {
    m2Min = r.start.round();
    m2Max = r.end.round();
    _validateRange('m2', m2Min, m2Max,
        minAllowed: m2MinAllowed, maxAllowed: m2MaxAllowed, minStrict: true);
    notifyListeners();
  }

  void toggleCertification(Certification c) {
    certifications.contains(c)
        ? certifications.remove(c)
        : certifications.add(c);
    notifyListeners();
  }

  void toggleService(NearbyService s) {
    nearbyServices.contains(s)
        ? nearbyServices.remove(s)
        : nearbyServices.add(s);
    notifyListeners();
  }

  void toggleAdaptability(Adaptability a) {
    adaptabilityFeatures.contains(a)
        ? adaptabilityFeatures.remove(a)
        : adaptabilityFeatures.add(a);
    notifyListeners();
  }

  void toggleExtra(ExtraFeature e) {
    extras.contains(e) ? extras.remove(e) : extras.add(e);
    notifyListeners();
  }

  // Checkboxes tipo "radio": si marcas una letra, desmarcas la anterior
  void toggleEnergy(EnergyRating e) {
    if (energyRating == e) {
      energyRating = null;
    } else {
      energyRating = e;
    }
    notifyListeners();
  }

  // Adaptado para: jóvenes y mayores son mutuamente excluyentes (como en tu análisis inicial)
  void setTargetYoung(bool v) {
    targetYoung = v;
    if (v) targetOlder = false;
    notifyListeners();
  }

  void setTargetOlder(bool v) {
    targetOlder = v;
    if (v) targetYoung = false;
    notifyListeners();
  }

  void setTargetDisabled(bool v) {
    targetDisabled = v;
    notifyListeners();
  }

  void setAllowedBounds({
    required int priceMinA,
    required int priceMaxA,
    required int bedroomsMinA,
    required int bedroomsMaxA,
    required int m2MinA,
    required int m2MaxA,
  }) {
    // Normaliza (por si viene algo raro)
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

    priceMinAllowed = priceMinA;
    priceMaxAllowed = priceMaxA;
    bedroomsMinAllowed = bedroomsMinA;
    bedroomsMaxAllowed = bedroomsMaxA;
    m2MinAllowed = m2MinA;
    m2MaxAllowed = m2MaxA;

    // Si el usuario no tocó el slider (estaba en el rango completo anterior),
    // lo ponemos en el rango completo nuevo. Si lo tocó, hacemos clamp.
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

    // Revalida por si clamp cambió algo
    _validateAllRanges();
    notifyListeners();
  }

  void resetAll() {
    query = '';
    // operation = OperationType.alquilar;

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

    targetYoung = false;
    targetOlder = false;
    targetDisabled = false;

    errors.clear();
    notifyListeners();
  }

  // --- construir criterios / persistencia ---
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

  bool validateForApply() {
    final ok = _validateAllRanges();
    notifyListeners();
    return ok;
  }

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

  Future<void> saveSearch(String name) async {
    if (!validateForSave(name)) return;
    await _db.insertSearch(buildCriteria(name: name.trim()));
    await loadSavedSearches();
  }

  Future<void> loadSavedSearches() async {
    saved = await _db.listSearches();
    notifyListeners();
  }

  Future<void> deleteSaved(int id) async {
    await _db.deleteSearch(id);
    await loadSavedSearches();
  }

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

  // --- validación ---
  bool _validateAllRanges() {
    final a = _validateRange('price', priceMin, priceMax,
        minAllowed: priceMinAllowed, maxAllowed: priceMaxAllowed);
    final b = _validateRange('bedrooms', bedroomsMin, bedroomsMax,
        minAllowed: bedroomsMinAllowed, maxAllowed: bedroomsMaxAllowed);
    final c = _validateRange('m2', m2Min, m2Max,
        minAllowed: m2MinAllowed, maxAllowed: m2MaxAllowed, minStrict: true);
    return a && b && c;
  }

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
