class Load {
  final int id;
  final String name;
  final String description;
  final double weight;
  final String type;
  final String? pickupDate;
  final String? deliveryDate;
  final String? status;
  final String? pickupAddress;
  final String? deliveryAddress;
  final double? price; // Ücret bilgisi
  final int? customerId; // Müşteri ID
  final String? customerName; // Müşteri adı
  final String? phoneNumber; // Telefon numarası
  final String? email; // E-posta adresi
  final String? startLocation; // Başlangıç lokasyonu
  final String? endLocation; // Bitiş lokasyonu
  final int? loadPoint; // Yükleme noktası
  final double? quantity; // Miktar
  final String? unit; // Birim (ton, adet, vs.)
  final String? loadingDate; // Yükleme tarihi
  final Map<String, dynamic>? additionalInfo;
  
  Load({
    required this.id,
    required this.name,
    required this.description,
    required this.weight,
    required this.type,
    this.pickupDate,
    this.deliveryDate,
    this.status,
    this.pickupAddress,
    this.deliveryAddress,
    this.additionalInfo,
    this.price,
    this.customerId,
    this.customerName,
    this.phoneNumber,
    this.email,
    this.startLocation,
    this.endLocation,
    this.loadPoint,
    this.quantity,
    this.unit,
    this.loadingDate,
  });

  factory Load.fromJson(Map<String, dynamic> json) {
    return Load(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
      type: json['type'] ?? 'Genel Kargo',
      pickupDate: json['pickup_date'],
      deliveryDate: json['delivery_date'],
      status: json['status'] ?? 'Beklemede',
      pickupAddress: json['pickup_address'],
      deliveryAddress: json['delivery_address'],
      additionalInfo: json['additional_info'],
      price: json['price']?.toDouble(),
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      startLocation: json['start_location'],
      endLocation: json['end_location'],
      loadPoint: json['load_point'],
      quantity: json['quantity']?.toDouble(),
      unit: json['unit'],
      loadingDate: json['loading_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'weight': weight,
      'type': type,
      'pickup_date': pickupDate,
      'delivery_date': deliveryDate,
      'status': status,
      'pickup_address': pickupAddress,
      'delivery_address': deliveryAddress,
      'additional_info': additionalInfo,
      'price': price,
      'customer_id': customerId,
      'customer_name': customerName,
      'phone_number': phoneNumber,
      'email': email,
      'start_location': startLocation,
      'end_location': endLocation,
      'load_point': loadPoint,
      'quantity': quantity,
      'unit': unit,
      'loading_date': loadingDate,
    };
  }

  // Yük durumunu kontrol etmek için yardımcı metod
  bool get isDelivered {
    return status?.toLowerCase() == 'teslim edildi';
  }

  // Yük durumunu kontrol etmek için yardımcı metod
  bool get isInTransit {
    return status?.toLowerCase() == 'taşınıyor';
  }

  // Yük numarasını döndüren yardımcı metod
  String get loadNumber {
    return 'YK-${id.toString().padLeft(4, '0')}';
  }

  // Yük ağırlığını formatlayan yardımcı metod
  String get formattedWeight {
    return '$weight kg';
  }
}