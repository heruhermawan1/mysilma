class SlotModel {
  final int? id;
  final String venueId;
  final String slotDate;   // format: YYYY-MM-DD
  final String startTime;  // format: HH:MM
  final String endTime;    // format: HH:MM
  final double price;
  final bool isAvailable;

  SlotModel({
    this.id,
    required this.venueId,
    required this.slotDate,
    required this.startTime,
    required this.endTime,
    required this.price,
    this.isAvailable = true,
  });

  factory SlotModel.fromMap(Map<String, dynamic> map) {
    return SlotModel(
      id: map['id'],
      venueId: map['venue_id'] ?? '',
      slotDate: map['slot_date'] ?? '',
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      isAvailable: (map['is_available'] ?? 1) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'venue_id': venueId,
      'slot_date': slotDate,
      'start_time': startTime,
      'end_time': endTime,
      'price': price,
      'is_available': isAvailable ? 1 : 0,
    };
  }

  String get timeRange => '$startTime – $endTime';

  @override
  String toString() =>
      'SlotModel(id: $id, date: $slotDate, time: $timeRange, available: $isAvailable)';
}
