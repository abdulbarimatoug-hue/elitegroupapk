import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/push_notification_entity.dart';
import '../models/push_notification_model.dart';

class PushNotificationModel extends PushNotificationEntity {
  const PushNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    super.type,
    super.referenceNumber,
    super.data,
    required super.receivedAt,
    super.isRead,
  });

  factory PushNotificationModel.fromJson(Map<String, dynamic> json, String id) {
    return PushNotificationModel(
      id: id,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String?,
      referenceNumber: json['referenceNumber'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      receivedAt: json['receivedAt'] is Timestamp
          ? (json['receivedAt'] as Timestamp).toDate()
          : (json['receivedAt'] != null
              ? DateTime.tryParse(json['receivedAt'].toString()) ?? DateTime.now()
              : DateTime.now()),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'referenceNumber': referenceNumber,
      'data': data,
      'receivedAt': Timestamp.fromDate(receivedAt),
      'isRead': isRead,
    };
  }

  factory PushNotificationModel.fromEntity(PushNotificationEntity entity) {
    return PushNotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      referenceNumber: entity.referenceNumber,
      data: entity.data,
      receivedAt: entity.receivedAt,
      isRead: entity.isRead,
    );
  }
}
