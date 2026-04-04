import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ألوان مريحة لعين الكاشير لفترات العمل الطويلة
  static const Color primary = Color(0xFF0056D2); // أزرق داكن للثقة والوضوح
  static const Color secondary = Color(0xFFF2A900); // برتقالي مائل للذهبي للتنبيهات
  static const Color background = Color(0xFFF4F6F8); // رمادي فاتح جداً لخلفية التطبيق
  static const Color surface = Colors.white; // أبيض نقي لخلفية الكروت والقوائم
  static const Color error = Color(0xFFD32F2F); // أحمر واضح للعمليات الملغاة والعجز
  static const Color success = Color(0xFF2E7D32); // أخضر لعمليات الدفع الناجحة
  static const Color textPrimary = Color(0xFF1E1E1E); // أسود داكن للنصوص الأساسية
  static const Color textSecondary = Color(0xFF757575); // رمادي للنصوص الفرعية
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      // استخدام خط Cairo كمعيار أساسي لجميع نصوص التطبيق
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        displayLarge: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        titleLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
      ),
      // توحيد شكل الأزرار في كامل النظام
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      // توحيد شكل حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: GoogleFonts.cairo(color: AppColors.textSecondary),
      ),
    );
  }
}