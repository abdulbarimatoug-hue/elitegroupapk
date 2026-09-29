class PushNotificationEntity {
  final String id;
  final String title;
  final String body;
  final String? type; // 'booking_status', 'visa_status', 'custom_trip_quote', 'promo'
  final String? referenceNumber;
  final Map<String, dynamic>? data;
  final DateTime receivedAt;
  final bool isRead;

  const PushNotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.type,
    this.referenceNumber,
    this.data,
    required this.receivedAt,
    this.isRead = false,
  });

  PushNotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? referenceNumber,
    Map<String, dynamic>? data,
    DateTime? receivedAt,
    bool? isRead,
  }) {
    return PushNotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      data: data ?? this.data,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
