import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/features/licensing/presentation/screens/licensing_screen.dart';

import '../../features/licensing/presentation/bloc/licensing_bloc.dart';
import '../services/service_locator.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/license', // المسار الافتراضي حالياً حتى نبرمج المصادقة
    routes: [
      GoRoute(
        path: '/license',
        name: 'license',
        builder: (context, state) {
          // يتم تزويد الشاشة بـ BLoC هنا عبر Service Locator
          return BlocProvider(
            create: (_) => sl<LicensingBloc>(),
            child: const LicensingScreen(),
          );
        },
      ),
      // TODO: سيتم إضافة مسارات (Login, POS, Settings) لاحقاً هنا
    ],
    // صفحة تظهر في حالة حدوث خطأ في التوجيه
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('عذراً، الصفحة غير موجودة: ${state.error}'),
      ),
    ),
  );
}