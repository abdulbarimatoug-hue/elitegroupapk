import 'package:equatable/equatable.dart';

enum VisaRequestStatus {
  pending, // قيد المراجعة
  processing, // قيد المعالجة
  issued, // تم الإصدار
  rejected, // مرفوض
}

class VisaRequestEntity extends Equatable {
  final String id;
  final String referenceNumber; // e.g. "LY-VISA-2026-3021"
  final String visaId;
  final String countryName;
  final String visaTitle;
  final double priceUsd;
  final String processingTime;
  final String userId;
  final String customerName;
  final String customerPhone;
  final VisaRequestStatus status;
  final String targetWhatsAppNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? adminNotes;

  const VisaRequestEntity({
    required this.id,
    required this.referenceNumber,
    required this.visaId,
    required this.countryName,
    required this.visaTitle,
    required this.priceUsd,
    required this.processingTime,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    this.status = VisaRequestStatus.pending,
    required this.targetWhatsAppNumber,
    required this.createdAt,
    this.updatedAt,
    this.adminNotes,
  });

  @override
  List<Object?> get props => [
        id,
        referenceNumber,
        visaId,
        countryName,
        visaTitle,
        priceUsd,
        processingTime,
        userId,
        customerName,
        customerPhone,
        status,
        targetWhatsAppNumber,
        createdAt,
        updatedAt,
        adminNotes,
      ];
}
