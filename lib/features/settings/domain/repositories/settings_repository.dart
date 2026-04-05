import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_setting_entity.dart';

abstract class SettingsRepository {
  /// جلب جميع الإعدادات المحفوظة في النظام
  Future<Either<Failure, List<AppSettingEntity>>> getAllSettings();

  /// حفظ أو تحديث مجموعة من الإعدادات كعملية واحدة (Transaction)
  Future<Either<Failure, void>> saveSettings(List<AppSettingEntity> settings);
}