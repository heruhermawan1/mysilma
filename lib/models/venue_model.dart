class VenueModel {
  final String id;
  final String name;
  final String location;
  final String? type;
  final double price;
  final double rating;
  final String? image;
  final bool isAvailable;
  final String? createdAt;

  VenueModel({
    required this.id,
    required this.name,
    required this.location,
    this.type,
    required this.price,
    this.rating = 0.0,
    this.image,
    this.isAvailable = true,
    this.createdAt,
  });

  factory VenueModel.fromMap(Map<String, dynamic> map) {
    return VenueModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      type: map['type'],
      price: (map['price'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0.0).toDouble(),
      image: map['image'],
      isAvailable: (map['is_available'] ?? 1) == 1,
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'type': type,
      'price': price,
      'rating': rating,
      'image': image,
      'is_available': isAvailable ? 1 : 0,
      'created_at': createdAt,
    };
  }

  VenueModel copyWith({
    String? name,
    String? location,
    String? type,
    double? price,
    double? rating,
    String? image,
    bool? isAvailable,
  }) {
    return VenueModel(
      id: id,
      name: name ?? this.name,
      location: location ?? this.location,
      type: type ?? this.type,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt,
    );
  }

  @override
  String toString() =>
      'VenueModel(id: $id, name: $name, price: $price, rating: $rating)';
}
