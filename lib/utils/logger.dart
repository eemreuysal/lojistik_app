import 'package:logger/logger.dart';

// Global logger instance
final logger = AppLogger();

class AppLogger {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Metod sayısını gösterme
      errorMethodCount: 5, // Hata detaylarında gösterilecek metod sayısı
      lineLength: 120, // Satır uzunluğu
      colors: true, // Renkli log çıktısı
      printEmojis: true, // Emojiler kullan
      printTime: true, // Zaman göster
    ),
  );

  // Debug seviyesinde log
  void d(String message) {
    _logger.d(message);
  }

  // Info seviyesinde log
  void i(String message) {
    _logger.i(message);
  }

  // Uyarı seviyesinde log
  void w(String message) {
    _logger.w(message);
  }

  // Hata seviyesinde log
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}