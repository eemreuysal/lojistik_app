import 'package:flutter/material.dart';
import '../models/driver_model.dart';
import '../services/api_service.dart';

class DriversProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  List<Driver> _drivers = [];
  List<Driver> _filteredDrivers = [];
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Driver> get drivers => _searchQuery.isEmpty ? _drivers : _filteredDrivers;
  int get driverCount => _drivers.length;

  // Şoförleri yükle
  Future<void> loadDrivers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final drivers = await _apiService.getDrivers();
      _drivers = drivers
          .map<Driver>((json) => Driver.fromJson(json))
          .toList();
      _applySearch();
    } catch (e) {
      _error = 'Şoförler yüklenirken hata oluştu: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Şoför ekle
  Future<bool> addDriver(Map<String, dynamic> driverData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newDriver = await _apiService.addDriver(driverData);
      _drivers.add(Driver.fromJson(newDriver));
      _applySearch();
      return true;
    } catch (e) {
      _error = 'Şoför eklenirken hata oluştu: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Arama işlemi
  void searchDrivers(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  // Arama filtresi uygula
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredDrivers = _drivers;
    } else {
      _filteredDrivers = _drivers.where((driver) {
        final fullName = driver.fullName.toLowerCase();
        final phone = driver.phone.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        
        return fullName.contains(searchLower) || phone.contains(searchLower);
      }).toList();
    }
  }

  // Hata mesajını temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }
}