import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/app_setting_entity.dart';

class AppSettingModel extends AppSettingEntity {
  const AppSettingModel({
    required super.key,
    required super.value,
  });

  factory AppSettingModel.fromEntity(AppSettingEntity entity) {
    return AppSettingModel(key: entity.key, value: entity.value);
  }

  factory AppSettingModel.fromDriftSetting(db.AppSetting driftSetting) {
    return AppSettingModel(
      key: driftSetting.settingKey,
      value: driftSetting.settingValue,
    );
  }

  db.AppSettingsCompanion toDriftCompanion() {
    return db.AppSettingsCompanion(
      settingKey: drift.Value(key),
      settingValue: drift.Value(value),
    );
  }
}