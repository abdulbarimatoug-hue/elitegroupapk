import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/visa_request_entity.dart';

class VisaRequestModel extends VisaRequestEntity {
  const VisaRequestModel({
    required super.id,
    required super.referenceNumber,
    required super.visaId,
    required super.countryName,
    required super.visaTitle,
    required super.priceUsd,
    required super.processingTime,
    required super.userId,
    required super.customerName,
    required super.customerPhone,
    super.status = VisaRequestStatus.pending,
    required super.targetWhatsAppNumber,
    required super.createdAt,
    super.updatedAt,
    super.adminNotes,
  });

  factory VisaRequestModel.fromJson(Map<String, dynamic> json, String id) {
    return VisaRequestModel(
      id: id,
      referenceNumber: json['referenceNumber'] as String? ?? 'LY-VISA-0000',
      visaId: json['visaId'] as String? ?? '',
      countryName: json['countryName'] as String? ?? '',
      visaTitle: json['visaTitle'] as String? ?? '',
      priceUsd: (json['priceUsd'] as num?)?.toDouble() ?? 0.0,
      processingTime: json['processingTime'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      status: VisaRequestStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'pending'),
        orElse: () => VisaRequestStatus.pending,
      ),
      targetWhatsAppNumber:
          json['targetWhatsAppNumber'] as String? ?? '218915919921',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      adminNotes: json['adminNotes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referenceNumber': referenceNumber,
      'visaId': visaId,
      'countryName': countryName,
      'visaTitle': visaTitle,
      'priceUsd': priceUsd,
      'processingTime': processingTime,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'status': status.name,
      'targetWhatsAppNumber': targetWhatsAppNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'adminNotes': adminNotes,
    };
  }

  factory VisaRequestModel.fromEntity(VisaRequestEntity entity) {
    return VisaRequestModel(
      id: entity.id,
      referenceNumber: entity.referenceNumber,
      visaId: entity.visaId,
      countryName: entity.countryName,
      visaTitle: entity.visaTitle,
      priceUsd: entity.priceUsd,
      processingTime: entity.processingTime,
      userId: entity.userId,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      status: entity.status,
      targetWhatsAppNumber: entity.targetWhatsAppNumber,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      adminNotes: entity.adminNotes,
    );
  }
}
