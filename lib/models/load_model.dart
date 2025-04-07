class Load {
  final int? id; // Nullable for new records
  final String? customerId; // Müşteri ID
  final String? customerName; // Müşteri Adı
  final String? phoneNumber; // Telefon Numarası
  final String? email; // Mail Adresi
  final String? name; // Yük Adı
  final double? quantity; // Adet
  final String? unit; // Birim
  final DateTime? loadingDate; // Yükleme Tarihi
  final DateTime? deliveryDate; // Teslimat Tarihi
  final double? price; // Tutar
  final String? startLocation;
  final String? endLocation;
  final int? loadPoint;

  Load({
    this.id,
    this.customerId,
    this.customerName,
    this.phoneNumber,
    this.email,
    this.name,
    this.quantity,
    this.unit,
    this.loadingDate,
    this.deliveryDate,
    this.price,
    this.startLocation,
    this.endLocation,
    this.loadPoint,
  });

  factory Load.fromJson(Map<String, dynamic> json) {
    return Load(
      id: json['id'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      name: json['name'],
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'],
      loadingDate: json['loading_date'] != null
          ? DateTime.parse(json['loading_date'])
          : null,
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'])
          : null,
      price: (json['price'] as num?)?.toDouble(),
      startLocation: json['start_location'],
      endLocation: json['end_location'],
      loadPoint: json['load_point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'phone_number': phoneNumber,
      'email': email,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'loading_date': loadingDate?.toIso8601String(),
      'delivery_date': deliveryDate?.toIso8601String(),
      'price': price,
      'start_location': startLocation,
      'end_location': endLocation,
      'load_point': loadPoint,
    };
  }
}
