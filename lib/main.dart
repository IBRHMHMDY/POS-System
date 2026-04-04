import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Initialize Dependency Injection (get_it)
  // TODO: Initialize Local Database (Drift)
  
  runApp(const PosApp());
}

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // دعم اللغة العربية وتوجيه الواجهة RTL
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'EG'), // العربية - مصر
      ],
      locale: const Locale('ar', 'EG'),
      home: const Scaffold(
        body: Center(
          child: Text('جاري تهيئة نظام نقاط البيع...'),
        ),
      ),
    );
  }
}