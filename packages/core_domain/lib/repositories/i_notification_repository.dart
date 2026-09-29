import '../entities/push_notification_entity.dart';

abstract class INotificationRepository {
  /// Request notification permissions (iOS/Android) and get device FCM token
  Future<String?> initializeAndGetToken();

  /// Save or sync user device FCM token in Firestore under /users/{uid}
  Future<void> syncUserFcmToken({
    required String userId,
    required String token,
  });

  /// Listen to incoming foreground notifications stream
  Stream<PushNotificationEntity> watchIncomingNotifications();

  /// Get in-app notification history for a user
  Future<List<PushNotificationEntity>> getUserNotificationHistory(String userId);

  /// Mark notification as read
  Future<void> markNotificationAsRead({
    required String userId,
    required String notificationId,
  });

  /// Admin/System: Send a targeted push notification to a user device
  Future<void> sendNotificationToUser({
    required String targetUserId,
    required String title,
    required String body,
    String? type,
    String? referenceNumber,
    Map<String, dynamic>? extraData,
  });
}
