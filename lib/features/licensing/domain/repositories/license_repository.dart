import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/license.dart';

abstract class LicenseRepository {
  Future<Either<Failure, String>> getDeviceId();
  Future<Either<Failure, bool>> checkLicenseStatus();
  Future<Either<Failure, License>> activateLicense(String activationCode);
}