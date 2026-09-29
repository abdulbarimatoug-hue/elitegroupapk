import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/custom_trip_request_entity.dart';
import 'package:core_domain/entities/trip_builder_config_entity.dart';
import 'package:core_domain/failures/failures.dart';
import 'package:core_domain/repositories/i_custom_trip_repository.dart';
import '../models/custom_trip_request_model.dart';
import '../models/trip_builder_config_model.dart';

class CustomTripRepositoryImpl implements ICustomTripRepository {
  final FirebaseFirestore _firestore;

  CustomTripRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _configRef => _firestore.collection('trip_builder_config');
  CollectionReference get _tripsRef => _firestore.collection('custom_trip_requests');

  String _generateReferenceNumber() {
    final year = DateTime.now().year;
    final randomNum = 1000 + Random().nextInt(9000);
    return 'LY-TRIP-$year-$randomNum';
  }

  @override
  Future<TripBuilderConfigEntity> getTripBuilderConfig() async {
    try {
      final doc = await _configRef.doc('main_config').get();
      if (doc.exists) {
        return TripBuilderConfigModel.fromJson(doc.data() as Map<String, dynamic>);
      }

      // Default initial seed data for Elite Tourism Group
      return const TripBuilderConfigModel(
        minimumBudgetUsd: 1500.0,
        nationalities: ['ليبي', 'تونسي', 'مصري', 'جزائري', 'أخرى'],
        businessSectors: [
          'النفط والغاز والطاقة',
          'التجارة العامة والاستيراد',
          'المقاولات والإنشاءات',
          'القطاع المالي والمصرفي',
          'الرعاية الصحية والأدوية',
          'تكنولوجيا المعلومات والاتصالات'
        ],
        countries: [
          BuilderCountry(
            id: 'turkey',
            name: 'تركيا',
            code: 'TR',
            requiresVisa: true,
            visaPriceUsd: 110.0,
            visaProcessingTime: 'خلال 24-48 ساعة',
            cities: [
              BuilderCity(
                id: 'c_ist',
                name: 'إسطنبول',
                countryId: 'turkey',
                countryName: 'تركيا',
                gradientStart: '#0E2A47',
                gradientEnd: '#C9A227',
                estimatedDailyCostUsd: 140.0,
              ),
              BuilderCity(
                id: 'c_trabzon',
                name: 'طرابزون',
                countryId: 'turkey',
                countryName: 'تركيا',
                gradientStart: '#059669',
                gradientEnd: '#10B981',
                estimatedDailyCostUsd: 120.0,
              ),
              BuilderCity(
                id: 'c_antalya',
                name: 'أنطاليا',
                countryId: 'turkey',
                countryName: 'تركيا',
                gradientStart: '#2563EB',
                gradientEnd: '#0284C7',
                estimatedDailyCostUsd: 150.0,
              ),
            ],
          ),
          BuilderCountry(
            id: 'uae',
            name: 'الإمارات',
            code: 'AE',
            requiresVisa: true,
            visaPriceUsd: 130.0,
            visaProcessingTime: '3-4 أيام عمل',
            cities: [
              BuilderCity(
                id: 'c_dxb',
                name: 'دبي',
                countryId: 'uae',
                countryName: 'الإمارات',
                gradientStart: '#C9A227',
                gradientEnd: '#E8D18F',
                estimatedDailyCostUsd: 220.0,
              ),
              BuilderCity(
                id: 'c_auh',
                name: 'أبوظبي',
                countryId: 'uae',
                countryName: 'الإمارات',
                gradientStart: '#0E2A47',
                gradientEnd: '#1E3A8A',
                estimatedDailyCostUsd: 200.0,
              ),
            ],
          ),
          BuilderCountry(
            id: 'malaysia',
            name: 'ماليزيا',
            code: 'MY',
            requiresVisa: false,
            cities: [
              BuilderCity(
                id: 'c_kul',
                name: 'كوالالمبور',
                countryId: 'malaysia',
                countryName: 'ماليزيا',
                gradientStart: '#0D9488',
                gradientEnd: '#14B8A6',
                estimatedDailyCostUsd: 110.0,
              ),
              BuilderCity(
                id: 'c_penang',
                name: 'بينانج',
                countryId: 'malaysia',
                countryName: 'ماليزيا',
                gradientStart: '#D97706',
                gradientEnd: '#F59E0B',
                estimatedDailyCostUsd: 95.0,
              ),
            ],
          ),
        ],
        readyPackages: [
          ReadyPackageOption(
            id: 'pkg_classic_7',
            title: 'الباقة الكلاسيكية المختارة',
            daysCount: 7,
            toursCount: 3,
            basePriceUsd: 750.0,
            description: 'تشمل الإقامة والتنقلات الأساسية و3 جولات رئيسية.',
          ),
          ReadyPackageOption(
            id: 'pkg_premium_10',
            title: 'باقة الرفاهية الموسّعة',
            daysCount: 10,
            toursCount: 5,
            basePriceUsd: 1250.0,
            description: 'تشمل فنادق 5 نجوم وسيارة خاصة و5 جولات مع مرشد خاص.',
          ),
        ],
        transitOptions: [
          'طيران داخلي',
          'سيارة خاصة مع سائق',
          'قطار سريع VIP',
          'حافلة سياحية فاخرة'
        ],
        accommodationTypes: ['فنادق', 'منتجعات فاخرة', 'شقق مفروشة'],
        starRatings: ['3 نجوم', '4 نجوم', '5 نجوم'],
        additionalServices: [
          'تأمين سفر دولي معتمد',
          'شريحة إنترنت واتصال محلية',
          'استقبال وتوديع VIP من باب الطائرة',
          'تذاكر فعاليات ومزارات مسبقة الحجز'
        ],
        tourInterests: [
          'أماكن هادئة واسترخاء',
          'شواطئ وبحار',
          'طبيعة وجبال وغابات',
          'تسوق ومولات وأسواق شعبية',
          'تاريخ وثقافة ومتاحف',
          'مغامرات وأنشطة رياضية'
        ],
      );
    } catch (e) {
      throw ServerFailure('فشل تحميل إعدادات مصمم الرحلة: $e');
    }
  }

