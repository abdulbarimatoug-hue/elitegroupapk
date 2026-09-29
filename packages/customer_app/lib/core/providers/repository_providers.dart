import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_data/repositories/auth_repository_impl.dart';
import 'package:core_data/repositories/booking_repository_impl.dart';
import 'package:core_data/repositories/custom_trip_repository_impl.dart';
import 'package:core_data/repositories/flight_booking_repository_impl.dart';
import 'package:core_data/repositories/package_repository_impl.dart';
import 'package:core_data/repositories/visa_repository_impl.dart';
import 'package:core_domain/repositories/i_auth_repository.dart';
import 'package:core_domain/repositories/i_booking_repository.dart';
import 'package:core_domain/repositories/i_custom_trip_repository.dart';
import 'package:core_domain/repositories/i_flight_booking_repository.dart';
import 'package:core_domain/repositories/i_notification_repository.dart';
import 'package:core_domain/repositories/i_package_repository.dart';
import 'package:core_domain/repositories/i_visa_repository.dart';
import 'package:core_data/repositories/notification_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Firebase Instance Providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Clean Architecture Repositories (Injected via Riverpod - Zero GetIt!)
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final packageRepositoryProvider = Provider<IPackageRepository>((ref) {
  return PackageRepositoryImpl(
    firestore: ref.watch(firestoreProvider),
  );
});

final bookingRepositoryProvider = Provider<IBookingRepository>((ref) {
  return BookingRepositoryImpl(
    firestore: ref.watch(firestoreProvider),
  );
});

final visaRepositoryProvider = Provider<IVisaRepository>((ref) {
  return VisaRepositoryImpl(
    firestore: ref.watch(firestoreProvider),
  );
});

final customTripRepositoryProvider = Provider<ICustomTripRepository>((ref) {
  return CustomTripRepositoryImpl(
    firestore: ref.watch(firestoreProvider),
  );
});

final flightBookingRepositoryProvider = Provider<IFlightBookingRepository>((ref) {
  return FlightBookingRepositoryImpl(
    firestore: ref.watch(firestoreProvider),
  );
});

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    firestore: ref.watch(firestoreProvider),
  );
});

