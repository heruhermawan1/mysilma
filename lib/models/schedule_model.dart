class ScheduleModel {
  final int? id;
  final String userId;
  final String? communityId;
  final int? bookingId;
  final String title;
  final String startAt;  // ISO 8601: YYYY-MM-DDTHH:MM:SS
  final String endAt;    // ISO 8601: YYYY-MM-DDTHH:MM:SS
  final String? notes;

  // JOIN fields
  final String? venueName;
  final String? venueImage;

  ScheduleModel({
    this.id,
    required this.userId,
    this.communityId,
    this.bookingId,
    required this.title,
    required this.startAt,
    required this.endAt,
    this.notes,
    this.venueName,
    this.venueImage,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'],
      userId: map['user_id'] ?? '',
      communityId: map['community_id'],
      bookingId: map['booking_id'],
      title: map['title'] ?? '',
      startAt: map['start_at'] ?? '',
      endAt: map['end_at'] ?? '',
      notes: map['notes'],
      venueName: map['venue_name'],
      venueImage: map['venue_image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'community_id': communityId,
      'booking_id': bookingId,
      'title': title,
      'start_at': startAt,
      'end_at': endAt,
      'notes': notes,
    };
  }

  DateTime get startDateTime => DateTime.parse(startAt);
  DateTime get endDateTime => DateTime.parse(endAt);

  String get dateLabel {
    final dt = startDateTime;
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  }

  String get timeLabel {
    final s = startDateTime;
    final e = endDateTime;
    final pad = (int n) => n.toString().padLeft(2, '0');
    return '${pad(s.hour)}:${pad(s.minute)} – ${pad(e.hour)}:${pad(e.minute)}';
  }

  @override
  String toString() =>
      'ScheduleModel(id: $id, title: $title, start: $startAt)';
}
