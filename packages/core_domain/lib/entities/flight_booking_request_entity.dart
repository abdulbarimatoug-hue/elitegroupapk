import 'package:equatable/equatable.dart';

enum FlightTripType {
  roundTrip, // ذهاب وعودة
  oneWay, // ذهاب فقط
  multiCity, // مدن متعددة
}

enum FlightBookingStatus {
  pending, // قيد المراجعة
  processing, // قيد البحث عن أفضل الأسعار
  confirmed, // تم إصدار التذاكر
  cancelled, // ملغى
}

class FlightSegment extends Equatable {
  final String fromCity;
  final String toCity;
  final DateTime flightDate;

  const FlightSegment({
    required this.fromCity,
    required this.toCity,
    required this.flightDate,
  });

  @override
  List<Object?> get props => [fromCity, toCity, flightDate];
}

class FlightBookingRequestEntity extends Equatable {
  final String id;
  final String referenceNumber; // e.g. "LY-FLIGHT-2026-8802"
  final String userId;
  final String customerName;
  final String customerPhone;

  final FlightTripType tripType;
  final String? departureCity;
  final String? arrivalCity;
  final DateTime? departureDate;
  final DateTime? returnDate;

  final List<FlightSegment> multiCitySegments;

  final int adultsCount;
  final int childrenCount; // 2 - 12 years
  final int infantsCount; // under 2 years

  final String baggageAllowance; // "بدون وزن", "8 كيلو حقيبة يد", "15 كيلو", "23 كيلو", "40 كيلو"
  final String flightClass; // "اقتصادية", "رجال أعمال"

  final String targetWhatsAppNumber;
  final FlightBookingStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;

  const FlightBookingRequestEntity({
    required this.id,
    required this.referenceNumber,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.tripType,
    this.departureCity,
    this.arrivalCity,
    this.departureDate,
    this.returnDate,
    this.multiCitySegments = const [],
    required this.adultsCount,
    this.childrenCount = 0,
    this.infantsCount = 0,
    required this.baggageAllowance,
    required this.flightClass,
    required this.targetWhatsAppNumber,
    this.status = FlightBookingStatus.pending,
    required this.createdAt,
    this.updatedAt,
    this.notes,
  });

  int get totalPassengers => adultsCount + childrenCount + infantsCount;

  @override
  List<Object?> get props => [
        id,
        referenceNumber,
        userId,
        customerName,
        customerPhone,
        tripType,
        departureCity,
        arrivalCity,
        departureDate,
        returnDate,
        multiCitySegments,
        adultsCount,
        childrenCount,
        infantsCount,
        baggageAllowance,
        flightClass,
        targetWhatsAppNumber,
        status,
        createdAt,
        updatedAt,
        notes,
      ];
}
