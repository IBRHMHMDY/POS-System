import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/license_repository.dart';

class CheckLicenseStatusUseCase implements UseCase<bool, NoParams> {
  final LicenseRepository repository;

  CheckLicenseStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkLicenseStatus();
  }
}