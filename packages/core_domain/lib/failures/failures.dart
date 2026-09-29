import 'package:equatable/equatable.dart';

/// Base Failure class for Domain layer
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً', super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة', super.code]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'خطأ في عملية التحقق أو تسجيل الدخول', super.code]);
}

class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure([super.message = 'ليس لديك الصلاحية الكافية لإتمام هذا الإجراء', super.code]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'العنصر المطلوب غير موجود', super.code]);
}
