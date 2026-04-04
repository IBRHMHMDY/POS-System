import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtils {
  final DeviceInfoPlugin _deviceInfoPlugin;

  // استخدام Dependency Injection مبسط هنا لتسهيل اختبار الكود (Unit Testing) لاحقاً
  DeviceInfoUtils({DeviceInfoPlugin? deviceInfoPlugin})
      : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  /// يقوم باستخراج المعرف الفريد للجهاز (Device ID) بناءً على نظام التشغيل.
  Future<String> getUniqueDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        // نعتمد على المعرف الفريد الخاص بلوحة الأندرويد أو جهاز الكاشير
        return androidInfo.id;
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfoPlugin.windowsInfo;
        // نعتمد على المعرف الفريد لنظام الويندوز
        return windowsInfo.deviceId;
      } else {
        throw UnsupportedError('نظام التشغيل الحالي غير مدعوم بنظام نقاط البيع.');
      }
    } catch (e) {
      throw Exception('فشل في استخراج معرف الجهاز: ${e.toString()}');
    }
  }
}