import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/farm.dart';

class FarmProvider with ChangeNotifier {
  List<Farm> _farms = [];

  List<Farm> get farms {
    return [..._farms];
  }

  Future<void> loadFarms() async {
    final prefs = await SharedPreferences.getInstance();
    final farmData = prefs.getString('farms');
    if (farmData != null) {
      final List<dynamic> decodedData = json.decode(farmData);
      _farms = decodedData.map((item) => Farm.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> saveFarms() async {
    final prefs = await SharedPreferences.getInstance();
    final farmData = json.encode(_farms.map((farm) => farm.toJson()).toList());
    await prefs.setString('farms', farmData);
  }

  Farm findById(String id) {
    return _farms.firstWhere((farm) => farm.id == id);
  }

  Future<void> addFarm(Farm farm) async {
    _farms.add(farm);
    notifyListeners();
    await saveFarms();
  }

  Future<void> updateFarm(Farm farm) async {
    final farmIndex = _farms.indexWhere((f) => f.id == farm.id);
    if (farmIndex >= 0) {
      _farms[farmIndex] = farm;
      notifyListeners();
      await saveFarms();
    }
  }

  Future<void> deleteFarm(String id) async {
    _farms.removeWhere((farm) => farm.id == id);
    notifyListeners();
    await saveFarms();
  }
}