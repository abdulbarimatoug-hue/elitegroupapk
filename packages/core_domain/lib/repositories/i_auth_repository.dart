import '../entities/user_entity.dart';

abstract class IAuthRepository {
  /// Stream of the currently authenticated user
  Stream<UserEntity?> watchCurrentUser();

  /// Get currently signed in user
  Future<UserEntity?> getCurrentUser();

  /// Sign in with Email and Password
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Register a new account
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  });

  /// Sign in with Google Account
  Future<UserEntity> signInWithGoogle();

  /// Send password reset link to user's email
  Future<void> sendPasswordResetEmail(String email);

  /// Update user profile details
  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
    String? photoUrl,
  });

  /// Sign out current user
  Future<void> signOut();
}
