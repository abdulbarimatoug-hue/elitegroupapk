# Core Domain Layer (طبقة النطاق الأساسية)
### LY-Elite Tourism Group (مجموعة النخبة للخدمات السياحية)

This package contains pure Dart code with **zero Flutter UI dependencies** and **zero framework coupling**. It defines the core business logic, entities, value objects, domain errors, and repository interfaces.

## Structure
```
lib/
├── entities/           # Business entities (User, Package, Booking, Visa, CustomTrip, FlightBooking)
├── failures/           # Domain failures & exceptions (NetworkFailure, AuthFailure, etc.)
├── repositories/       # Abstract repository interfaces (contracts)
├── usecases/           # Encapsulated business actions
└── value_objects/      # Immutable domain values (PhoneNumber, CurrencyAmount, DateRange)
```
