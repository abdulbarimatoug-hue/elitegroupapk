import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/user_entity.dart';
import 'package:core_domain/failures/failures.dart';
import 'package:core_domain/repositories/i_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final fb_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    fb_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? fb_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  CollectionReference get _usersRef => _firestore.collection('users');

  @override
  Stream<UserEntity?> watchCurrentUser() {
    return _firebaseAuth.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) return null;
      return await getCurrentUser();
    });
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final currentFbUser = _firebaseAuth.currentUser;
    if (currentFbUser == null) return null;

    final doc = await _usersRef.doc(currentFbUser.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromJson(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;
      final doc = await _usersRef.doc(uid).get();

      if (!doc.exists) {
        throw const NotFoundFailure('لم يتم العثور على بيانات المستخدم');
      }

      return UserModel.fromJson(doc.data() as Map<String, dynamic>, uid);
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'فشل تسجيل الدخول بالبريد الإلكتروني');
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;

      final newUser = UserModel(
        id: uid,
        email: email.trim(),
        fullName: fullName.trim(),
        phoneNumber: phoneNumber.trim(),
        role: UserRole.customer,
        createdAt: DateTime.now(),
        favoritePackageIds: const [],
      );

      await _usersRef.doc(uid).set(newUser.toJson());
      return newUser;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'فشل إنشاء الحساب الجديد');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure('تم إلغاء تسجيل الدخول عبر Google');
      }

      final googleAuth = await googleUser.authentication;
      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final uid = userCredential.user!.uid;

      final doc = await _usersRef.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>, uid);
      } else {
        final newUser = UserModel(
          id: uid,
          email: userCredential.user!.email ?? '',
          fullName: userCredential.user!.displayName ?? 'عميل النخبة',
          phoneNumber: userCredential.user!.phoneNumber ?? '',
          photoUrl: userCredential.user!.photoURL,
          role: UserRole.customer,
          createdAt: DateTime.now(),
          favoritePackageIds: const [],
        );
        await _usersRef.doc(uid).set(newUser.toJson());
        return newUser;
      }
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw AuthFailure('تعذر إرسال رابط استعادة كلمة المرور');
    }
  }

  @override
  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
    String? photoUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        'fullName': fullName.trim(),
        'phoneNumber': phoneNumber.trim(),
      };
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      await _usersRef.doc(userId).update(updates);
    } catch (e) {
      throw ServerFailure('فشل تحديث الملف الشخصي: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
