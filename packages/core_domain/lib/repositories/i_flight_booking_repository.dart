import '../entities/flight_booking_request_entity.dart';

abstract class IFlightBookingRepository {
  /// Submit an independent flight booking request
  Future<FlightBookingRequestEntity> createFlightBookingRequest(
      FlightBookingRequestEntity request);

  /// Fetch flight booking requests submitted by the authenticated customer
  Future<List<FlightBookingRequestEntity>> getCustomerFlightRequests(
      String userId);

  /// Stream of user flight booking requests
  Stream<List<FlightBookingRequestEntity>> watchCustomerFlightRequests(
      String userId);

  // Admin Operations
  Future<List<FlightBookingRequestEntity>> getAllFlightRequests({
    FlightBookingStatus? status,
  });

  Future<void> updateFlightRequestStatus({
    required String requestId,
    required FlightBookingStatus status,
    String? notes,
  });
}
