import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoUtils {
  // ⚠️ يجب أن يطابق تماماً المفتاح السري في مشروع التفعيل الخارجي
  static const String _appSecret = "YOUR_SUPER_SECURE_OBFUSCATED_SECRET_KEY_2026";

  /// يقوم بالتحقق من صحة التوكن (الرخصة) الواردة من تطبيق CoreSoft Activator
  static bool validateActivationToken({
    required String token,
    required String expectedDeviceId,
  }) {
    try {
      // التوكن يتكون من Payload و Signature مفصولين بنقطة
      final parts = token.split('.');
      if (parts.length != 2) return false;

      final payloadBase64 = parts[0];
      final signatureBase64 = parts[1];

      // 1. التحقق من التوقيع الرقمي (Signature Validation)
      final key = utf8.encode(_appSecret);
      final bytes = utf8.encode(payloadBase64);
      final hmacSha256 = Hmac(sha256, key);
      final expectedSignature = base64Url.encode(hmacSha256.convert(bytes).bytes);

      if (signatureBase64 != expectedSignature) return false;

      // 2. فك تشفير البيانات والتحقق من معرف الجهاز (Payload & Device ID Validation)
      final payloadStr = utf8.decode(base64Url.decode(payloadBase64));
      final payload = json.decode(payloadStr);

      final deviceId = payload['device_id'];
      if (deviceId != expectedDeviceId) return false;

      // 3. التحقق من تاريخ الصلاحية (Expiry Date Validation)
      final expiryDateStr = payload['expiry_date'];
      final expiryDate = DateTime.parse(expiryDateStr);
      if (DateTime.now().isAfter(expiryDate)) {
        return false; // الرخصة منتهية
      }

      return true; // التوكن سليم وصالح
    } catch (e) {
      // أي تلاعب في التوكن سيؤدي إلى خطأ، نعتبره توكن غير صالح
      return false;
    }
  }
}