import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/routing/app_router.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. تهيئة الـ Service Locator
  await initServiceLocator();
  
  runApp(const PosApp());
}

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( // استخدام .router بدلاً من home
      title: 'نظام نقاط البيع',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // نظام التوجيه
      routerConfig: AppRouter.router,
      
      // إعدادات اللغة لدعم السوق المصري (RTL)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'EG'),
      ],
      locale: const Locale('ar', 'EG'),
    );
  }
}