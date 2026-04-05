import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_setting_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/app_setting_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<AppSettingEntity>>> getAllSettings() async {
    try {
      final settings = await localDataSource.getAllSettings();
      return Right(settings);
    } catch (e) {
      return Left(DatabaseFailure('فشل في جلب إعدادات النظام: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(List<AppSettingEntity> settings) async {
    try {
      final models = settings.map((s) => AppSettingModel.fromEntity(s)).toList();
      await localDataSource.saveSettings(models);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('فشل في حفظ إعدادات النظام: ${e.toString()}'));
    }
  }
}