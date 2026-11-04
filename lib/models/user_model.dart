class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'created_at': createdAt,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      createdAt: createdAt,
    );
  }

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, phone: $phone)';
}
