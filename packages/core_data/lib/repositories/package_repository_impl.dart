import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/travel_package_entity.dart';
import 'package:core_domain/failures/failures.dart';
import 'package:core_domain/repositories/i_package_repository.dart';
import '../models/travel_package_model.dart';

class PackageRepositoryImpl implements IPackageRepository {
  final FirebaseFirestore _firestore;

  PackageRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _packagesRef => _firestore.collection('packages');
  CollectionReference get _usersRef => _firestore.collection('users');

  @override
  Future<List<TravelPackageEntity>> getPackages({
    String? category,
    String? destination,
    double? maxPrice,
    int? maxDurationDays,
    String? searchQuery,
    bool? onlyPopular,
    bool? onlySpecialOffers,
  }) async {
    try {
      Query query = _packagesRef;

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      if (onlyPopular == true) {
        query = query.where('isPopular', isEqualTo: true);
      }

      if (onlySpecialOffers == true) {
        query = query.where('isSpecialOffer', isEqualTo: true);
      }

      final snapshot = await query.get();
      List<TravelPackageEntity> results = snapshot.docs
          .map((doc) => TravelPackageModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();

      // In-memory filters for advanced client-side search & ranges
      if (destination != null && destination.isNotEmpty) {
        results = results
            .where((p) =>
                p.destination.toLowerCase().contains(destination.toLowerCase()))
            .toList();
      }

      if (maxPrice != null) {
        results = results.where((p) => p.price <= maxPrice).toList();
      }

      if (maxDurationDays != null) {
        results =
            results.where((p) => p.durationDays <= maxDurationDays).toList();
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        results = results
            .where((p) =>
                p.title.toLowerCase().contains(q) ||
                p.destination.toLowerCase().contains(q) ||
                p.overview.toLowerCase().contains(q))
            .toList();
      }

      return results;
    } catch (e) {
      throw ServerFailure('فشل تحميل الباقات السياحية: $e');
    }
  }

  @override
  Stream<List<TravelPackageEntity>> watchPackages() {
    return _packagesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TravelPackageModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  @override
  Future<TravelPackageEntity?> getPackageById(String packageId) async {
    try {
      final doc = await _packagesRef.doc(packageId).get();
      if (!doc.exists) return null;
      return TravelPackageModel.fromJson(
          doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw ServerFailure('تعذر جلب تفاصيل الباقة: $e');
    }
  }

  @override
  Future<bool> toggleFavorite({
    required String userId,
    required String packageId,
  }) async {
    try {
      final userDoc = await _usersRef.doc(userId).get();
      if (!userDoc.exists) return false;

      final data = userDoc.data() as Map<String, dynamic>;
      final favorites = (data['favoritePackageIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      final isFavorite = favorites.contains(packageId);
      if (isFavorite) {
        favorites.remove(packageId);
      } else {
        favorites.add(packageId);
      }

      await _usersRef.doc(userId).update({'favoritePackageIds': favorites});
      return !isFavorite;
    } catch (e) {
      throw ServerFailure('فشل تحديث المفضلة: $e');
    }
  }

  @override
  Future<List<TravelPackageEntity>> getFavoritePackages(String userId) async {
    try {
      final userDoc = await _usersRef.doc(userId).get();
      if (!userDoc.exists) return [];

      final data = userDoc.data() as Map<String, dynamic>;
      final favorites = (data['favoritePackageIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      if (favorites.isEmpty) return [];

      final results = <TravelPackageEntity>[];
      for (final id in favorites) {
        final pkg = await getPackageById(id);
        if (pkg != null) results.add(pkg);
      }
      return results;
    } catch (e) {
      throw ServerFailure('فشل جلب قائمة المفضلة: $e');
    }
  }

  @override
  Future<String> addPackage(TravelPackageEntity package) async {
    try {
      final model = TravelPackageModel.fromEntity(package);
      final docRef = await _packagesRef.add(model.toJson());
      return docRef.id;
    } catch (e) {
      throw ServerFailure('فشل إضافة الباقة الجديدة: $e');
    }
  }

  @override
  Future<void> updatePackage(TravelPackageEntity package) async {
    try {
      final model = TravelPackageModel.fromEntity(package);
      await _packagesRef.doc(package.id).update(model.toJson());
    } catch (e) {
      throw ServerFailure('فشل تعديل بيانات الباقة: $e');
    }
  }

  @override
  Future<void> deletePackage(String packageId) async {
    try {
      await _packagesRef.doc(packageId).delete();
    } catch (e) {
      throw ServerFailure('فشل حذف الباقة: $e');
    }
  }
}
