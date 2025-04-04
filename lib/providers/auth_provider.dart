import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/logger.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isDriver => _currentUser?.isDriver ?? false;

  // Uygulama başlatıldığında oturum durumunu kontrol et
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _apiService.getToken();
      if (token != null) {
        // Token varsa kullanıcı bilgilerini getir
        await getUserInfo();
        
        // Kaydedilmiş profil fotoğrafı var mı kontrol et
        final savedProfileImageUrl = await _apiService.getProfileImageUrl();
        if (savedProfileImageUrl != null && _currentUser != null) {
          // Kaydedilen profil fotoğrafını kullanıcı nesnesine ekle
          _currentUser = User(
            id: _currentUser!.id,
            username: _currentUser!.username,
            email: _currentUser!.email,
            role: _currentUser!.role,
            firstName: _currentUser!.firstName,
            lastName: _currentUser!.lastName,
            companyName: _currentUser!.companyName,
            profileImageUrl: savedProfileImageUrl,
          );
        }
        
        _isLoggedIn = true;
      }
    } catch (e) {
      _error = e.toString();
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Giriş işlemi
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Önce eski profil fotografını temizle (file:// sorunu için)
      await _apiService.resetProfileImage();
      
      // Giriş yap
      await _apiService.login(username, password);
      await getUserInfo();
      _isLoggedIn = true;
      return true;
    } catch (e) {
      _error = 'Giriş başarısız: Kullanıcı adı veya şifre hatalı.';
      _isLoggedIn = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Çıkış işlemi
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteToken();
      _currentUser = null;
      _isLoggedIn = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kullanıcı bilgilerini getir
  Future<void> getUserInfo() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Önce yerel depolamadan kullanıcı bilgilerini almayı dene
      final savedUserInfo = await _apiService.getSavedUserInfo();
      final savedProfileImageUrl = await _apiService.getProfileImageUrl();
      
      if (savedUserInfo != null) {
        // Yerel bilgiler varsa onları kullan
        _currentUser = User.fromJson(savedUserInfo);
        
        // Profil fotoğrafını ayarla (eğer kaydedilmişse)
        if (savedProfileImageUrl != null && _currentUser != null) {
          _currentUser = User(
            id: _currentUser!.id,
            username: _currentUser!.username,
            email: _currentUser!.email,
            role: _currentUser!.role,
            firstName: _currentUser!.firstName,
            lastName: _currentUser!.lastName,
            companyName: _currentUser!.companyName,
            profileImageUrl: savedProfileImageUrl,
          );
        }
        
        logger.i("Kullanıcı bilgileri yerel depolamadan alındı.");
      } else {
        // Yerel bilgi yoksa API'den al
        final userInfo = await _apiService.getUserInfo();
        _currentUser = User.fromJson(userInfo);
        
        // API'den alınan bilgileri yerel olarak kaydet
        await _apiService.saveUserInfo(userInfo);
        logger.i("Kullanıcı bilgileri API'den alındı ve yerel olarak kaydedildi.");
      }
    } catch (e) {
      _error = e.toString();
      logger.e("Kullanıcı bilgileri alınırken hata: $_error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Profil fotoğrafını güncelle
  Future<void> updateProfileImage(File imageFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Önce eski profil fotografını temizle (file:// sorunu için)
      await _apiService.resetProfileImage();
      
      logger.d("Fotoğraf yükleme başladı: ${imageFile.path}");
      final response = await _apiService.uploadProfileImage(imageFile);
      logger.i("API yanıtı: $response");
      
      // Mevcut kullanıcı nesnesini güncelle
      if (_currentUser != null) {
        String profileImageUrl;
        final responseUrl = response['profileImageUrl']; 
        
        // Her zaman API'den gelen URL'yi kullan
        profileImageUrl = responseUrl;
        
        logger.d("Profil fotoğrafı URL'si: $profileImageUrl");
        
        // Profil fotoğrafını kalıcı olarak kaydet - file:// olmadan kaydediyoruz
        await _apiService.saveProfileImageUrl(profileImageUrl);
        
        // Önemli: Gecikmeli güncelleme
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Kullanıcı nesnesini güncelle
        _currentUser = User(
          id: _currentUser!.id,
          username: _currentUser!.username,
          email: _currentUser!.email,
          role: _currentUser!.role,
          firstName: _currentUser!.firstName,
          lastName: _currentUser!.lastName,
          companyName: _currentUser!.companyName,
          profileImageUrl: profileImageUrl, 
        );
        
        // Kullanıcı bilgilerini kalıcı olarak kaydet
        await _apiService.saveUserInfo(_currentUser!.toJson());
        
        // Dinleyicilere haber ver
        notifyListeners();
        
        logger.i("Profil fotoğrafı güncellendi ve kaydedildi: ${_currentUser?.profileImageUrl}");
      }

      _error = null;
    } catch (e) {
      logger.e("Profil fotoğrafı güncellenirken hata: $e");
      _error = "Profil fotoğrafı güncellenirken hata oluştu: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
      logger.d("Profil güncelleme tamamlandı. İşlem başarılı: ${_error == null}");
    }
  }

  // Hata mesajını temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }
}