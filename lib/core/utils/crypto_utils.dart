import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoUtils {
  /// يقوم بدمج المعرف الفريد للجهاز مع مفتاح سري (Salt) وتشفيرهم باستخدام خوارزمية SHA-256.
  /// يرجع هذا التابع أول 10 حروف من التشفير لتكون كود التفعيل المتوقع.
  static String generateActivationCode({
    required String deviceId,
    required String secretSalt,
  }) {
    final bytes = utf8.encode(deviceId + secretSalt);
    final hash = sha256.convert(bytes);
    
    // أخذ أول 10 حروف وتحويلها لأحرف كبيرة لسهولة الإدخال من قبل المستخدم
    return hash.toString().substring(0, 10).toUpperCase();
  }
}