import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cattle.dart';

class CattleProvider with ChangeNotifier {
  List<Cattle> _items = [];

  List<Cattle> get items {
    return [..._items];
  }

  Cattle findById(String id) {
    return _items.firstWhere((cattle) => cattle.id == id);
  }

  Future<void> loadCattle() async {
    final prefs = await SharedPreferences.getInstance();
    final cattleData = prefs.getString('cattle');
    if (cattleData != null) {
      final List<dynamic> decodedData = json.decode(cattleData);
      _items = decodedData.map((item) => Cattle.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> saveCattle() async {
    final prefs = await SharedPreferences.getInstance();
    final cattleData = json.encode(_items.map((cattle) => cattle.toJson()).toList());
    await prefs.setString('cattle', cattleData);
  }

  List<Cattle> cattleByFarm(String farmId) {
    return _items.where((cattle) => cattle.farmId == farmId).toList();
  }

  Future<void> addCattle(Cattle cattle) async {
    _items.add(cattle);
    notifyListeners();
    await saveCattle();
  }

  Future<void> updateCattle(String id, Cattle newCattle) async {
    final cattleIndex = _items.indexWhere((cattle) => cattle.id == id);
    if (cattleIndex >= 0) {
      _items[cattleIndex] = newCattle;
      notifyListeners();
      await saveCattle();
    }
  }

  Future<void> deleteCattle(String id) async {
    _items.removeWhere((cattle) => cattle.id == id);
    notifyListeners();
    await saveCattle();
  }

  Future<void> addWeightRecord(String cattleId, WeightRecord weightRecord) async {
    final cattle = findById(cattleId);
    cattle.addWeightRecord(weightRecord);
    notifyListeners();
    await saveCattle();
  }

  Future<void> addVaccination(String cattleId, Vaccination vaccination) async {
    final cattle = findById(cattleId);
    cattle.addVaccination(vaccination);
    notifyListeners();
    await saveCattle();
  }

  Future<void> addInsemination(String cattleId, Insemination insemination) async {
    final cattle = findById(cattleId);
    cattle.addInsemination(insemination);
    notifyListeners();
    await saveCattle();
  }
}