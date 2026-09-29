import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/flight_booking_request_entity.dart';
import 'package:core_domain/failures/failures.dart';
import 'package:core_domain/repositories/i_flight_booking_repository.dart';
import '../models/flight_booking_request_model.dart';

class FlightBookingRepositoryImpl implements IFlightBookingRepository {
  final FirebaseFirestore _firestore;

  FlightBookingRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _flightsRef =>
      _firestore.collection('flight_booking_requests');

  String _generateReferenceNumber() {
    final year = DateTime.now().year;
    final randomNum = 1000 + Random().nextInt(9000);
    return 'LY-FLIGHT-$year-$randomNum';
  }

  @override
  Future<FlightBookingRequestEntity> createFlightBookingRequest(
      FlightBookingRequestEntity request) async {
    try {
      final refNum = request.referenceNumber.isNotEmpty
          ? request.referenceNumber
          : _generateReferenceNumber();

      final model = FlightBookingRequestModel(
        id: '',
        referenceNumber: refNum,
        userId: request.userId,
        customerName: request.customerName,
        customerPhone: request.customerPhone,
        tripType: request.tripType,
        departureCity: request.departureCity,
        arrivalCity: request.arrivalCity,
        departureDate: request.departureDate,
        returnDate: request.returnDate,
        multiCitySegments: request.multiCitySegments,
        adultsCount: request.adultsCount,
        childrenCount: request.childrenCount,
        infantsCount: request.infantsCount,
        baggageAllowance: request.baggageAllowance,
        flightClass: request.flightClass,
        targetWhatsAppNumber: request.targetWhatsAppNumber,
        status: FlightBookingStatus.pending,
        createdAt: DateTime.now(),
      );

      final docRef = await _flightsRef.add(model.toJson());

      return FlightBookingRequestModel(
        id: docRef.id,
        referenceNumber: refNum,
        userId: model.userId,
        customerName: model.customerName,
        customerPhone: model.customerPhone,
        tripType: model.tripType,
        departureCity: model.departureCity,
        arrivalCity: model.arrivalCity,
        departureDate: model.departureDate,
        returnDate: model.returnDate,
        multiCitySegments: model.multiCitySegments,
        adultsCount: model.adultsCount,
        childrenCount: model.childrenCount,
        infantsCount: model.infantsCount,
        baggageAllowance: model.baggageAllowance,
        flightClass: model.flightClass,
        targetWhatsAppNumber: model.targetWhatsAppNumber,
        status: model.status,
        createdAt: model.createdAt,
      );
    } catch (e) {
      throw ServerFailure('فشل حفظ طلب حجز التذاكر: $e');
    }
  }

  @override
  Future<List<FlightBookingRequestEntity>> getCustomerFlightRequests(
      String userId) async {
    try {
      final snapshot = await _flightsRef
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FlightBookingRequestModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب طلبات حجز الطيران: $e');
    }
  }

  @override
  Stream<List<FlightBookingRequestEntity>> watchCustomerFlightRequests(
      String userId) {
    return _flightsRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FlightBookingRequestModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  @override
  Future<List<FlightBookingRequestEntity>> getAllFlightRequests({
    FlightBookingStatus? status,
  }) async {
    try {
      Query query = _flightsRef.orderBy('createdAt', descending: true);
      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => FlightBookingRequestModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب طلبات الطيران للإدارة: $e');
    }
  }

  @override
  Future<void> updateFlightRequestStatus({
    required String requestId,
    required FlightBookingStatus status,
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
        'updatedAt': Timestamp.now(),
      };
      if (notes != null) updates['notes'] = notes;
      await _flightsRef.doc(requestId).update(updates);
    } catch (e) {
      throw ServerFailure('فشل تحديث حالة طلب التذاكر: $e');
    }
  }
}