  @override
  Future<CustomTripRequestEntity> createCustomTripRequest(
      CustomTripRequestEntity request) async {
    try {
      final refNum = request.referenceNumber.isNotEmpty
          ? request.referenceNumber
          : _generateReferenceNumber();

      final model = CustomTripRequestModel(
        id: '',
        referenceNumber: refNum,
        userId: request.userId,
        customerName: request.customerName,
        customerPhone: request.customerPhone,
        nationality: request.nationality,
        tripType: request.tripType,
        businessSector: request.businessSector,
        adultsCount: request.adultsCount,
        childrenCount: request.childrenCount,
        dedicatedBudgetUsd: request.dedicatedBudgetUsd,
        selectedCityNames: request.selectedCityNames,
        selectedCountryNames: request.selectedCountryNames,
        includesVisaAssistance: request.includesVisaAssistance,
        departureCity: request.departureCity,
        flightClass: request.flightClass,
        startDate: request.startDate,
        totalDays: request.totalDays,
        packageChoiceType: request.packageChoiceType,
        readyPackageTitle: request.readyPackageTitle,
        cityDaysDistribution: request.cityDaysDistribution,
        countryTransitPreferences: request.countryTransitPreferences,
        estimatedCalculatedCostUsd: request.estimatedCalculatedCostUsd,
        airportMeetAndGreet: request.airportMeetAndGreet,
        accommodationTypes: request.accommodationTypes,
        starRatings: request.starRatings,
        additionalServices: request.additionalServices,
        guideLanguage: request.guideLanguage,
        tourType: request.tourType,
        selectedInterests: request.selectedInterests,
        targetWhatsAppNumber: request.targetWhatsAppNumber,
        status: CustomTripStatus.pending,
        createdAt: DateTime.now(),
      );

      final docRef = await _tripsRef.add(model.toJson());

      return CustomTripRequestModel(
        id: docRef.id,
        referenceNumber: refNum,
        userId: model.userId,
        customerName: model.customerName,
        customerPhone: model.customerPhone,
        nationality: model.nationality,
        tripType: model.tripType,
        businessSector: model.businessSector,
        adultsCount: model.adultsCount,
        childrenCount: model.childrenCount,
        dedicatedBudgetUsd: model.dedicatedBudgetUsd,
        selectedCityNames: model.selectedCityNames,
        selectedCountryNames: model.selectedCountryNames,
        includesVisaAssistance: model.includesVisaAssistance,
        departureCity: model.departureCity,
        flightClass: model.flightClass,
        startDate: model.startDate,
        totalDays: model.totalDays,
        packageChoiceType: model.packageChoiceType,
        readyPackageTitle: model.readyPackageTitle,
        cityDaysDistribution: model.cityDaysDistribution,
        countryTransitPreferences: model.countryTransitPreferences,
        estimatedCalculatedCostUsd: model.estimatedCalculatedCostUsd,
        airportMeetAndGreet: model.airportMeetAndGreet,
        accommodationTypes: model.accommodationTypes,
        starRatings: model.starRatings,
        additionalServices: model.additionalServices,
        guideLanguage: model.guideLanguage,
        tourType: model.tourType,
        selectedInterests: model.selectedInterests,
        targetWhatsAppNumber: model.targetWhatsAppNumber,
        status: model.status,
        createdAt: model.createdAt,
      );
    } catch (e) {
      throw ServerFailure('فشل حفظ طلب الرحلة المخصصة: $e');
    }
  }

  @override
  Future<List<CustomTripRequestEntity>> getCustomerTripRequests(
      String userId) async {
    try {
      final snapshot = await _tripsRef
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CustomTripRequestModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب طلبات رحلاتك المخصصة: $e');
    }
  }

  @override
  Stream<List<CustomTripRequestEntity>> watchCustomerTripRequests(
      String userId) {
    return _tripsRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CustomTripRequestModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  @override
  Future<List<CustomTripRequestEntity>> getAllCustomTripRequests({
    CustomTripStatus? status,
  }) async {
    try {
      Query query = _tripsRef.orderBy('createdAt', descending: true);
      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => CustomTripRequestModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw ServerFailure('فشل جلب طلبات الرحلات المخصصة للإدارة: $e');
    }
  }

  @override
  Future<void> updateCustomTripStatus({
    required String requestId,
    required CustomTripStatus status,
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
        'updatedAt': Timestamp.now(),
      };
      if (notes != null) updates['notes'] = notes;
      await _tripsRef.doc(requestId).update(updates);
    } catch (e) {
      throw ServerFailure('فشل تحديث حالة الرحلة المخصصة: $e');
    }
  }

  @override
  Future<void> updateTripBuilderConfig(TripBuilderConfigEntity config) async {
    try {
      final model = TripBuilderConfigModel(
        minimumBudgetUsd: config.minimumBudgetUsd,
        nationalities: config.nationalities,
        businessSectors: config.businessSectors,
        countries: config.countries,
        readyPackages: config.readyPackages,
        transitOptions: config.transitOptions,
        accommodationTypes: config.accommodationTypes,
        starRatings: config.starRatings,
        additionalServices: config.additionalServices,
        tourInterests: config.tourInterests,
      );
      await _configRef.doc('main_config').set(model.toJson());
    } catch (e) {
      throw ServerFailure('فشل حفظ إعدادات معالج الرحلة: $e');
    }
  }
}
