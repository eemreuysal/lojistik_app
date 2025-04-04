import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../services/api_service.dart';

class VehiclesProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  List<Vehicle> _vehicles = [];
  List<Vehicle> _filteredVehicles = [];
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Vehicle> get vehicles => _searchQuery.isEmpty ? _vehicles : _filteredVehicles;
  int get vehicleCount => _vehicles.length;

  // Araçları yükle
  Future<void> loadVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final vehicles = await _apiService.getVehicles();
      _vehicles = vehicles
          .map<Vehicle>((json) => Vehicle.fromJson(json))
          .toList();
      _applySearch();
    } catch (e) {
      _error = 'Araçlar yüklenirken hata oluştu: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Araç ekle
  Future<bool> addVehicle(Map<String, dynamic> vehicleData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // ApiService üzerinden araç ekleme işlemi
      final newVehicleJson = await _apiService.addVehicle(vehicleData);
      final newVehicle = Vehicle.fromJson(newVehicleJson);
      
      // Yeni aracı listeye ekle ve aramayı güncelle
      _vehicles.add(newVehicle);
      _applySearch();
      
      return true;
    } catch (e) {
      _error = 'Araç eklenirken hata oluştu: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Arama işlemi
  void searchVehicles(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  // Arama filtresi uygula
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredVehicles = _vehicles;
    } else {
      _filteredVehicles = _vehicles.where((vehicle) {
        final plateNumber = vehicle.plateNumber.toLowerCase();
        final brand = vehicle.brand.toLowerCase();
        final model = vehicle.model?.toLowerCase() ?? '';
        final searchLower = _searchQuery.toLowerCase();
        
        return plateNumber.contains(searchLower) || 
               brand.contains(searchLower) || 
               model.contains(searchLower);
      }).toList();
    }
  }

  // Araç bilgisini getir
  Vehicle? getVehicleById(int id) {
    try {
      return _vehicles.firstWhere((vehicle) => vehicle.id == id);
    } catch (e) {
      return null;
    }
  }

  // Hata mesajını temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }
}