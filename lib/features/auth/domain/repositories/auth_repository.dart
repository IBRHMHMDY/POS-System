import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// تسجيل الدخول باستخدام رمز الدخول (Passcode)
  Future<Either<Failure, User>> login(String passcode);
  
  /// تسجيل الخروج
  Future<Either<Failure, void>> logout();
  
  /// جلب بيانات المستخدم المسجل دخوله حالياً (إن وجد)
  Future<Either<Failure, User?>> getCurrentUser();
}