class BookingModel {
  final int? id;
  final String userId;
  final String venueId;
  final int slotId;
  final String status; // pending | confirmed | cancelled | completed
  final int totalPrice;
  final String? notes;
  final String? createdAt;

  // JOIN fields (opsional, dari query)
  final String? venueName;
  final String? venueImage;
  final String? slotDate;
  final String? startTime;
  final String? endTime;

  BookingModel({
    this.id,
    required this.userId,
    required this.venueId,
    required this.slotId,
    this.status = 'pending',
    required this.totalPrice,
    this.notes,
    this.createdAt,
    this.venueName,
    this.venueImage,
    this.slotDate,
    this.startTime,
    this.endTime,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      userId: map['user_id'] ?? '',
      venueId: map['venue_id'] ?? '',
      slotId: map['slot_id'] ?? 0,
      status: map['status'] ?? 'pending',
      totalPrice: map['total_price'] ?? 0,
      notes: map['notes'],
      createdAt: map['created_at'],
      venueName: map['venue_name'],
      venueImage: map['venue_image'],
      slotDate: map['slot_date'],
      startTime: map['start_time'],
      endTime: map['end_time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'venue_id': venueId,
      'slot_id': slotId,
      'status': status,
      'total_price': totalPrice,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  BookingModel copyWith({String? status, String? notes}) {
    return BookingModel(
      id: id,
      userId: userId,
      venueId: venueId,
      slotId: slotId,
      status: status ?? this.status,
      totalPrice: totalPrice,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      venueName: venueName,
      venueImage: venueImage,
      slotDate: slotDate,
      startTime: startTime,
      endTime: endTime,
    );
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';

  String get timeRange =>
      (startTime != null && endTime != null) ? '$startTime – $endTime' : '-';

  @override
  String toString() =>
      'BookingModel(id: $id, venue: $venueName, date: $slotDate, status: $status)';
}
