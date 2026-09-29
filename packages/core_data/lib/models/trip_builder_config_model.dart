import 'package:core_domain/entities/trip_builder_config_entity.dart';

class TripBuilderConfigModel extends TripBuilderConfigEntity {
  const TripBuilderConfigModel({
    super.minimumBudgetUsd = 1500.0,
    required super.nationalities,
    required super.businessSectors,
    required super.countries,
    required super.readyPackages,
    required super.transitOptions,
    required super.accommodationTypes,
    required super.starRatings,
    required super.additionalServices,
    required super.tourInterests,
  });

  factory TripBuilderConfigModel.fromJson(Map<String, dynamic> json) {
    return TripBuilderConfigModel(
      minimumBudgetUsd:
          (json['minimumBudgetUsd'] as num?)?.toDouble() ?? 1500.0,
      nationalities: (json['nationalities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      businessSectors: (json['businessSectors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      countries: (json['countries'] as List<dynamic>?)?.map((c) {
            final citiesList = (c['cities'] as List<dynamic>?)?.map((city) {
                  return BuilderCity(
                    id: city['id']?.toString() ?? '',
                    name: city['name']?.toString() ?? '',
                    countryId: city['countryId']?.toString() ?? '',
                    countryName: city['countryName']?.toString() ?? '',
                    iconName: city['iconName']?.toString(),
                    gradientStart: city['gradientStart']?.toString() ?? '#0E2A47',
                    gradientEnd: city['gradientEnd']?.toString() ?? '#C9A227',
                    estimatedDailyCostUsd:
                        (city['estimatedDailyCostUsd'] as num?)?.toDouble() ??
                            120.0,
                  );
                }).toList() ??
                [];

            return BuilderCountry(
              id: c['id']?.toString() ?? '',
              name: c['name']?.toString() ?? '',
              code: c['code']?.toString() ?? '',
              requiresVisa: c['requiresVisa'] as bool? ?? false,
              visaPriceUsd: (c['visaPriceUsd'] as num?)?.toDouble(),
              visaProcessingTime: c['visaProcessingTime']?.toString(),
              cities: citiesList,
            );
          }).toList() ??
          [],
      readyPackages: (json['readyPackages'] as List<dynamic>?)?.map((p) {
            return ReadyPackageOption(
              id: p['id']?.toString() ?? '',
              title: p['title']?.toString() ?? '',
              daysCount: (p['daysCount'] as num?)?.toInt() ?? 7,
              toursCount: (p['toursCount'] as num?)?.toInt() ?? 3,
              basePriceUsd: (p['basePriceUsd'] as num?)?.toDouble() ?? 800.0,
              description: p['description']?.toString() ?? '',
            );
          }).toList() ??
          [],
      transitOptions: (json['transitOptions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
      tourInterests: (json['tourInterests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minimumBudgetUsd': minimumBudgetUsd,
      'nationalities': nationalities,
      'businessSectors': businessSectors,
      'countries': countries
          .map((c) => {
                'id': c.id,
                'name': c.name,
                'code': c.code,
                'requiresVisa': c.requiresVisa,
                'visaPriceUsd': c.visaPriceUsd,
                'visaProcessingTime': c.visaProcessingTime,
                'cities': c.cities
                    .map((city) => {
                          'id': city.id,
                          'name': city.name,
                          'countryId': city.countryId,
                          'countryName': city.countryName,
                          'iconName': city.iconName,
                          'gradientStart': city.gradientStart,
                          'gradientEnd': city.gradientEnd,
                          'estimatedDailyCostUsd': city.estimatedDailyCostUsd,
                        })
                    .toList(),
              })
          .toList(),
      'readyPackages': readyPackages
          .map((p) => {
                'id': p.id,
                'title': p.title,
                'daysCount': p.daysCount,
                'toursCount': p.toursCount,
                'basePriceUsd': p.basePriceUsd,
                'description': p.description,
              })
          .toList(),
      'transitOptions': transitOptions,
      'accommodationTypes': accommodationTypes,
      'starRatings': starRatings,
      'additionalServices': additionalServices,
      'tourInterests': tourInterests,
    };
  }
}
