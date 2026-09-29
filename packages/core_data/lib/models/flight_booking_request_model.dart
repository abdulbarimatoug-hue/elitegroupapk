import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/flight_booking_request_entity.dart';

class FlightBookingRequestModel extends FlightBookingRequestEntity {
  const FlightBookingRequestModel({
    required super.id,
    required super.referenceNumber,
    required super.userId,
    required super.customerName,
    required super.customerPhone,
    required super.tripType,
    super.departureCity,
    super.arrivalCity,
    super.departureDate,
    super.returnDate,
    super.multiCitySegments = const [],
    required super.adultsCount,
    super.childrenCount = 0,
    super.infantsCount = 0,
    required super.baggageAllowance,
    required super.flightClass,
    required super.targetWhatsAppNumber,
    super.status = FlightBookingStatus.pending,
    required super.createdAt,
    super.updatedAt,
    super.notes,
  });

  factory FlightBookingRequestModel.fromJson(
      Map<String, dynamic> json, String id) {
    return FlightBookingRequestModel(
      id: id,
      referenceNumber: json['referenceNumber'] as String? ?? 'LY-FLIGHT-0000',
      userId: json['userId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      tripType: FlightTripType.values.firstWhere(
        (t) => t.name == (json['tripType'] as String? ?? 'roundTrip'),
        orElse: () => FlightTripType.roundTrip,
      ),
      departureCity: json['departureCity'] as String?,
      arrivalCity: json['arrivalCity'] as String?,
      departureDate: json['departureDate'] != null
          ? (json['departureDate'] as Timestamp).toDate()
          : null,
      returnDate: json['returnDate'] != null
          ? (json['returnDate'] as Timestamp).toDate()
          : null,
      multiCitySegments: (json['multiCitySegments'] as List<dynamic>?)
              ?.map((seg) => FlightSegment(
                    fromCity: seg['fromCity'] as String? ?? '',
                    toCity: seg['toCity'] as String? ?? '',
                    flightDate: seg['flightDate'] != null
                        ? (seg['flightDate'] as Timestamp).toDate()
                        : DateTime.now(),
                  ))
              .toList() ??
          [],
      adultsCount: (json['adultsCount'] as num?)?.toInt() ?? 1,
      childrenCount: (json['childrenCount'] as num?)?.toInt() ?? 0,
      infantsCount: (json['infantsCount'] as num?)?.toInt() ?? 0,
      baggageAllowance:
          json['baggageAllowance'] as String? ?? '23 كيلو',
      flightClass: json['flightClass'] as String? ?? 'اقتصادية',
      targetWhatsAppNumber:
          json['targetWhatsAppNumber'] as String? ?? '218915919921',
      status: FlightBookingStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'pending'),
        orElse: () => FlightBookingStatus.pending,
      ),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referenceNumber': referenceNumber,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'tripType': tripType.name,
      'departureCity': departureCity,
      'arrivalCity': arrivalCity,
      'departureDate':
          departureDate != null ? Timestamp.fromDate(departureDate!) : null,
      'returnDate':
          returnDate != null ? Timestamp.fromDate(returnDate!) : null,
      'multiCitySegments': multiCitySegments
          .map((seg) => {
                'fromCity': seg.fromCity,
                'toCity': seg.toCity,
                'flightDate': Timestamp.fromDate(seg.flightDate),
              })
          .toList(),
      'adultsCount': adultsCount,
      'childrenCount': childrenCount,
      'infantsCount': infantsCount,
      'baggageAllowance': baggageAllowance,
      'flightClass': flightClass,
      'targetWhatsAppNumber': targetWhatsAppNumber,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'notes': notes,
    };
  }

  factory FlightBookingRequestModel.fromEntity(
      FlightBookingRequestEntity entity) {
    return FlightBookingRequestModel(
      id: entity.id,
      referenceNumber: entity.referenceNumber,
      userId: entity.userId,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      tripType: entity.tripType,
      departureCity: entity.departureCity,
      arrivalCity: entity.arrivalCity,
      departureDate: entity.departureDate,
      returnDate: entity.returnDate,
      multiCitySegments: entity.multiCitySegments,
      adultsCount: entity.adultsCount,
      childrenCount: entity.childrenCount,
      infantsCount: entity.infantsCount,
      baggageAllowance: entity.baggageAllowance,
      flightClass: entity.flightClass,
      targetWhatsAppNumber: entity.targetWhatsAppNumber,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      notes: entity.notes,
    );
  }
}
