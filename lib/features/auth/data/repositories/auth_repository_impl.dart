import 'package:dartz/dartz.dart';
import '../../../../core/database/app_database.dart' as db_models;
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart' as domain_models;
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  // دالة مساعدة لتحويل دور المستخدم من نص (في قاعدة البيانات) إلى Enum (في الدومين)
  domain_models.UserRole _mapRoleStringToEnum(String roleStr) {
    switch (roleStr) {
      case 'owner':
        return domain_models.UserRole.owner;
      case 'manager':
        return domain_models.UserRole.manager;
      case 'cashier':
      default:
        return domain_models.UserRole.cashier;
    }
  }

  // دالة مساعدة للتحويل من موديل قاعدة البيانات إلى موديل الدومين
  domain_models.User _mapDbUserToDomainUser(db_models.User dbUser) {
    return domain_models.User(
      id: dbUser.id,
      name: dbUser.name,
      role: _mapRoleStringToEnum(dbUser.role),
    );
  }

  @override
  Future<Either<Failure, domain_models.User>> login(String passcode) async {
    try {
      final dbUser = await localDataSource.getUserByPasscode(passcode);
      
      if (dbUser != null) {
        if (!dbUser.isActive) {
          return const Left(PermissionFailure('هذا الحساب غير نشط، يرجى مراجعة الإدارة.'));
        }
        
        // حفظ جلسة المستخدم
        await localDataSource.cacheCurrentUserId(dbUser.id);
        
        return Right(_mapDbUserToDomainUser(dbUser));
      } else {
        return const Left(PermissionFailure('رمز الدخول غير صحيح.'));
      }
    } catch (e) {
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
  Future<Either<Failure, domain_models.UserEntity?>> getCurrentUser() async {
    try {
      final dbUser = await localDataSource.getCurrentUser();
      
      if (dbUser != null) {
        return Right(_mapDbUserToDomainUser(dbUser));
      } else {
        return const Right(null);
      }
    } catch (e) {
      return Left(DatabaseFailure('فشل في استرجاع جلسة المستخدم: ${e.toString()}'));
    }
  }
}