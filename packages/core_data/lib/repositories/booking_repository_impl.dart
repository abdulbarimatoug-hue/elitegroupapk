import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/booking_entity.dart';
import 'package:core_domain/failures/failures.dart';
import 'package:core_domain/repositories/i_booking_repository.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements IBookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _bookingsRef => _firestore.collection('bookings');

  String _generateReferenceNumber() {
    final year = DateTime.now().year;
    final randomNum = 1000 + Random().nextInt(9000);
    return 'LY-PKG-$year-$randomNum';
  }

  @override
  Future<BookingEntity> createBooking(BookingEntity booking) async {
    try {
      final refNumber = booking.referenceNumber.isNotEmpty
          ? booking.referenceNumber
          : _generateReferenceNumber();

      final model = BookingModel(
        id: '', // Will be assigned by Firestore
        referenceNumber: refNumber,
        packageId: booking.packageId,
        packageTitle: booking.packageTitle,
        packageDestination: booking.packageDestination,
        userId: booking.userId,
        customerName: booking.customerName,
        customerPhone: booking.customerPhone,
        startDate: booking.startDate,
        returnDate: booking.returnDate,
        durationDays: booking.durationDays,
        adultsCount: booking.adultsCount,
        childrenCount: booking.childrenCount,
        estimatedTotal: booking.estimatedTotal,
        notes: booking.notes,
        status: BookingStatus.pending,
        targetWhatsAppNumber: booking.targetWhatsAppNumber,
        createdAt: DateTime.now(),
      );

      final docRef = await _bookingsRef.add(model.toJson());

      return BookingModel(
        id: docRef.id,
        referenceNumber: refNumber,
        packageId: model.packageId,
        packageTitle: model.packageTitle,
        packageDestination: model.packageDestination,
        userId: model.userId,
        customerName: model.customerName,
        customerPhone: model.customerPhone,
        startDate: model.startDate,
        returnDate: model.returnDate,
        durationDays: model.durationDays,
        adultsCount: model.adultsCount,
        childrenCount: model.childrenCount,
        estimatedTotal: model.estimatedTotal,
        notes: model.notes,
        status: model.status,
        targetWhatsAppNumber: model.targetWhatsAppNumber,
        createdAt: model.createdAt,
      );
    } catch (e) {
      throw ServerFailure('فشل حفظ طلب الحجز: $e');
    }
  }

  @override
  Future<List<BookingEntity>> getCustomerBookings(String userId) async {
    try {
      final snapshot = await _bookingsRef
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب سجل الحجوزات: $e');
    }
  }

  @override
  Stream<List<BookingEntity>> watchCustomerBookings(String userId) {
    return _bookingsRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BookingModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _bookingsRef.doc(bookingId).update({
        'status': BookingStatus.cancelled.name,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw ServerFailure('فشل إلغاء الحجز: $e');
    }
  }

  @override
  Future<List<BookingEntity>> getAllBookings({
    BookingStatus? status,
    DateTime? fromDate,
  }) async {
    try {
      Query query = _bookingsRef.orderBy('createdAt', descending: true);

      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }

      if (fromDate != null) {
        query = query.where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate));
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => BookingModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب كافة الحجوزات للإدارة: $e');
    }
  }

  @override
  Future<void> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
    try {
      await _bookingsRef.doc(bookingId).update({
        'status': status.name,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw ServerFailure('فشل تحديث حالة الحجز: $e');
    }
  }
}
