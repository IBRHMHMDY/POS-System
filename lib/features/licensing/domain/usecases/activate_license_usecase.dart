import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/license.dart';
import '../repositories/license_repository.dart';

// هنا [Type] هو License و [Params] هو String يمثل كود التفعيل
class ActivateLicenseUseCase implements UseCase<License, String> {
  final LicenseRepository repository;

  ActivateLicenseUseCase(this.repository);

  @override
  Future<Either<Failure, License>> call(String params) async {
    return await repository.activateLicense(params);
  }
}