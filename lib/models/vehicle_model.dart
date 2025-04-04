class Vehicle {
  final int id;
  final String plateNumber;
  final String brand;
  final String? model;
  final int? modelYear;
  final String? color;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.brand,
    this.model,
    this.modelYear,
    this.color,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      plateNumber: json['plate_number'],
      brand: json['brand'],
      model: json['model'],
      modelYear: json['model_year'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plate_number': plateNumber,
      'brand': brand,
      'model': model,
      'model_year': modelYear,
      'color': color,
    };
  }

  // Aracın marka ve modelini birleştiren yardımcı metod
  String get fullName {
    if (model != null) {
      return '$brand $model';
    }
    return brand;
  }
}