import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/visa_entity.dart';
import 'package:core_domain/entities/visa_request_entity.dart';
import 'package:core_domain/failures/failures.dart';
import 'package:core_domain/repositories/i_visa_repository.dart';
import '../models/visa_model.dart';
import '../models/visa_request_model.dart';

class VisaRepositoryImpl implements IVisaRepository {
  final FirebaseFirestore _firestore;

  VisaRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _catalogRef => _firestore.collection('visa_catalog');
  CollectionReference get _requestsRef => _firestore.collection('visa_requests');

  String _generateReferenceNumber() {
    final year = DateTime.now().year;
    final randomNum = 1000 + Random().nextInt(9000);
    return 'LY-VISA-$year-$randomNum';
  }

  @override
  Future<List<VisaEntity>> getVisaCatalog() async {
    try {
      final snapshot = await _catalogRef.where('isActive', isEqualTo: true).get();
      return snapshot.docs
          .map((doc) => VisaModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب قائمة التأشيرات: $e');
    }
  }

  @override
  Stream<List<VisaEntity>> watchVisaCatalog() {
    return _catalogRef.where('isActive', isEqualTo: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => VisaModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  @override
  Future<VisaEntity?> getVisaById(String visaId) async {
    try {
      final doc = await _catalogRef.doc(visaId).get();
      if (!doc.exists) return null;
      return VisaModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw ServerFailure('تعذر جلب تفاصيل التأشيرة: $e');
    }
  }

  @override
  Future<VisaRequestEntity> createVisaRequest(VisaRequestEntity request) async {
    try {
      final refNum = request.referenceNumber.isNotEmpty
          ? request.referenceNumber
          : _generateReferenceNumber();

      final model = VisaRequestModel(
        id: '',
        referenceNumber: refNum,
        visaId: request.visaId,
        countryName: request.countryName,
        visaTitle: request.visaTitle,
        priceUsd: request.priceUsd,
        processingTime: request.processingTime,
        userId: request.userId,
        customerName: request.customerName,
        customerPhone: request.customerPhone,
        status: VisaRequestStatus.pending,
        targetWhatsAppNumber: request.targetWhatsAppNumber,
        createdAt: DateTime.now(),
      );

      final docRef = await _requestsRef.add(model.toJson());

      return VisaRequestModel(
        id: docRef.id,
        referenceNumber: refNum,
        visaId: model.visaId,
        countryName: model.countryName,
        visaTitle: model.visaTitle,
        priceUsd: model.priceUsd,
        processingTime: model.processingTime,
        userId: model.userId,
        customerName: model.customerName,
        customerPhone: model.customerPhone,
        status: model.status,
        targetWhatsAppNumber: model.targetWhatsAppNumber,
        createdAt: model.createdAt,
      );
    } catch (e) {
      throw ServerFailure('فشل تقديم طلب التأشيرة: $e');
    }
  }

  @override
  Future<List<VisaRequestEntity>> getCustomerVisaRequests(String userId) async {
    try {
      final snapshot = await _requestsRef
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VisaRequestModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب طلبات التأشيرة: $e');
    }
  }

  @override
  Stream<List<VisaRequestEntity>> watchCustomerVisaRequests(String userId) {
    return _requestsRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => VisaRequestModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  @override
  Future<List<VisaRequestEntity>> getAllVisaRequests({
    VisaRequestStatus? status,
  }) async {
    try {
      Query query = _requestsRef.orderBy('createdAt', descending: true);
      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => VisaRequestModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب طلبات التأشيرات للإدارة: $e');
    }
  }

  @override
  Future<void> updateVisaRequestStatus({
    required String requestId,
    required VisaRequestStatus status,
    String? adminNotes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
        'updatedAt': Timestamp.now(),
      };
      if (adminNotes != null) updates['adminNotes'] = adminNotes;
      await _requestsRef.doc(requestId).update(updates);
    } catch (e) {
      throw ServerFailure('فشل تعديل حالة طلب التأشيرة: $e');
    }
  }

  @override
  Future<String> addVisaCountry(VisaEntity visa) async {
    try {
      final model = VisaModel.fromEntity(visa);
      final docRef = await _catalogRef.add(model.toJson());
      return docRef.id;
    } catch (e) {
      throw ServerFailure('فشل إضافة دولة التأشيرة: $e');
    }
  }

  @override
  Future<void> updateVisaCountry(VisaEntity visa) async {
    try {
      final model = VisaModel.fromEntity(visa);
      await _catalogRef.doc(visa.id).update(model.toJson());
    } catch (e) {
      throw ServerFailure('فشل تعديل بيانات التأشيرة: $e');
    }
  }

  @override
  Future<void> deleteVisaCountry(String visaId) async {
    try {
      await _catalogRef.doc(visaId).delete();
    } catch (e) {
      throw ServerFailure('فشل حذف دولة التأشيرة: $e');
    }
  }
}
