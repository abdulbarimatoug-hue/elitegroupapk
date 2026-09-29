import '../entities/travel_package_entity.dart';

abstract class IPackageRepository {
  /// Fetch all active packages with optional filters
  Future<List<TravelPackageEntity>> getPackages({
    String? category, // خارجي، داخلي، عائلي، شهر عسل، عمرة وحج
    String? destination,
    double? maxPrice,
    int? maxDurationDays,
    String? searchQuery,
    bool? onlyPopular,
    bool? onlySpecialOffers,
  });

  /// Realtime stream of packages
  Stream<List<TravelPackageEntity>> watchPackages();

  /// Get package details by ID
  Future<TravelPackageEntity?> getPackageById(String packageId);

  /// Toggle package in user's favorites
  Future<bool> toggleFavorite({
    required String userId,
    required String packageId,
  });

  /// Get list of user's favorite packages
  Future<List<TravelPackageEntity>> getFavoritePackages(String userId);

  // Admin Management Operations
  Future<String> addPackage(TravelPackageEntity package);
  Future<void> updatePackage(TravelPackageEntity package);
  Future<void> deletePackage(String packageId);
}
