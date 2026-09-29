import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/travel_package_entity.dart';

class TravelPackageModel extends TravelPackageEntity {
  const TravelPackageModel({
    required super.id,
    required super.title,
    required super.destination,
    required super.category,
    required super.durationDays,
    required super.durationNights,
    required super.price,
    super.originalPrice,
    required super.imageUrls,
    required super.coverImage,
    required super.overview,
    required super.itinerary,
    required super.includedServices,
    required super.excludedServices,
    super.coordinates,
    super.isPopular = false,
    super.isSpecialOffer = false,
    required super.createdAt,
  });

  factory TravelPackageModel.fromJson(Map<String, dynamic> json, String id) {
    return TravelPackageModel(
      id: id,
      title: json['title'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      category: json['category'] as String? ?? 'خارجي',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 1,
      durationNights: (json['durationNights'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      coverImage: json['coverImage'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      itinerary: (json['itinerary'] as List<dynamic>?)
              ?.map((item) => ItineraryDay(
                    dayNumber: (item['dayNumber'] as num?)?.toInt() ?? 1,
                    title: item['title'] as String? ?? '',
                    description: item['description'] as String? ?? '',
                    activities: (item['activities'] as List<dynamic>?)
                            ?.map((a) => a.toString())
                            .toList() ??
                        [],
                  ))
              .toList() ??
          [],
      includedServices: (json['includedServices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      excludedServices: (json['excludedServices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      coordinates: json['coordinates'] != null
          ? MapCoordinates(
              latitude: (json['coordinates']['lat'] as num?)?.toDouble() ?? 0.0,
              longitude: (json['coordinates']['lng'] as num?)?.toDouble() ?? 0.0,
              locationName: json['coordinates']['name'] as String? ?? '',
            )
          : null,
      isPopular: json['isPopular'] as bool? ?? false,
      isSpecialOffer: json['isSpecialOffer'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'destination': destination,
      'category': category,
      'durationDays': durationDays,
      'durationNights': durationNights,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrls': imageUrls,
      'coverImage': coverImage,
      'overview': overview,
      'itinerary': itinerary
          .map((day) => {
                'dayNumber': day.dayNumber,
                'title': day.title,
                'description': day.description,
                'activities': day.activities,
              })
          .toList(),
      'includedServices': includedServices,
      'excludedServices': excludedServices,
      'coordinates': coordinates != null
          ? {
              'lat': coordinates!.latitude,
              'lng': coordinates!.longitude,
              'name': coordinates!.locationName,
            }
          : null,
      'isPopular': isPopular,
      'isSpecialOffer': isSpecialOffer,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TravelPackageModel.fromEntity(TravelPackageEntity entity) {
    return TravelPackageModel(
      id: entity.id,
      title: entity.title,
      destination: entity.destination,
      category: entity.category,
      durationDays: entity.durationDays,
      durationNights: entity.durationNights,
      price: entity.price,
      originalPrice: entity.originalPrice,
      imageUrls: entity.imageUrls,
      coverImage: entity.coverImage,
      overview: entity.overview,
      itinerary: entity.itinerary,
      includedServices: entity.includedServices,
      excludedServices: entity.excludedServices,
      coordinates: entity.coordinates,
      isPopular: entity.isPopular,
      isSpecialOffer: entity.isSpecialOffer,
      createdAt: entity.createdAt,
    );
  }
}
