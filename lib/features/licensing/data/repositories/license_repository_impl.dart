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
      final savedToken = await localDataSource.getSavedLicenseToken();
      if (savedToken == null) return const Right(false);

      final deviceId = await deviceInfoUtils.getUniqueDeviceId();
      
      // التحقق مما إذا كان التوكن المحفوظ ما زال صالحاً (لم ينتهِ تاريخه ولم يتم التلاعب به)
      final isValid = CryptoUtils.validateActivationToken(
        token: savedToken,
        expectedDeviceId: deviceId,
      );

      return Right(isValid);
    } catch (e) {
      return const Left(DatabaseFailure('فشل في قراءة حالة الترخيص من الذاكرة.'));
    }
  }

  @override
  Future<Either<Failure, License>> activateLicense(String activationCode) async {
    try {
      final deviceId = await deviceInfoUtils.getUniqueDeviceId();

      final isValid = CryptoUtils.validateActivationToken(
        token: activationCode.trim(),
        expectedDeviceId: deviceId,
      );

      if (isValid) {
        // حفظ التوكن الجديد بالكامل
        await localDataSource.saveLicenseToken(activationCode.trim());
        return Right(License(deviceId: deviceId, isActivated: true));
      } else {
        return const Left(PermissionFailure('كود التفعيل غير صحيح أو منتهي الصلاحية.'));
      }
    } catch (e) {
      return Left(UnexpectedFailure('حدث خطأ غير متوقع أثناء التفعيل: ${e.toString()}'));
    }
  }
}