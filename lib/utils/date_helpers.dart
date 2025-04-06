import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class DateHelpers {
  // Tarihleri Türkçe formatta göstermek için
  static String formatTurkishDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy', 'tr_TR');
    return formatter.format(date);
  }

  // Kısa tarih formatı - Örnek: 15 Oca
  static String formatShortDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMM', 'tr_TR');
    return formatter.format(date);
  }

  // Tarih aralığı formatı
  static String formatDateRange(DateTime start, DateTime end) {
    return '${formatShortDate(start)} - ${formatShortDate(end)}';
  }

  // String tarihten DateTime nesnesine dönüştürme (çeşitli formatları destekler)
  static DateTime? parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return null;
    }
    
    // 1. ISO formatını dene (yyyy-MM-dd)
    try {
      if (dateStr.contains('-')) {
        return DateTime.parse(dateStr);
      }
    } catch (e) {
      // Sessizce devam et, diğer formatları deneyelim
    }
    
    // 2. Noktalı formatı dene (dd.MM.yyyy)
    try {
      if (dateStr.contains('.')) {
        final parts = dateStr.split('.');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // yıl
            int.parse(parts[1]), // ay
            int.parse(parts[0])  // gün
          );
        }
      }
    } catch (e) {
      // Sessizce devam et, diğer formatları deneyelim
    }
    
    // 3. Eğik çizgili formatı dene (dd/MM/yyyy)
    try {
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // yıl
            int.parse(parts[1]), // ay
            int.parse(parts[0])  // gün
          );
        }
      }
    } catch (e) {
      // Sessizce devam et
    }
    
    // Hiçbir format uymadı
    return null;
  }

  // Türkçe tarih seçici göster - tekli tarih
  static Future<DateTime?> showTurkishDatePicker(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final now = DateTime.now();
    
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(now.year + 2),
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryDark,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textDark,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tarih Seçin',
                        style: AppTheme.manropeBold(18),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(child: child ?? const SizedBox.shrink()),
            ],
          ),
        );
      },
    );
  }

  // Türkçe tarih aralığı seçici göster
  static Future<DateTimeRange?> showTurkishDateRangePicker(
    BuildContext context, {
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange ?? 
          DateTimeRange(
            start: today.subtract(const Duration(days: 7)), 
            end: today,
          ),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(now.year + 2),
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryDark,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textDark,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tarih Aralığı Seçin',
                        style: AppTheme.manropeBold(18),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(child: child ?? const SizedBox.shrink()),
            ],
          ),
        );
      },
    );
  }
  
  // Şu anki hafta için başlangıç ve bitiş tarihlerini elde et
  static DateTimeRange getCurrentWeekRange() {
    final now = DateTime.now();
    // Haftanın başlangıcını hesapla (Pazartesi)
    final startDate = now.subtract(Duration(days: now.weekday - 1));
    // Haftanın sonunu hesapla (Pazar)
    final endDate = startDate.add(const Duration(days: 6));
    
    return DateTimeRange(start: startDate, end: endDate);
  }
  
  // Şu anki ay için başlangıç ve bitiş tarihlerini elde et
  static DateTimeRange getCurrentMonthRange() {
    final now = DateTime.now();
    // Ayın başlangıcı
    final startDate = DateTime(now.year, now.month, 1);
    // Ayın sonu (bir sonraki ayın 0. günü)
    final endDate = DateTime(now.year, now.month + 1, 0);
    
    return DateTimeRange(start: startDate, end: endDate);
  }
  
  // Verilen tarih aralığının şu anki hafta olup olmadığını kontrol et
  static bool isCurrentWeek(DateTimeRange range) {
    final currentWeek = getCurrentWeekRange();
    
    return range.start.year == currentWeek.start.year &&
           range.start.month == currentWeek.start.month &&
           range.start.day == currentWeek.start.day &&
           range.end.year == currentWeek.end.year &&
           range.end.month == currentWeek.end.month &&
           range.end.day == currentWeek.end.day;
  }
  
  // Verilen tarih aralığının şu anki ay olup olmadığını kontrol et
  static bool isCurrentMonth(DateTimeRange range) {
    final currentMonth = getCurrentMonthRange();
    
    return range.start.year == currentMonth.start.year &&
           range.start.month == currentMonth.start.month &&
           range.start.day == currentMonth.start.day &&
           range.end.year == currentMonth.end.year &&
           range.end.month == currentMonth.end.month &&
           range.end.day == currentMonth.end.day;
  }
}