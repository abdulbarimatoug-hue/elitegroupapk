import 'package:equatable/equatable.dart';

/// City available in Custom Trip Builder
class BuilderCity extends Equatable {
  final String id;
  final String name;
  final String countryId;
  final String countryName;
  final String? iconName;
  final String gradientStart;
  final String gradientEnd;
  final double estimatedDailyCostUsd;

  const BuilderCity({
    required this.id,
    required this.name,
    required this.countryId,
    required this.countryName,
    this.iconName,
    required this.gradientStart,
    required this.gradientEnd,
    required this.estimatedDailyCostUsd,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        countryId,
        countryName,
        iconName,
        gradientStart,
        gradientEnd,
        estimatedDailyCostUsd,
      ];
}

/// Country grouping for Custom Trip Builder
class BuilderCountry extends Equatable {
  final String id;
  final String name;
  final String code;
  final bool requiresVisa;
  final double? visaPriceUsd;
  final String? visaProcessingTime;
  final List<BuilderCity> cities;

  const BuilderCountry({
    required this.id,
    required this.name,
    required this.code,
    this.requiresVisa = false,
    this.visaPriceUsd,
    this.visaProcessingTime,
    this.cities = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        requiresVisa,
        visaPriceUsd,
        visaProcessingTime,
        cities,
      ];
}

/// Ready package suggestion in Step 3
class ReadyPackageOption extends Equatable {
  final String id;
  final String title;
  final int daysCount;
  final int toursCount;
  final double basePriceUsd;
  final String description;

  const ReadyPackageOption({
    required this.id,
    required this.title,
    required this.daysCount,
    required this.toursCount,
    required this.basePriceUsd,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, daysCount, toursCount, basePriceUsd, description];
}

/// Master configuration for the 6-step Custom Trip Designer
class TripBuilderConfigEntity extends Equatable {
  final double minimumBudgetUsd; // Default: 1500
  final List<String> nationalities;
  final List<String> businessSectors;
  final List<BuilderCountry> countries;
  final List<ReadyPackageOption> readyPackages;
  final List<String> transitOptions; // e.g. "طيران داخلي", "سيارة خاصة مع سائق", "قطار سريع", "حافلة سياحية"
  final List<String> accommodationTypes; // e.g. "فنادق", "منتجعات فاخرة", "شقق مفروشة"
  final List<String> starRatings; // e.g. "3 نجوم", "4 نجوم", "5 نجوم"
  final List<String> additionalServices; // e.g. "تأمين سفر دولي", "شريحة إنترنت واتصال", "جولات هليكوبتر"
  final List<String> tourInterests; // e.g. "شواطئ وبحار", "طبيعة وجبال", "تاريخ وثقافة", "تسوق ومولات"

  const TripBuilderConfigEntity({
    this.minimumBudgetUsd = 1500.0,
    required this.nationalities,
    required this.businessSectors,
    required this.countries,
    required this.readyPackages,
    required this.transitOptions,
    required this.accommodationTypes,
    required this.starRatings,
    required this.additionalServices,
    required this.tourInterests,
  });

  @override
  List<Object?> get props => [
        minimumBudgetUsd,
        nationalities,
        businessSectors,
        countries,
        readyPackages,
        transitOptions,
        accommodationTypes,
        starRatings,
        additionalServices,
        tourInterests,
      ];
}
