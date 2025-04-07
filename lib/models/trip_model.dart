import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'load_model.dart'; // Load modelini import et

class Trip {
  final int id;
  final String startDate;
  final String? endDate;
  final int vehicleId;
  final int? driverId;
  final int? customerId;
  final String? status;
  final String? vehiclePlate;
  final String? driverName;
  final DateTime createdAt;
  final List<Load>? loads; // Yük listesi eklendi

  Trip({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.vehicleId,
    this.driverId,
    this.customerId,
    this.status,
    this.vehiclePlate,
    this.driverName,
    required this.createdAt,
    this.loads, // Constructor'a eklendi
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    // API'den gelen 'loads' listesini işle
    List<Load>? parsedLoads;
    if (json['loads'] != null && json['loads'] is List) {
      parsedLoads = (json['loads'] as List)
          .map((loadJson) => Load.fromJson(loadJson))
          .toList();
    }

    return Trip(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      vehicleId: json['vehicle'],
      driverId: json['driver'],
      customerId: json['customer'],
      status: json['status'] ?? 'Devam Ediyor',
      vehiclePlate: json['vehicle_plate'],
      driverName: json['driver_name'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      loads: parsedLoads, // İşlenen yük listesi atandı
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_date': startDate,
      'end_date': endDate,
      'vehicle': vehicleId,
      'driver': driverId,
      'customer': customerId,
      'status': status,
      // toJson'a loads eklemek isteğe bağlı, genellikle API'ye gönderilmez
      // 'loads': loads?.map((load) => load.toJson()).toList(),
    };
  }

  // Tarih görüntüleme için yardımcı metod - Türkçe
  String get formattedStartDate {
    try {
      // Dil desteğini başlat
      initializeDateFormatting('tr_TR', null);

      // Türkçe tarih formatı
      return DateFormat('dd MMMM yyyy', 'tr_TR')
          .format(DateTime.parse(startDate));
    } catch (e) {
      // Hata durumunda orijinal tarih değerini dön
      return startDate;
    }
  }

  // Kısa tarih formatı (gün ve ay)
  String get shortFormattedStartDate {
    try {
      // Dil desteğini başlat
      initializeDateFormatting('tr_TR', null);

      // Kısa Türkçe tarih formatı
      return DateFormat('dd MMM', 'tr_TR').format(DateTime.parse(startDate));
    } catch (e) {
      // Hata durumunda orijinal tarih değerini dön
      return startDate;
    }
  }

  // Sefer oluşturma tarihi için Türkçe format
  String get formattedCreationDate {
    try {
      // Dil desteğini başlat
      initializeDateFormatting('tr_TR', null);

      // Saat ve tarih formatı - Örnek: 15 Ocak 2024, 14:30
      return DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(createdAt);
    } catch (e) {
      // Hata durumunda saati basit formatta göster
      return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
    }
  }

  // Sefer numarasını döndüren yardımcı metod
  String get tripNumber {
    return 'SF-${id.toString().padLeft(4, '0')}';
  }

  // Sefer durumunu döndüren yardımcı metod
  String get statusText {
    return status ?? 'Devam Ediyor';
  }

  // Duruma göre renk döndüren yardımcı metod
  bool get isActive {
    return status == 'Devam Ediyor';
  }
}
