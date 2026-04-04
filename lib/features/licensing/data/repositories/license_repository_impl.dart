import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/crypto_utils.dart';
import '../../../../core/utils/device_info_utils.dart';
import '../../domain/entities/license.dart';
import '../../domain/repositories/license_repository.dart';
import '../datasources/license_local_data_source.dart';

class LicenseRepositoryImpl implements LicenseRepository {
  final LicenseLocalDataSource localDataSource;
  final DeviceInfoUtils deviceInfoUtils;

  // المفتاح السري المشترك بين تطبيق نقاط البيع وتطبيق توليد التراخيص الخارجي
  // تنويه: في بيئة الإنتاج الفعلية، يمكن تشفير هذا المفتاح (Obfuscation)
  static const String _secretSalt = 'POS_RESTAURANT_EGYPT_2026_SECRET';

  LicenseRepositoryImpl({
    required this.localDataSource,
    required this.deviceInfoUtils,
  });

  @override
  Future<Either<Failure, String>> getDeviceId() async {
    try {
      final deviceId = await deviceInfoUtils.getUniqueDeviceId();
      return Right(deviceId);
    } catch (e) {
      return Left(HardwareFailure('فشل في استخراج معرف الجهاز: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkLicenseStatus() async {
    try {
      final status = await localDataSource.getLicenseStatus();
      return Right(status);
    } catch (e) {
      return const Left(DatabaseFailure('فشل في قراءة حالة الترخيص من الذاكرة المحلية.'));
    }
  }

  @override
  Future<Either<Failure, License>> activateLicense(String activationCode) async {
    try {
      // 1. استخراج معرف الجهاز
      final deviceId = await deviceInfoUtils.getUniqueDeviceId();

      // 2. توليد الكود المتوقع باستخدام أداة التشفير (CryptoUtils)
      final expectedCode = CryptoUtils.generateActivationCode(
        deviceId: deviceId,
        secretSalt: _secretSalt,
      );

      // 3. مقارنة الكود المدخل مع الكود المتوقع
      if (activationCode.trim().toUpperCase() == expectedCode) {
        // 4. في حالة التطابق، نقوم بحفظ حالة التفعيل في الذاكرة المحلية
        await localDataSource.saveLicenseStatus(true);
        return Right(License(deviceId: deviceId, isActivated: true));
      } else {
        // 5. في حالة عدم التطابق، نرجع خطأ صلاحيات
        return const Left(PermissionFailure('كود التفعيل غير صحيح، يرجى التأكد والمحاولة مرة أخرى.'));
      }
    } catch (e) {
      return Left(UnexpectedFailure('حدث خطأ غير متوقع أثناء التفعيل: ${e.toString()}'));
    }
  }
}