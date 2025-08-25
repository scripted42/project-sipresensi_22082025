class User {
  final int id;
  final String nisnNipNik;
  final String name;
  final String? email;
  final String? phone;
  final int roleId;
  final String? photoPath;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.nisnNipNik,
    required this.name,
    this.email,
    this.phone,
    required this.roleId,
    this.photoPath,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      nisnNipNik: json['nisn_nip_nik'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      roleId: json['role_id'] as int? ?? 0,
      photoPath: json['photo_path'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nisn_nip_nik': nisnNipNik,
      'name': name,
      'email': email,
      'phone': phone,
      'role_id': roleId,
      'photo_path': photoPath,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}