import 'package:equatable/equatable.dart';

enum CustomTripStatus {
  pending, // قيد المراجعة
  inReview, // جارٍ إعداد العرض والتسعير
  quoted, // تم إرسال العرض للعميل
  confirmed, // مؤكد
  cancelled, // ملغى
}

class CustomTripRequestEntity extends Equatable {
  final String id;
  final String referenceNumber; // e.g. "LY-TRIP-2026-5510"
  final String userId;

  // Step 1: Basic Info
  final String customerName;
  final String customerPhone;
  final String nationality;
  final String tripType; // "شهر عسل", "رحلة شبابية", "رحلة عائلية", "رحلة عمل"
  final String? businessSector; // if tripType == "رحلة عمل"
  final int adultsCount;
  final int childrenCount;
  final double dedicatedBudgetUsd;

  // Step 2: Destinations
  final List<String> selectedCityNames;
  final List<String> selectedCountryNames;
  final bool includesVisaAssistance;

  // Step 3: Flight, Package & Days distribution
  final String departureCity;
  final String flightClass; // "اقتصادية", "رجال أعمال"
  final DateTime startDate;
  final int totalDays;
  final String packageChoiceType; // "ready" or "custom"
  final String? readyPackageTitle;
  final Map<String, int> cityDaysDistribution; // e.g. {"إسطنبول": 4, "طرابزون": 3}
  final Map<String, String> countryTransitPreferences; // e.g. {"تركيا": "طيران داخلي"}
  final double estimatedCalculatedCostUsd;

  // Step 4: Reception & Accommodation
  final bool airportMeetAndGreet;
  final List<String> accommodationTypes; // ["فنادق", "منتجعات"]
  final List<String> starRatings; // ["4 نجوم", "5 نجوم"]
  final List<String> additionalServices; // ["تأمين سفر", "شريحة اتصال"]

  // Step 5: Tour Preferences
  final String guideLanguage; // "عربية", "إنجليزية"
  final String tourType; // "خاصة Private", "ضمن مجموعة Group"
  final List<String> selectedInterests; // ["أماكن هادئة", "شواطئ وبحار"]

  // Conversion & Tracking
  final String targetWhatsAppNumber;
  final CustomTripStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;

  const CustomTripRequestEntity({
    required this.id,
    required this.referenceNumber,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.nationality,
    required this.tripType,
    this.businessSector,
    required this.adultsCount,
    required this.childrenCount,
    required this.dedicatedBudgetUsd,
    required this.selectedCityNames,
    required this.selectedCountryNames,
    this.includesVisaAssistance = false,
    required this.departureCity,
    required this.flightClass,
    required this.startDate,
    required this.totalDays,
    required this.packageChoiceType,
    this.readyPackageTitle,
    required this.cityDaysDistribution,
    this.countryTransitPreferences = const {},
    required this.estimatedCalculatedCostUsd,
    required this.airportMeetAndGreet,
    required this.accommodationTypes,
    required this.starRatings,
    this.additionalServices = const [],
    required this.guideLanguage,
    required this.tourType,
    this.selectedInterests = const [],
    required this.targetWhatsAppNumber,
    this.status = CustomTripStatus.pending,
    required this.createdAt,
    this.updatedAt,
    this.notes,
  });

  int get totalTravelers => adultsCount + childrenCount;

  @override
  List<Object?> get props => [
        id,
        referenceNumber,
        userId,
        customerName,
        customerPhone,
        nationality,
        tripType,
        businessSector,
        adultsCount,
        childrenCount,
        dedicatedBudgetUsd,
        selectedCityNames,
        selectedCountryNames,
        includesVisaAssistance,
        departureCity,
        flightClass,
        startDate,
        totalDays,
        packageChoiceType,
        readyPackageTitle,
        cityDaysDistribution,
        countryTransitPreferences,
        estimatedCalculatedCostUsd,
        airportMeetAndGreet,
        accommodationTypes,
        starRatings,
        additionalServices,
        guideLanguage,
        tourType,
        selectedInterests,
        targetWhatsAppNumber,
        status,
        createdAt,
        updatedAt,
        notes,
      ];
}
