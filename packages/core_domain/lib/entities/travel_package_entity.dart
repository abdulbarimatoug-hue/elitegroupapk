import 'package:equatable/equatable.dart';

class ItineraryDay extends Equatable {
  final int dayNumber;
  final String title;
  final String description;
  final List<String> activities;

  const ItineraryDay({
    required this.dayNumber,
    required this.title,
    required this.description,
    this.activities = const [],
  });

  @override
  List<Object?> get props => [dayNumber, title, description, activities];
}

class MapCoordinates extends Equatable {
  final double latitude;
  final double longitude;
  final String locationName;

  const MapCoordinates({
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  @override
  List<Object?> get props => [latitude, longitude, locationName];
}

class TravelPackageEntity extends Equatable {
  final String id;
  final String title;
  final String destination;
  final String category; // 'خارجي', 'داخلي', 'عائلي', 'شهر عسل', 'عمرة وحج'
  final int durationDays;
  final int durationNights;
  final double price;
  final double? originalPrice;
  final List<String> imageUrls;
  final String coverImage;
  final String overview;
  final List<ItineraryDay> itinerary;
  final List<String> includedServices;
  final List<String> excludedServices;
  final MapCoordinates? coordinates;
  final bool isPopular;
  final bool isSpecialOffer;
  final DateTime createdAt;

  const TravelPackageEntity({
    required this.id,
    required this.title,
    required this.destination,
    required this.category,
    required this.durationDays,
    required this.durationNights,
    required this.price,
    this.originalPrice,
    required this.imageUrls,
    required this.coverImage,
    required this.overview,
    required this.itinerary,
    required this.includedServices,
    required this.excludedServices,
    this.coordinates,
    this.isPopular = false,
    this.isSpecialOffer = false,
    required this.createdAt,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercent => hasDiscount
      ? (((originalPrice! - price) / originalPrice!) * 100).roundToDouble()
      : 0;

  @override
  List<Object?> get props => [
        id,
        title,
        destination,
        category,
        durationDays,
        durationNights,
        price,
        originalPrice,
        imageUrls,
        coverImage,
        overview,
        itinerary,
        includedServices,
        excludedServices,
        coordinates,
        isPopular,
        isSpecialOffer,
        createdAt,
      ];
}
