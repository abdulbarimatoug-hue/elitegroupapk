import 'package:equatable/equatable.dart';

enum BookingStatus {
  pending, // قيد المراجعة
  confirmed, // مؤكد
  cancelled, // ملغى
  completed, // مكتمل
}

class BookingEntity extends Equatable {
  final String id;
  final String referenceNumber; // e.g. "LY-PKG-2026-1049"
  final String packageId;
  final String packageTitle;
  final String packageDestination;
  final String userId;
  final String customerName;
  final String customerPhone;
  final DateTime startDate;
  final DateTime returnDate;
  final int durationDays;
  final int adultsCount;
  final int childrenCount;
  final double estimatedTotal;
  final String? notes;
  final BookingStatus status;
  final String targetWhatsAppNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BookingEntity({
    required this.id,
    required this.referenceNumber,
    required this.packageId,
    required this.packageTitle,
    required this.packageDestination,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.startDate,
    required this.returnDate,
    required this.durationDays,
    required this.adultsCount,
    required this.childrenCount,
    required this.estimatedTotal,
    this.notes,
    this.status = BookingStatus.pending,
    required this.targetWhatsAppNumber,
    required this.createdAt,
    this.updatedAt,
  });

  int get totalTravelers => adultsCount + childrenCount;

  @override
  List<Object?> get props => [
        id,
        referenceNumber,
        packageId,
        packageTitle,
        packageDestination,
        userId,
        customerName,
        customerPhone,
        startDate,
        returnDate,
        durationDays,
        adultsCount,
        childrenCount,
        estimatedTotal,
        notes,
        status,
        targetWhatsAppNumber,
        createdAt,
        updatedAt,
      ];
}
