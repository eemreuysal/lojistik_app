import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../services/api_service.dart';

class TripsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  List<Trip> _trips = [];
  List<Trip> _filteredTrips = [];
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Trip> get trips => _searchQuery.isEmpty ? _trips : _filteredTrips;
  int get tripCount => _trips.length;

  // Seferleri yükle
  Future<void> loadTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final trips = await _apiService.getTrips();
      _trips = trips
          .map<Trip>((json) => Trip.fromJson(json))
          .toList();
      
      // Tarihe göre sırala (en yeniden en eskiye)
      _trips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      _applySearch();
    } catch (e) {
      _error = 'Seferler yüklenirken hata oluştu: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sefer oluştur
  Future<bool> createTrip(Map<String, dynamic> tripData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTrip = await _apiService.createTrip(tripData);
      _trips.insert(0, Trip.fromJson(newTrip));
      _applySearch();
      return true;
    } catch (e) {
      _error = 'Sefer oluşturulurken hata oluştu: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sefer durumunu güncelle
  Future<bool> updateTripStatus(int tripId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Gerçek API çağrısı burada yapılacak
      // Şimdilik mock bir güncelleme yapalım
      await Future.delayed(const Duration(seconds: 1));
      
      // Seferi listede bul ve güncelle
      final index = _trips.indexWhere((trip) => trip.id == tripId);
      if (index != -1) {
        final updatedTrip = Trip(
          id: _trips[index].id,
          startDate: _trips[index].startDate,
          endDate: _trips[index].endDate,
          vehicleId: _trips[index].vehicleId,
          driverId: _trips[index].driverId,
          customerId: _trips[index].customerId,
          status: status,
          vehiclePlate: _trips[index].vehiclePlate,
          driverName: _trips[index].driverName,
          createdAt: _trips[index].createdAt,
        );
        
        _trips[index] = updatedTrip;
        _applySearch();
      }
      
      return true;
    } catch (e) {
      _error = 'Sefer durumu güncellenirken hata oluştu: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Arama işlemi
  void searchTrips(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  // Arama filtresi uygula
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredTrips = _trips;
    } else {
      _filteredTrips = _trips.where((trip) {
        final tripNumber = trip.tripNumber.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        
        return tripNumber.contains(searchLower) || 
               (trip.vehiclePlate != null && trip.vehiclePlate!.toLowerCase().contains(searchLower)) ||
               (trip.driverName != null && trip.driverName!.toLowerCase().contains(searchLower));
      }).toList();
    }
  }

  // Hata mesajını temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }
}