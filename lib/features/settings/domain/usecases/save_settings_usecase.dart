import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_setting_entity.dart';
import '../repositories/settings_repository.dart';

class SaveSettingsUseCase implements UseCase<void, List<AppSettingEntity>> {
  final SettingsRepository repository;

  SaveSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(List<AppSettingEntity> params) async {
    return await repository.saveSettings(params);
  }
}