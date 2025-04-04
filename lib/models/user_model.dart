class User {
  final int id;
  final String username;
  final String email;
  final String? role;
  final String? firstName;
  final String? lastName;
  final String? companyName;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.role,
    this.firstName,
    this.lastName,
    this.companyName,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      companyName: json['company_name'],
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'company_name': companyName,
      'profile_image_url': profileImageUrl,
    };
  }

  // Kullanıcının tam adını döndüren yardımcı metod
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else {
      return username;
    }
  }

  // Profil avatarı için baş harfleri döndüren yardımcı metod
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}';
    } else if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0];
    } else if (lastName != null && lastName!.isNotEmpty) {
      return lastName![0];
    } else if (username.isNotEmpty) {
      return username[0];
    } else {
      return '';
    }
  }

  // Kullanıcının şirket yöneticisi olup olmadığını kontrol eden yardımcı metod
  bool get isAdmin {
    return role == 'admin';
  }

  // Kullanıcının şoför olup olmadığını kontrol eden yardımcı metod
  bool get isDriver {
    return role == 'driver';
  }
}