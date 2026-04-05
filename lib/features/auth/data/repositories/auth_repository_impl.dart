import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(String passcode) async {
    try {
      final userModel = await localDataSource.getUserByPasscode(passcode);
      
      if (userModel != null) {
        await localDataSource.cacheCurrentUserId(userModel.id);
        // نعيد userModel الذي هو في الأساس من نوع UserEntity
        return Right(userModel);
      } else {
        return const Left(PermissionFailure('رمز الدخول غير صحيح، يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      if (e.toString().contains('INACTIVE_USER')) {
        return const Left(PermissionFailure('هذا الحساب غير نشط، يرجى مراجعة الإدارة.'));
      }
      return Left(DatabaseFailure('حدث خطأ أثناء محاولة تسجيل الدخول: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCurrentUserId();
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure('فشل في تسجيل الخروج: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCurrentUser();
      return Right(userModel);
    } catch (e) {
      return Left(DatabaseFailure('فشل في استرجاع جلسة المستخدم: ${e.toString()}'));
    }
  }
}