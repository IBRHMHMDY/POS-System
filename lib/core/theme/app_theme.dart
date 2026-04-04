import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // الألوان الأساسية مريحة للعين لتقليل إجهاد الكاشير
  static const Color primaryColor = Color(0xFF1E88E5); // أزرق احترافي
  static const Color accentColor = Color(0xFFFFC107); // أصفر للتنبيهات والأزرار المهمة
  static const Color backgroundColor = Color(0xFFF5F5F5); // رمادي فاتح للخلفية
  static const Color errorColor = Color(0xFFD32F2F); // أحمر للفواتير الملغاة والعجز

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        surface: backgroundColor,
        error: errorColor,
      ),
      // استخدام خط Cairo كمعيار أساسي للتطبيق
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        displayLarge: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
        titleLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
        bodyLarge: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
        bodyMedium: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}