import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/push_notification_entity.dart';
import 'package:core_domain/failures/failures.dart';
import 'package:core_domain/repositories/i_notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/push_notification_model.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final FirebaseMessaging _fcm;
  final FirebaseFirestore _firestore;
  final StreamController<PushNotificationEntity> _notificationStreamController =
      StreamController<PushNotificationEntity>.broadcast();

  NotificationRepositoryImpl({
    FirebaseMessaging? fcm,
    FirebaseFirestore? firestore,
  })  : _fcm = fcm ?? FirebaseMessaging.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _listenToForegroundMessages();
  }

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notif = PushNotificationEntity(
          id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
          title: message.notification?.title ?? 'تنبيه من النخبة للسياحة',
          body: message.notification?.body ?? '',
          type: message.data['type'] as String?,
          referenceNumber: message.data['referenceNumber'] as String?,
          data: message.data,
          receivedAt: DateTime.now(),
        );
        _notificationStreamController.add(notif);
      }
    });
  }

  @override
  Future<String?> initializeAndGetToken() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        final token = await _fcm.getToken();
        return token;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> syncUserFcmToken({
    required String userId,
    required String token,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmUpdatedAt': Timestamp.now(),
      });
    } catch (_) {
      // If user profile is not ready yet, silently ignore
    }
  }

  @override
  Stream<PushNotificationEntity> watchIncomingNotifications() {
    return _notificationStreamController.stream;
  }

  @override
  Future<List<PushNotificationEntity>> getUserNotificationHistory(
      String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('receivedAt', descending: true)
          .limit(30)
          .get();

      return snapshot.docs
          .map((doc) => PushNotificationModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب سجل الإشعارات: $e');
    }
  }

  @override
  Future<void> markNotificationAsRead({
    required String userId,
    required String notificationId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw ServerFailure('فشل تحديث حالة الإشعار: $e');
    }
  }

  @override
  Future<void> sendNotificationToUser({
    required String targetUserId,
    required String title,
    required String body,
    String? type,
    String? referenceNumber,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final model = PushNotificationModel(
        id: '',
        title: title,
        body: body,
        type: type,
        referenceNumber: referenceNumber,
        data: extraData,
        receivedAt: DateTime.now(),
        isRead: false,
      );

      // Save in user's in-app notification subcollection
      await _firestore
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .add(model.toJson());
    } catch (e) {
      throw ServerFailure('فشل تسجيل وإرسال الإشعار: $e');
    }
  }
}
