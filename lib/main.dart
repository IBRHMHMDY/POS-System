import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // التأكد من تهيئة بيئة Flutter قبل تنفيذ أي كود يعتمد على الـ Platform
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: تهيئة الاعتماديات (Dependency Injection) سيتم إضافتها لاحقاً
  // TODO: تهيئة قاعدة البيانات المحلية سيتم إضافتها لاحقاً

  runApp(const PosApp());
}

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام نقاط البيع',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // إعدادات اللغة لدعم السوق المصري (RTL)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'EG'), // العربية - مصر
      ],
      locale: const Locale('ar', 'EG'), // فرض اللغة العربية بشكل أساسي
      
      // شاشة مؤقتة حتى نقوم بربط ميزة التراخيص وتسجيل الدخول
      home: const Scaffold(
        body: Center(
          child: Text('جاري تهيئة نظام الكاشير...'),
        ),
      ),
    );
  }
}