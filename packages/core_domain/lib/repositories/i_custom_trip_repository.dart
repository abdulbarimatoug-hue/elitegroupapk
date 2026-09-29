import '../entities/custom_trip_request_entity.dart';
import '../entities/trip_builder_config_entity.dart';

abstract class ICustomTripRepository {
  /// Fetch the 6-step builder master configuration (countries, cities, packages, transit options)
  Future<TripBuilderConfigEntity> getTripBuilderConfig();

  /// Submit a completed 6-step custom trip request (saved as pending in Firestore)
  Future<CustomTripRequestEntity> createCustomTripRequest(
      CustomTripRequestEntity request);

  /// Fetch custom trip requests submitted by a specific user
  Future<List<CustomTripRequestEntity>> getCustomerTripRequests(String userId);

  /// Stream of user custom trip requests
  Stream<List<CustomTripRequestEntity>> watchCustomerTripRequests(String userId);

  // Admin Operations
  Future<List<CustomTripRequestEntity>> getAllCustomTripRequests({
    CustomTripStatus? status,
  });

  Future<void> updateCustomTripStatus({
    required String requestId,
    required CustomTripStatus status,
    String? notes,
  });

  Future<void> updateTripBuilderConfig(TripBuilderConfigEntity config);
}
