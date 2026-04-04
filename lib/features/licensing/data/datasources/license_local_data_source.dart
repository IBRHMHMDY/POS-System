import 'package:shared_preferences/shared_preferences.dart';

abstract class LicenseLocalDataSource {
  Future<bool> getLicenseStatus();
  Future<void> saveLicenseStatus(bool status);
}

class LicenseLocalDataSourceImpl implements LicenseLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const String licenseKey = 'IS_LICENSE_ACTIVATED';

  LicenseLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> getLicenseStatus() async {
    // إرجاع false كقيمة افتراضية إذا لم يكن المفتاح موجوداً (التطبيق يعمل لأول مرة)
    return sharedPreferences.getBool(licenseKey) ?? false;
  }

  @override
  Future<void> saveLicenseStatus(bool status) async {
    await sharedPreferences.setBool(licenseKey, status);
  }
}
