import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/custom_trip_request_entity.dart';

class CustomTripRequestModel extends CustomTripRequestEntity {
  const CustomTripRequestModel({
    required super.id,
    required super.referenceNumber,
    required super.userId,
    required super.customerName,
    required super.customerPhone,
    required super.nationality,
    required super.tripType,
    super.businessSector,
    required super.adultsCount,
    required super.childrenCount,
    required super.dedicatedBudgetUsd,
    required super.selectedCityNames,
    required super.selectedCountryNames,
    super.includesVisaAssistance = false,
    required super.departureCity,
    required super.flightClass,
    required super.startDate,
    required super.totalDays,
    required super.packageChoiceType,
    super.readyPackageTitle,
    required super.cityDaysDistribution,
    super.countryTransitPreferences = const {},
    required super.estimatedCalculatedCostUsd,
    required super.airportMeetAndGreet,
    required super.accommodationTypes,
    required super.starRatings,
    super.additionalServices = const [],
    required super.guideLanguage,
    required super.tourType,
    super.selectedInterests = const [],
    required super.targetWhatsAppNumber,
    super.status = CustomTripStatus.pending,
    required super.createdAt,
    super.updatedAt,
    super.notes,
  });

  factory CustomTripRequestModel.fromJson(
      Map<String, dynamic> json, String id) {
    return CustomTripRequestModel(
      id: id,
      referenceNumber: json['referenceNumber'] as String? ?? 'LY-TRIP-0000',
      userId: json['userId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      nationality: json['nationality'] as String? ?? 'ليبي',
      tripType: json['tripType'] as String? ?? 'رحلة عائلية',
      businessSector: json['businessSector'] as String?,
      adultsCount: (json['adultsCount'] as num?)?.toInt() ?? 1,
      childrenCount: (json['childrenCount'] as num?)?.toInt() ?? 0,
      dedicatedBudgetUsd:
          (json['dedicatedBudgetUsd'] as num?)?.toDouble() ?? 1500.0,
      selectedCityNames: (json['selectedCityNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      selectedCountryNames: (json['selectedCountryNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      includesVisaAssistance: json['includesVisaAssistance'] as bool? ?? false,
      departureCity: json['departureCity'] as String? ?? '',
      flightClass: json['flightClass'] as String? ?? 'اقتصادية',
      startDate: json['startDate'] != null
          ? (json['startDate'] as Timestamp).toDate()
          : DateTime.now(),
      totalDays: (json['totalDays'] as num?)?.toInt() ?? 7,
      packageChoiceType: json['packageChoiceType'] as String? ?? 'custom',
      readyPackageTitle: json['readyPackageTitle'] as String?,
      cityDaysDistribution:
          (json['cityDaysDistribution'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, (v as num).toInt()),
              ) ??
              {},
      countryTransitPreferences:
          (json['countryTransitPreferences'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, v.toString()),
              ) ??
              {},
      estimatedCalculatedCostUsd:
          (json['estimatedCalculatedCostUsd'] as num?)?.toDouble() ?? 1500.0,
      airportMeetAndGreet: json['airportMeetAndGreet'] as bool? ?? true,
      accommodationTypes: (json['accommodationTypes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      starRatings: (json['starRatings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      additionalServices: (json['additionalServices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      guideLanguage: json['guideLanguage'] as String? ?? 'عربية',
      tourType: json['tourType'] as String? ?? 'خاصة Private',
      selectedInterests: (json['selectedInterests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      targetWhatsAppNumber:
          json['targetWhatsAppNumber'] as String? ?? '218915919921',
      status: CustomTripStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'pending'),
        orElse: () => CustomTripStatus.pending,
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
      'nationality': nationality,
      'tripType': tripType,
      'businessSector': businessSector,
      'adultsCount': adultsCount,
      'childrenCount': childrenCount,
      'dedicatedBudgetUsd': dedicatedBudgetUsd,
      'selectedCityNames': selectedCityNames,
      'selectedCountryNames': selectedCountryNames,
      'includesVisaAssistance': includesVisaAssistance,
      'departureCity': departureCity,
      'flightClass': flightClass,
      'startDate': Timestamp.fromDate(startDate),
      'totalDays': totalDays,
      'packageChoiceType': packageChoiceType,
      'readyPackageTitle': readyPackageTitle,
      'cityDaysDistribution': cityDaysDistribution,
      'countryTransitPreferences': countryTransitPreferences,
      'estimatedCalculatedCostUsd': estimatedCalculatedCostUsd,
      'airportMeetAndGreet': airportMeetAndGreet,
      'accommodationTypes': accommodationTypes,
      'starRatings': starRatings,
      'additionalServices': additionalServices,
      'guideLanguage': guideLanguage,
      'tourType': tourType,
      'selectedInterests': selectedInterests,
      'targetWhatsAppNumber': targetWhatsAppNumber,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'notes': notes,
    };
  }

  factory CustomTripRequestModel.fromEntity(CustomTripRequestEntity entity) {
    return CustomTripRequestModel(
      id: entity.id,
      referenceNumber: entity.referenceNumber,
      userId: entity.userId,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      nationality: entity.nationality,
      tripType: entity.tripType,
      businessSector: entity.businessSector,
      adultsCount: entity.adultsCount,
      childrenCount: entity.childrenCount,
      dedicatedBudgetUsd: entity.dedicatedBudgetUsd,
      selectedCityNames: entity.selectedCityNames,
      selectedCountryNames: entity.selectedCountryNames,
      includesVisaAssistance: entity.includesVisaAssistance,
      departureCity: entity.departureCity,
      flightClass: entity.flightClass,
      startDate: entity.startDate,
      totalDays: entity.totalDays,
      packageChoiceType: entity.packageChoiceType,
      readyPackageTitle: entity.readyPackageTitle,
      cityDaysDistribution: entity.cityDaysDistribution,
      countryTransitPreferences: entity.countryTransitPreferences,
      estimatedCalculatedCostUsd: entity.estimatedCalculatedCostUsd,
      airportMeetAndGreet: entity.airportMeetAndGreet,
      accommodationTypes: entity.accommodationTypes,
      starRatings: entity.starRatings,
      additionalServices: entity.additionalServices,
      guideLanguage: entity.guideLanguage,
      tourType: entity.tourType,
      selectedInterests: entity.selectedInterests,
      targetWhatsAppNumber: entity.targetWhatsAppNumber,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      notes: entity.notes,
    );
  }
}
