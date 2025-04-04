import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  int _tripCount = 0;
  int _driverCount = 0;
  int _vehicleCount = 0;
  List<Trip> _recentTrips = [];
  List<Trip> _allTrips = []; // Tüm seferleri saklayacak
  String _searchQuery = ''; // Arama sorgusu

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get tripCount => _tripCount;
  int get driverCount => _driverCount;
  int get vehicleCount => _vehicleCount;
  List<Trip> get recentTrips {
    // Eğer arama yapılıyorsa, tüm seferler arasında ara
    if (_searchQuery.isNotEmpty) {
      return _filterTrips(_allTrips, _searchQuery);
    }
    
    // Arama yapılmıyorsa normal olarak son seferleri göster
    // Ama her durumda seferleri önce aktif duruma sonra tarihe göre sırala
    List<Trip> sortedTrips = List.from(_recentTrips);
    sortedTrips.sort((a, b) {
      // Önce aktif/devam eden seferlere göre sırala
      if (a.isActive && !b.isActive) {
        return -1; // a aktif, b değil - a önce gelsin
      } else if (!a.isActive && b.isActive) {
        return 1;  // b aktif, a değil - b önce gelsin
      }
      
      // Aktiflik durumu aynıysa, tarihe göre sırala (yeni tarihler önce)
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return sortedTrips;
  }
  String get searchQuery => _searchQuery;

  // Arama sorgusunu güncelle
  void updateSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  // Seferleri arama sorgusuna göre filtrele ve sırala
  List<Trip> _filterTrips(List<Trip> trips, String query) {
    if (query.isEmpty) {
      return trips;
    }
    
    // Önce arama sorgusuna göre filtrele
    List<Trip> filteredTrips = trips.where((trip) {
      // Sefer numarası, araç plakası ve şoför adında arama yap
      return trip.tripNumber.toLowerCase().contains(query) ||
             (trip.vehiclePlate?.toLowerCase().contains(query) ?? false) ||
             (trip.driverName?.toLowerCase().contains(query) ?? false);
    }).toList();
    
    // Filtrelenen sonuçları önce aktif/devam eden sefer durumuna göre sonra tarihe göre sırala
    filteredTrips.sort((a, b) {
      // Önce aktif/devam eden seferlere göre sırala
      if (a.isActive && !b.isActive) {
        return -1; // a aktif, b değil - a önce gelsin
      } else if (!a.isActive && b.isActive) {
        return 1;  // b aktif, a değil - b önce gelsin
      }
      
      // Aktiflik durumu aynıysa, tarihe göre sırala (yeni tarihler önce)
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return filteredTrips;
  }

  // Dashboard verilerini yükle
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Dashboard verilerini al
      final dashboardData = await _apiService.getDashboardData();
      _tripCount = dashboardData['tripCount'];
      _driverCount = dashboardData['driverCount'];
      _vehicleCount = dashboardData['vehicleCount'];
      
      // Dashboard'da görüntülenecek son seferleri al
      if (dashboardData.containsKey('recentTrips')) {
        _recentTrips = (dashboardData['recentTrips'] as List)
          .map<Trip>((json) => Trip.fromJson(json))
          .toList();
        
        // API'den alınan seferleri de hemen sırala
        _recentTrips.sort((a, b) {
          // Önce aktif/devam eden seferlere göre sırala
          if (a.isActive && !b.isActive) {
            return -1; // a aktif, b değil - a önce gelsin
          } else if (!a.isActive && b.isActive) {
            return 1;  // b aktif, a değil - b önce gelsin
          }
          
          // Aktiflik durumu aynıysa, tarihe göre sırala (yeni tarihler önce)
          return b.createdAt.compareTo(a.createdAt);
        });
      }
      
      // Tüm seferleri ayrıca al
      await loadAllTrips();
    } catch (e) {
      _error = 'Dashboard verisi yüklenirken hata oluştu: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tüm seferleri yükle
  Future<void> loadAllTrips() async {
    try {
      final trips = await _apiService.getTrips();
      _allTrips = trips
          .map<Trip>((json) => Trip.fromJson(json))
          .toList();
      
      // Tüm seferleri önce aktif duruma sonra tarihe göre sırala
      _allTrips.sort((a, b) {
        // Önce aktif/devam eden seferlere göre sırala
        if (a.isActive && !b.isActive) {
          return -1; // a aktif, b değil - a önce gelsin
        } else if (!a.isActive && b.isActive) {
          return 1;  // b aktif, a değil - b önce gelsin
        }
        
        // Aktiflik durumu aynıysa, tarihe göre sırala (yeni tarihler önce)
        return b.createdAt.compareTo(a.createdAt);
      });
      
      // Eğer recentTrips yüklenmemişse, son 10 seferi recentTrips olarak ayarla
      if (_recentTrips.isEmpty && _allTrips.isNotEmpty) {
        _recentTrips = _allTrips.take(10).toList();
      }
    } catch (e) {
      _error = 'Seferler yüklenirken hata oluştu: ${e.toString()}';
    }
    notifyListeners();
  }

  // Hata mesajını temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }
}