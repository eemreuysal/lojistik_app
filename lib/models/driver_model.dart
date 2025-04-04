class Driver {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? email;
  final String? driverLicense;
  final String? nationalId;
  final bool isActive;

  Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.email,
    this.driverLicense,
    this.nationalId,
    required this.isActive,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'] ?? '',
      email: json['email'],
      driverLicense: json['driver_license'],
      nationalId: json['national_id'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'driver_license': driverLicense,
      'national_id': nationalId,
      'is_active': isActive,
    };
  }

  // Sürücünün tam adını döndüren yardımcı metod
  String get fullName {
    return '$firstName $lastName';
  }
}