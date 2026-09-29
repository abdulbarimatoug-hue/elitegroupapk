import '../entities/booking_entity.dart';

abstract class IBookingRepository {
  /// Submit a new package booking request (saved as pending in Firestore)
  Future<BookingEntity> createBooking(BookingEntity booking);

  /// Fetch bookings belonging to the authenticated customer
  Future<List<BookingEntity>> getCustomerBookings(String userId);

  /// Stream of customer's bookings
  Stream<List<BookingEntity>> watchCustomerBookings(String userId);

  /// Cancel a booking (allowed when status is pending)
  Future<void> cancelBooking(String bookingId);

  // Admin & Staff Operations
  Future<List<BookingEntity>> getAllBookings({
    BookingStatus? status,
    DateTime? fromDate,
  });

  Future<void> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  });
}
