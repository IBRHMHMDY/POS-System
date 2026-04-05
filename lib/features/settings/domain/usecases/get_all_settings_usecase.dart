import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_setting_entity.dart';
import '../repositories/settings_repository.dart';

class GetAllSettingsUseCase implements UseCase<List<AppSettingEntity>, NoParams> {
  final SettingsRepository repository;

  GetAllSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppSettingEntity>>> call(NoParams params) async {
    return await repository.getAllSettings();
  }
}