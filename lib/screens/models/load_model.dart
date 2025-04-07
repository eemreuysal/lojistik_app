class Load {
  final int id;
  final String? name;
  final double? price;
  final String? customerName;
  final String? startLocation;
  final String? endLocation;
  final int? loadPoint;
  final String? unit;
  final double? quantity;
  final String? description;
  final double? weight;
  final String? type;
  final String? loadingDate;
  final String? deliveryDate;
  final String? pickupDate;

  Load({
    required this.id,
    this.name,
    this.price,
    this.customerName,
    this.startLocation,
    this.endLocation,
    this.loadPoint,
    this.unit,
    this.quantity,
    this.description,
    this.weight,
    this.type,
    this.loadingDate,
    this.deliveryDate,
    this.pickupDate,
  });

  factory Load.fromJson(Map<String, dynamic> json) {
    return Load(
      id: json['id'],
      name: json['name'],
      price: json['price']?.toDouble(),
      customerName: json['customer_name'],
      startLocation: json['start_location'],
      endLocation: json['end_location'],
      loadPoint: json['load_point'],
      unit: json['unit'],
      quantity: json['quantity']?.toDouble(),
      description: json['description'],
      weight: json['weight']?.toDouble(),
      type: json['type'],
      loadingDate: json['loading_date'],
      deliveryDate: json['delivery_date'],
      pickupDate: json['pickup_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'customer_name': customerName,
      'start_location': startLocation,
      'end_location': endLocation,
      'load_point': loadPoint,
      'unit': unit,
      'quantity': quantity,
      'description': description,
      'weight': weight,
      'type': type,
      'loading_date': loadingDate,
      'delivery_date': deliveryDate,
      'pickup_date': pickupDate,
    };
  }
}