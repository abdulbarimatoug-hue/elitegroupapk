import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.referenceNumber,
    required super.packageId,
    required super.packageTitle,
    required super.packageDestination,
    required super.userId,
    required super.customerName,
    required super.customerPhone,
    required super.startDate,
    required super.returnDate,
    required super.durationDays,
    required super.adultsCount,
    required super.childrenCount,
    required super.estimatedTotal,
    super.notes,
    super.status = BookingStatus.pending,
    required super.targetWhatsAppNumber,
    required super.createdAt,
    super.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json, String id) {
    return BookingModel(
      id: id,
      referenceNumber: json['referenceNumber'] as String? ?? 'LY-PKG-0000',
      packageId: json['packageId'] as String? ?? '',
      packageTitle: json['packageTitle'] as String? ?? '',
      packageDestination: json['packageDestination'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      startDate: json['startDate'] != null
          ? (json['startDate'] as Timestamp).toDate()
          : DateTime.now(),
      returnDate: json['returnDate'] != null
          ? (json['returnDate'] as Timestamp).toDate()
          : DateTime.now().add(const Duration(days: 7)),
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 7,
      adultsCount: (json['adultsCount'] as num?)?.toInt() ?? 1,
      childrenCount: (json['childrenCount'] as num?)?.toInt() ?? 0,
      estimatedTotal: (json['estimatedTotal'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      status: BookingStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      targetWhatsAppNumber:
          json['targetWhatsAppNumber'] as String? ?? '218915919921',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referenceNumber': referenceNumber,
      'packageId': packageId,
      'packageTitle': packageTitle,
      'packageDestination': packageDestination,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'startDate': Timestamp.fromDate(startDate),
      'returnDate': Timestamp.fromDate(returnDate),
      'durationDays': durationDays,
      'adultsCount': adultsCount,
      'childrenCount': childrenCount,
      'estimatedTotal': estimatedTotal,
      'notes': notes,
      'status': status.name,
      'targetWhatsAppNumber': targetWhatsAppNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      referenceNumber: entity.referenceNumber,
      packageId: entity.packageId,
      packageTitle: entity.packageTitle,
      packageDestination: entity.packageDestination,
      userId: entity.userId,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      startDate: entity.startDate,
      returnDate: entity.returnDate,
      durationDays: entity.durationDays,
      adultsCount: entity.adultsCount,
      childrenCount: entity.childrenCount,
      estimatedTotal: entity.estimatedTotal,
      notes: entity.notes,
      status: entity.status,
      targetWhatsAppNumber: entity.targetWhatsAppNumber,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
