class AdminModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String role; // 'superadmin' | 'admin' | 'operator'
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.role = 'admin',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'],
      role: map['role'] ?? 'admin',
      isActive: (map['is_active'] ?? 1) == 1,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() =>
      'AdminModel(id: $id, name: $name, role: $role, isActive: $isActive)';
}
