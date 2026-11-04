class CommunityModel {
  final String id;
  final String title;
  final String? sport;
  final String? venueId;
  final String? eventDate;    // YYYY-MM-DD
  final String? startTime;    // HH:MM
  final String? endTime;      // HH:MM
  final int maxParticipants;
  final String? organizerId;
  final int? bookingId;
  final String? createdAt;

  // JOIN fields
  final String? venueName;
  final String? organizerName;

  CommunityModel({
    required this.id,
    required this.title,
    this.sport,
    this.venueId,
    this.eventDate,
    this.startTime,
    this.endTime,
    this.maxParticipants = 0,
    this.organizerId,
    this.bookingId,
    this.createdAt,
    this.venueName,
    this.organizerName,
  });

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      sport: map['sport'],
      venueId: map['venue_id'],
      eventDate: map['event_date'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      maxParticipants: map['max_participants'] ?? 0,
      organizerId: map['organizer_id'],
      bookingId: map['booking_id'],
      createdAt: map['created_at'],
      venueName: map['venue_name'],
      organizerName: map['organizer_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'sport': sport,
      'venue_id': venueId,
      'event_date': eventDate,
      'start_time': startTime,
      'end_time': endTime,
      'max_participants': maxParticipants,
      'organizer_id': organizerId,
      'booking_id': bookingId,
      'created_at': createdAt,
    };
  }

  String get timeRange =>
      (startTime != null && endTime != null) ? '$startTime – $endTime' : '-';

  @override
  String toString() =>
      'CommunityModel(id: $id, title: $title, date: $eventDate, venue: $venueName)';
}

class CommunityParticipantModel {
  final String communityId;
  final String userId;
  final String? joinedAt;

  CommunityParticipantModel({
    required this.communityId,
    required this.userId,
    this.joinedAt,
  });

  factory CommunityParticipantModel.fromMap(Map<String, dynamic> map) {
    return CommunityParticipantModel(
      communityId: map['community_id'] ?? '',
      userId: map['user_id'] ?? '',
      joinedAt: map['joined_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'community_id': communityId,
      'user_id': userId,
      'joined_at': joinedAt,
    };
  }
}
