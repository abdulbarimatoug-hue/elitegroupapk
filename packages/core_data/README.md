# Core Data Layer (طبقة البيانات)
### LY-Elite Tourism Group (مجموعة النخبة للخدمات السياحية)

This package implements the abstract contracts defined in `core_domain` using Firebase SDKs.

## Structure
```
lib/
├── datasources/
│   ├── firestore_remote_datasource.dart
│   ├── firebase_auth_datasource.dart
│   └── firebase_storage_datasource.dart
├── models/
│   ├── user_model.dart
│   ├── travel_package_model.dart
│   ├── booking_model.dart
│   ├── visa_model.dart
│   ├── custom_trip_model.dart
│   └── flight_booking_model.dart
└── repositories/
    ├── auth_repository_impl.dart
    ├── package_repository_impl.dart
    ├── booking_repository_impl.dart
    ├── visa_repository_impl.dart
    ├── custom_trip_repository_impl.dart
    └── flight_booking_repository_impl.dart
```
