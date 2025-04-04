import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

class ApiService {
  static const String baseUrl = 'https://api.example.com'; // API base URL
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Token'ı secure storage'dan alma
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'access_token');
  }
  
  // Token'ı secure storage'a kaydetme
  Future<void> saveToken(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }
  
  // Token'ı silme (logout)
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }
  
  // Login işlemi
  Future<Map<String, dynamic>> login(String username, String password) async {
    // MOCK VERİ - Geliştirme aşamasında doğrudan giriş yapabilmek için
    // Gerçek API entegrasyonunda aşağıdaki HTTP isteği kullanılacak
    
    // Kullanıcı bilgilerini kontrol et
    if (username == "admin" && password == "123456") {
      // Mock token oluştur
      final accessToken = "mock_access_token_${DateTime.now().millisecondsSinceEpoch}";
      final refreshToken = "mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}";
      
      // Token'ları kaydet
      await saveToken(accessToken, refreshToken);
      
      return {
        'access': accessToken,
        'refresh': refreshToken,
      };
    } else {
      throw Exception('Login failed: Kullanıcı adı veya şifre hatalı');
    }
    
    /* 
    // GERÇEK API İSTEĞİ - SONRA AKTIF ET
    final response = await http.post(
      Uri.parse('$baseUrl/token/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await saveToken(data['access'], data['refresh']);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
    */
  }
  
  // Kullanıcı bilgilerini getirme
  Future<Map<String, dynamic>> getUserInfo() async {
    // MOCK VERİ - Geliştirme aşamasında admin kullanıcısı döndür
    // Gerçek API entegrasyonunda aşağıdaki HTTP isteği kullanılacak
    
    return {
      'id': 1,
      'username': 'admin',
      'email': 'admin@lojistik.com',
      'role': 'admin',
      'first_name': 'Yönetici',
      'last_name': 'Kullanıcı',
      'company_name': 'Fırathan Lojistik',
      'profile_image_url': null, // Varsayılan olarak profil fotoğrafı yok
    };
    
    /*
    // GERÇEK API İSTEĞİ - SONRA AKTIF ET
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users/me/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user info: ${response.body}');
    }
    */
  }
  
  // Profil fotoğrafı URL'sini kalıcı olarak kaydet
  Future<void> saveProfileImageUrl(String imageUrl) async {
    try {
      // URL'yi normalize et - file:// ile başlamıyorsa ve dosya yoluysa ekle
      String normalizedUrl = imageUrl;
      
      // Öncelikle herhangi bir 'file://' önekini temizleyelim
      if (normalizedUrl.startsWith('file://')) {
        normalizedUrl = normalizedUrl.substring(7);
      }
      
      // Eğer data URI ise olduğu gibi bırak
      if (normalizedUrl.startsWith('data:')) {
        // Do nothing, keep as is
      }
      // Dosya yoluysa ve / ile başlıyorsa file:// öneki ekleme
      else if (normalizedUrl.startsWith('/')) {
        // Dosya yollarını file:// eklenmeden kaydet
        // normalizedUrl = 'file://$normalizedUrl';
      }
      // HTTP URL'leri olduğu gibi bırak
      else if (normalizedUrl.startsWith('http://') || normalizedUrl.startsWith('https://')) {
        // Do nothing, keep as is
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_url', normalizedUrl);
      logger.d("Profil fotoğrafı URL'si kaydedildi: $normalizedUrl");
    } catch (e) {
      logger.e("Profil fotoğrafı URL'si kaydedilirken hata: $e");
    }
  }

  // Profil fotoğrafı URL'sini getir
  Future<String?> getProfileImageUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imageUrl = prefs.getString('profile_image_url');
      return imageUrl;
    } catch (e) {
      logger.e("Profil fotoğrafı URL'si alınırken hata: $e");
      return null;
    }
  }

  // Kullanıcı bilgilerini kalıcı olarak kaydet
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_info', jsonEncode(userInfo));
      logger.d("Kullanıcı bilgileri kaydedildi");
    } catch (e) {
      logger.e("Kullanıcı bilgileri kaydedilirken hata: $e");
    }
  }

  // Kullanıcı bilgilerini getir
  Future<Map<String, dynamic>?> getSavedUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfoStr = prefs.getString('user_info');
      if (userInfoStr != null) {
        return jsonDecode(userInfoStr) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      logger.e("Kullanıcı bilgileri alınırken hata: $e");
      return null;
    }
  }
  
  // Profil fotoğrafı yükleme
  Future<Map<String, dynamic>> uploadProfileImage(File imageFile) async {
    logger.d("Profil fotoğrafı yükleniyor: ${imageFile.path}");
    
    try {
      // Simulasyon için gecikme
      await Future.delayed(const Duration(seconds: 1)); 
      
      // Dosya içeriğini base64 olarak kodla
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Base64 verisini URL'ye ekle - örnek bir format
      // Base64 formatında doğrudan kaydetmek daha uygun olacak
      final imageUrl = 'data:image/png;base64,$base64Image';
      
      final result = {
        'profileImageUrl': imageUrl,
      };
      
      // Profil fotoğraf URL'sini kalıcı olarak kaydet
      // NOT: BURADA file:// ÖNEKİ EKLEMiYORUZ
      await saveProfileImageUrl(imageUrl);
      
      logger.d("Profil fotoğrafı güncellendi ve base64 olarak kaydedildi");
      return result;
    } catch (e) {
      logger.e("Profil fotoğrafı yükleme hatası: $e");
      rethrow;
    }
  }
  
  // Profil fotoğrafını temizleyip sıfırla
  Future<bool> resetProfileImage() async {
    try {
      // Eski profil fotoğrafını temizle
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_image_url');
      logger.d("Profil fotoğrafı temizlendi");
      return true;
    } catch (e) {
      logger.e("Profil fotoğrafı temizleme hatası: $e");
      return false;
    }
    
    //import 'package:http_parser/http_parser.dart';
    /*
    // GERÇEK API İSTEĞİ - SONRA AKTİF ET
    final token = await getToken();
    final headers = {
      'Authorization': 'Bearer $token',
    };
    
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload/profile-image/'));
    request.headers.addAll(headers);
    
    // Dosya ekleme
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        //contentType: MediaType('image', 'jpeg'), // Veya gerçek dosya tipini belirleyin
      ),
    );
    
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    
    if (response.statusCode == 200) {
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to upload profile image: $responseBody');
    }
    */
  }
  
  // Şoför listesini kayıt etme
  Future<void> saveDrivers(List<dynamic> drivers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('drivers_data', jsonEncode(drivers));
      logger.d("Sürücü verileri kayıt edildi: ${drivers.length} sürücü");
    } catch (e) {
      logger.e("Sürücüler kaydedilirken hata: $e");
    }
  }

  // Kaydedilmiş şoförleri getirme
  Future<List<dynamic>?> getSavedDrivers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final driversStr = prefs.getString('drivers_data');
      if (driversStr != null) {
        return jsonDecode(driversStr) as List<dynamic>;
      }
      return null;
    } catch (e) {
      logger.e("Kaydedilmiş sürücüler alınırken hata: $e");
      return null;
    }
  }

  // Şoförleri listeleme
  Future<List<dynamic>> getDrivers() async {
    // Önce yerelden veri almayı dene
    final savedDrivers = await getSavedDrivers();
    if (savedDrivers != null) {
      logger.d("Sürücüler yerel depolamadan yüklendi: ${savedDrivers.length} sürücü");
      return savedDrivers;
    }
    
    // Yerelde veri yoksa mock veriler döndür (geliştirme aşamasında)
    await Future.delayed(const Duration(milliseconds: 800)); // Gerçekçi gecikme
    
    final drivers = [
      {
        'id': 1,
        'first_name': 'Ahmet',
        'last_name': 'Yılmaz',
        'phone': '0532 111 2233',
        'email': 'ahmet@lojistik.com',
        'driver_license': 'A123456',
        'national_id': '12345678901',
        'is_active': true,
      },
      {
        'id': 2,
        'first_name': 'Mehmet',
        'last_name': 'Öztürk',
        'phone': '0533 222 3344',
        'email': 'mehmet@lojistik.com',
        'driver_license': 'B654321',
        'national_id': '98765432109',
        'is_active': true,
      },
      {
        'id': 3,
        'first_name': 'Ali',
        'last_name': 'Kaya',
        'phone': '0535 333 4455',
        'email': 'ali@lojistik.com',
        'driver_license': 'C789012',
        'national_id': '45678901234',
        'is_active': false,
      },
    ];
    
    // Mock verileri yerele kayıt et
    await saveDrivers(drivers);
    logger.d("Sürücüler API'den alındı ve yerel olarak kaydedildi: ${drivers.length} sürücü");
    
    return drivers;
    
    /*
    // GERÇEK API İSTEĞİ - SONRA AKTIF ET
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/drivers/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final drivers = json.decode(response.body);
      await saveDrivers(drivers); // API'den alınan verileri yerele kayıt et
      return drivers;
    } else {
      throw Exception('Failed to load drivers: ${response.body}');
    }
    */
  }
  
  // Şoför ekleme
  Future<Map<String, dynamic>> addDriver(Map<String, dynamic> driverData) async {
    // MOCK VERİ - Geliştirme aşamasında şoför ekleme
    await Future.delayed(const Duration(milliseconds: 600)); // Gerçekçi gecikme
    
    // Tüm sürücüleri al
    final allDrivers = await getSavedDrivers() ?? [];
    
    // Yeni sürücü için ID oluştur
    final newId = allDrivers.isEmpty ? 1 : (allDrivers.map((d) => d['id']).reduce((a, b) => a > b ? a : b) + 1);
    
    // Yeni sürücü verisi
    final newDriver = {
      'id': newId,
      'first_name': driverData['first_name'] ?? '',
      'last_name': driverData['last_name'] ?? '',
      'phone': driverData['phone'] ?? '',
      'email': driverData['email'] ?? '',
      'driver_license': driverData['driver_license'] ?? '',
      'national_id': driverData['national_id'] ?? '',
      'is_active': driverData['is_active'] ?? true,
    };
    
    // Sürücüler listesine ekle
    allDrivers.add(newDriver);
    
    // Güncellenmiş listeyi kayıt et
    await saveDrivers(allDrivers);
    logger.d("Yeni sürücü eklendi ve kaydedildi: ${newDriver['first_name']} ${newDriver['last_name']}");
    
    return newDriver;
    
    /*
    // GERÇEK API İSTEĞİ - SONRA AKTİF ET
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/drivers/'),
      headers: headers,
      body: json.encode(driverData),
    );
    
    if (response.statusCode == 201) {
      final newDriver = json.decode(response.body);
      
      // Yerel sürücü listesini güncelle
      final allDrivers = await getSavedDrivers() ?? [];
      allDrivers.add(newDriver);
      await saveDrivers(allDrivers);
      
      return newDriver;
    } else {
      throw Exception('Failed to add driver: ${response.body}');
    }
    */
  }
  
  // Sefer listesini kayıt etme
  Future<void> saveTrips(List<dynamic> trips) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('trips_data', jsonEncode(trips));
      logger.d("Sefer verileri kayıt edildi: ${trips.length} sefer");
    } catch (e) {
      logger.e("Seferler kaydedilirken hata: $e");
    }
  }

  // Kaydedilmiş seferleri getirme
  Future<List<dynamic>?> getSavedTrips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tripsStr = prefs.getString('trips_data');
      if (tripsStr != null) {
        return jsonDecode(tripsStr) as List<dynamic>;
      }
      return null;
    } catch (e) {
      logger.e("Kaydedilmiş seferler alınırken hata: $e");
      return null;
    }
  }

  // Seferleri listeleme
  Future<List<dynamic>> getTrips() async {
    // Önce yerelden veri almayı dene
    final savedTrips = await getSavedTrips();
    if (savedTrips != null) {
      logger.d("Seferler yerel depolamadan yüklendi: ${savedTrips.length} sefer");
      return savedTrips;
    }
    
    // Yerelde veri yoksa mock veriler döndür (geliştirme aşamasında)
    await Future.delayed(const Duration(milliseconds: 700)); // Gerçekçi gecikme
    
    final mockTrips = [
      {
        'id': 1,
        'start_date': '2025-03-26',
        'end_date': '2025-03-30',
        'vehicle': 1,
        'driver': 1,
        'customer': 1,
        'status': 'Devam Ediyor',
        'vehicle_plate': '34 ABC 123',
        'driver_name': 'Ahmet Yılmaz',
        'created_at': '2025-03-25T10:30:00Z',
      },
      {
        'id': 2,
        'start_date': '2025-03-27',
        'end_date': '2025-04-02',
        'vehicle': 2,
        'driver': 2,
        'customer': 2,
        'status': 'Yükleme Başladı',
        'vehicle_plate': '06 DEF 456',
        'driver_name': 'Mehmet Öztürk',
        'created_at': '2025-03-25T14:15:00Z',
      },
      {
        'id': 3,
        'start_date': '2025-03-25',
        'end_date': '2025-03-28',
        'vehicle': 3,
        'driver': 1,
        'customer': 3,
        'status': 'Tamamlandı',
        'vehicle_plate': '35 XYZ 789',
        'driver_name': 'Ahmet Yılmaz',
        'created_at': '2025-03-24T09:00:00Z',
      },
      {
        'id': 4,
        'start_date': '2025-03-15',
        'end_date': '2025-03-20',
        'vehicle': 1,
        'driver': 2,
        'customer': 2,
        'status': 'Tamamlandı',
        'vehicle_plate': '34 ABC 123',
        'driver_name': 'Mehmet Öztürk',
        'created_at': '2025-03-14T08:45:00Z',
      },
      {
        'id': 5,
        'start_date': '2025-03-10',
        'end_date': '2025-03-18',
        'vehicle': 2,
        'driver': 3,
        'customer': 1,
        'status': 'Tamamlandı',
        'vehicle_plate': '06 DEF 456',
        'driver_name': 'Ali Kaya',
        'created_at': '2025-03-09T16:30:00Z',
      }
    ];
    
    // Mock verileri yerele kayıt et
    await saveTrips(mockTrips);
    logger.d("Seferler API'den alındı ve yerel olarak kaydedildi: ${mockTrips.length} sefer");
    
    return mockTrips;
    
    /*
    // GERÇEK API İSTEĞİ - SONRA AKTIF ET
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/trips/trips/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final trips = json.decode(response.body);
      await saveTrips(trips); // API'den alınan verileri yerele kayıt et
      return trips;
    } else {
      throw Exception('Failed to load trips: ${response.body}');
    }
    */
  }
  
  // Sefer oluşturma
  Future<Map<String, dynamic>> createTrip(Map<String, dynamic> tripData) async {
    // MOCK VERİ - Geliştirme aşamasında sefer ekleme
    await Future.delayed(const Duration(milliseconds: 600)); // Gerçekçi gecikme
    
    // Tüm seferleri al
    final allTrips = await getSavedTrips() ?? [];
    
    // Yeni sefer için ID oluştur
    final newId = allTrips.isEmpty ? 1 : (allTrips.map((t) => t['id']).reduce((a, b) => a > b ? a : b) + 1);
    
    // Sürücü ve araç bilgilerini al
    final drivers = await getDrivers();
    final vehicles = await getVehicles();
    
    final driverId = tripData['driver'] ?? 1;
    final vehicleId = tripData['vehicle'] ?? 1;
    
    // Sürücü adını bul
    final driver = drivers.firstWhere((d) => d['id'] == driverId, orElse: () => {'first_name': 'Bilinmeyen', 'last_name': 'Sürücü'});
    final driverName = "${driver['first_name']} ${driver['last_name']}";
    
    // Araç plakasını bul
    final vehicle = vehicles.firstWhere((v) => v['id'] == vehicleId, orElse: () => {'plate_number': 'XX XXX XX'});
    final vehiclePlate = vehicle['plate_number'];
    
    // Yeni sefer verisi
    final newTrip = {
      'id': newId,
      'start_date': tripData['start_date'] ?? '2025-01-01',
      'end_date': tripData['end_date'] ?? '2025-01-07',
      'vehicle': vehicleId,
      'driver': driverId,
      'customer': tripData['customer'] ?? 1,
      'status': 'Yükleme Başladı',
      'vehicle_plate': vehiclePlate,
      'driver_name': driverName,
      'created_at': DateTime.now().toIso8601String(),
    };
    
    // Seferler listesine ekle
    allTrips.add(newTrip);
    
    // Güncellenmiş listeyi kayıt et
    await saveTrips(allTrips);
    logger.d("Yeni sefer eklendi ve kaydedildi: ID #$newId");
    
    return newTrip;
    
    /*
    // GERÇEK API İSTEĞİ - SONRA AKTİF ET
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/trips/trips/'),
      headers: headers,
      body: json.encode(tripData),
    );
    
    if (response.statusCode == 201) {
      final newTrip = json.decode(response.body);
      
      // Yerel sefer listesini güncelle
      final allTrips = await getSavedTrips() ?? [];
      allTrips.add(newTrip);
      await saveTrips(allTrips);
      
      return newTrip;
    } else {
      throw Exception('Failed to create trip: ${response.body}');
    }
    */
  }
  
  // Araç listesini kaydetme
  Future<void> saveVehicles(List<dynamic> vehicles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('vehicles_data', jsonEncode(vehicles));
      logger.d("Araç verileri kayıt edildi: ${vehicles.length} araç");
    } catch (e) {
      logger.e("Araçlar kaydedilirken hata: $e");
    }
  }

  // Kaydedilmiş araçları getirme
  Future<List<dynamic>?> getSavedVehicles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final vehiclesStr = prefs.getString('vehicles_data');
      if (vehiclesStr != null) {
        return jsonDecode(vehiclesStr) as List<dynamic>;
      }
      return null;
    } catch (e) {
      logger.e("Kaydedilmiş araçlar alınırken hata: $e");
      return null;
    }
  }
  
  // Araçları listeleme
  Future<List<dynamic>> getVehicles() async {
    // Önce yerelden veri almayı dene
    final savedVehicles = await getSavedVehicles();
    if (savedVehicles != null) {
      logger.d("Araçlar yerel depolamadan yüklendi: ${savedVehicles.length} araç");
      return savedVehicles;
    }
    
    // Yerelde veri yoksa mock veriler döndür (geliştirme aşamasında)
    await Future.delayed(const Duration(milliseconds: 600)); // Gerçekçi gecikme
    
    final vehicles = [
      {
        'id': 1,
        'brand': 'Mercedes',
        'model': 'Actros',
        'plate_number': '34 ABC 123',
        'model_year': 2022,
        'capacity': 25000,
        'is_active': true,
      },
      {
        'id': 2,
        'brand': 'Ford',
        'model': 'Trucks',
        'plate_number': '06 DEF 456',
        'model_year': 2021,
        'capacity': 20000,
        'is_active': true,
      },
      {
        'id': 3,
        'brand': 'Volvo',
        'model': 'FH16',
        'plate_number': '35 XYZ 789',
        'model_year': 2023,
        'capacity': 30000,
        'is_active': true,
      },
    ];
    
    // Mock verileri yerele kayıt et
    await saveVehicles(vehicles);
    logger.d("Araçlar API'den alındı ve yerel olarak kaydedildi: ${vehicles.length} araç");
    
    return vehicles;
    
    /*
    // GERÇEK API İSTEĞİ - SONRA AKTIF ET
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final vehicles = json.decode(response.body);
      await saveVehicles(vehicles); // API'den alınan verileri yerele kayıt et
      return vehicles;
    } else {
      throw Exception('Failed to load vehicles: ${response.body}');
    }
    */
  }
  
  // Araç ekleme
  Future<Map<String, dynamic>> addVehicle(Map<String, dynamic> vehicleData) async {
    // MOCK VERİ - Geliştirme aşamasında araç ekleme
    await Future.delayed(const Duration(milliseconds: 600)); // Gerçekçi gecikme
    
    // Tüm araçları al
    final allVehicles = await getSavedVehicles() ?? [];
    
    // Yeni araç için ID oluştur
    final newId = allVehicles.isEmpty ? 1 : (allVehicles.map((v) => v['id']).reduce((a, b) => a > b ? a : b) + 1);
    
    // Yeni araç verisi
    final newVehicle = {
      'id': newId,
      'brand': vehicleData['brand'] ?? '',
      'model': vehicleData['model'] ?? '',
      'plate_number': vehicleData['plate_number'] ?? '',
      'model_year': vehicleData['model_year'] ?? 2023,
      'capacity': vehicleData['capacity'] ?? 0,
      'is_active': vehicleData['is_active'] ?? true,
    };
    
    // Araçlar listesine ekle
    allVehicles.add(newVehicle);
    
    // Güncellenmiş listeyi kayıt et
    await saveVehicles(allVehicles);
    logger.d("Yeni araç eklendi ve kaydedildi: ${newVehicle['brand']} ${newVehicle['model']}");
    
    return newVehicle;
    
    /*
    // GERÇEK API İSTEĞİ - SONRA AKTİF ET
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/vehicles/'),
      headers: headers,
      body: json.encode(vehicleData),
    );
    
    if (response.statusCode == 201) {
      final newVehicle = json.decode(response.body);
      
      // Yerel araç listesini güncelle
      final allVehicles = await getSavedVehicles() ?? [];
      allVehicles.add(newVehicle);
      await saveVehicles(allVehicles);
      
      return newVehicle;
    } else {
      throw Exception('Failed to add vehicle: ${response.body}');
    }
    */
  }
  
  // Dashboard verilerini alma (seferler, şoförler, araçlar sayısı)
  Future<Map<String, dynamic>> getDashboardData() async {
    // MOCK VERİ - Geliştirme aşamasında örnek dashboard verileri
    await Future.delayed(const Duration(milliseconds: 500)); // Gerçekçi gecikme
    
    final trips = await getTrips();
    final drivers = await getDrivers();
    final vehicles = await getVehicles();
    
    // Son 10 seferi göstererek daha fazla sefer görüntülenmesini sağla
    return {
      'tripCount': trips.length,
      'driverCount': drivers.length,
      'vehicleCount': vehicles.length,
      'recentTrips': trips.take(10).toList(), // Son 10 seferi göster
    };
    
    /*
    // GERÇEK API İSTEĞİ - SONRA AKTIF ET
    final headers = await _getHeaders();
    
    // Farklı API çağrılarını parallel olarak yap
    final tripsResponse = await http.get(
      Uri.parse('$baseUrl/trips/trips/'),
      headers: headers,
    );
    
    final driversResponse = await http.get(
      Uri.parse('$baseUrl/drivers/'),
      headers: headers,
    );
    
    final vehiclesResponse = await http.get(
      Uri.parse('$baseUrl/vehicles/'),
      headers: headers,
    );
    
    if (tripsResponse.statusCode == 200 && 
        driversResponse.statusCode == 200 && 
        vehiclesResponse.statusCode == 200) {
      final trips = json.decode(tripsResponse.body);
      final drivers = json.decode(driversResponse.body);
      final vehicles = json.decode(vehiclesResponse.body);
      
      return {
        'tripCount': trips.length,
        'driverCount': drivers.length,
        'vehicleCount': vehicles.length,
      };
    } else {
      throw Exception('Failed to load dashboard data');
    }
    */
  }
}