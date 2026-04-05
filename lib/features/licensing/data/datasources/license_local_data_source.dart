import 'package:shared_preferences/shared_preferences.dart';

abstract class LicenseLocalDataSource {
  Future<String?> getSavedLicenseToken();
  Future<void> saveLicenseToken(String token);
}

class LicenseLocalDataSourceImpl implements LicenseLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const String licenseTokenKey = 'SAVED_LICENSE_TOKEN';

  LicenseLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String?> getSavedLicenseToken() async {
    return sharedPreferences.getString(licenseTokenKey);
  }

  @override
  Future<void> saveLicenseToken(String token) async {
    await sharedPreferences.setString(licenseTokenKey, token);
  }
}