class Load {
  final int id; // Assuming an ID might be useful
  final String? name;
  final double? price; // Using double for currency
  final String? company;
  final String? startLocation;
  final String? endLocation;
  final int? loadPoint; // Assuming this is a point number/index

  Load({
    required this.id,
    this.name,
    this.price,
    this.company,
    this.startLocation,
    this.endLocation,
    this.loadPoint,
  });

  factory Load.fromJson(Map<String, dynamic> json) {
    return Load(
      id: json['id'],
      name: json['name'],
      // Ensure price is parsed correctly, handle potential String values from API
      price: (json['price'] as num?)?.toDouble(),
      company: json['company'],
      startLocation: json['start_location'],
      endLocation: json['end_location'],
      loadPoint: json['load_point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'company': company,
      'start_location': startLocation,
      'end_location': endLocation,
      'load_point': loadPoint,
    };
  }
}
