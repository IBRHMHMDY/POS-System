import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/license_repository.dart';

class GetDeviceIdUseCase implements UseCase<String, NoParams> {
  final LicenseRepository repository;

  GetDeviceIdUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getDeviceId();
  }
}