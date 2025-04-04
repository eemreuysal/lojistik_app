import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' show Logger, PrettyPrinter, ProductionFilter, DevelopmentFilter, DateTimeFormat;

/// Uygulama genelinde kullanılacak logger sınıfı.
/// 
/// Bu sınıf farklı seviyelerde loglama yapabilmek için
/// [Logger] paketini kullanır ve farklı loglama seviyelerini
/// kapsülleyen yardımcı metodlar sunar.
class AppLogger {
  // Singleton pattern
  static final AppLogger _instance = AppLogger._internal();
  static AppLogger get instance => _instance;
  
  AppLogger._internal();
  
  // Logger tanımla
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Metot stack trace sayısını sıfırla
      errorMethodCount: 5, // Hata durumunda 5 metot stack trace göster
      lineLength: 80, // Satır uzunluğunu 80 karaktere sabitle
      colors: true, // Konsol çıktısında renkleri kullan
      printEmojis: true, // Emojileri göster
      dateTimeFormat: DateTimeFormat.none, // Zaman bilgisini gösterme
    ),
    filter: kReleaseMode ? ProductionFilter() : DevelopmentFilter(),
  );

  /// Debug seviyesinde loglama yapar.
  /// 
  /// Sadece geliştirme aşamasında görüntülenir.
  void d(String message) => _logger.d(message);

  /// Bilgi seviyesinde loglama yapar.
  /// 
  /// Uygulamanın normal işleyişi hakkında bilgi verir.
  void i(String message) => _logger.i(message);

  /// Uyarı seviyesinde loglama yapar.
  /// 
  /// Hata olmayan ama dikkat edilmesi gereken durumlar için kullanılır.
  void w(String message) => _logger.w(message);

  /// Hata seviyesinde loglama yapar.
  /// 
  /// Ciddi hata durumlarını loglar.
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Kritik hata seviyesinde loglama yapar.
  /// 
  /// Uygulamanın çalışmasını engelleyen hata durumlarını loglar.
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

// Kolay erişim için global instance
final logger = AppLogger.instance;
