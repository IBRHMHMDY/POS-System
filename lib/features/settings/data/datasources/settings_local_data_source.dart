import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/app_setting_model.dart';

abstract class SettingsLocalDataSource {
  Future<List<AppSettingModel>> getAllSettings();
  Future<void> saveSettings(List<AppSettingModel> settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final AppDatabase db;

  SettingsLocalDataSourceImpl({required this.db});

  @override
  Future<List<AppSettingModel>> getAllSettings() async {
    final result = await db.select(db.appSettings).get();
    return result.map((s) => AppSettingModel.fromDriftSetting(s)).toList();
  }

  @override
  Future<void> saveSettings(List<AppSettingModel> settings) async {
    // نستخدم (Transaction) لضمان حفظ كل الإعدادات أو التراجع عنها في حال حدوث خطأ
    await db.transaction(() async {
      for (var setting in settings) {
        await db.into(db.appSettings).insert(
          setting.toDriftCompanion(),
          mode: InsertMode.insertOrReplace, // حفظ إن كان جديداً، أو تحديث إن كان موجوداً
        );
      }
    });
  }
}