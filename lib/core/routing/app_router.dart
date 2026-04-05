import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/features/auth/presentation/screens/login_screen.dart';
import 'package:pos_system/features/licensing/presentation/screens/licensing_screen.dart';

// Licensing
import '../../features/licensing/presentation/bloc/licensing_bloc.dart';

// Auth
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';

import '../services/service_locator.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login', // يبدأ بالتراخيص للتحقق منها أولاً
    routes: [
      GoRoute(
        path: '/license',
        name: 'license',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => sl<LicensingBloc>(),
            child: const LicensingScreen(),
          );
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return BlocProvider(
            // نقوم بإضافة حدث CheckAuthStatusEvent فور بناء الـ BLoC
            // للتحقق مما إذا كان هناك جلسة سابقة محفوظة لعدم إجبار الكاشير على التسجيل مجدداً
            create: (_) => sl<AuthBloc>()..add(CheckAuthStatusEvent()),
            child: const LoginScreen(),
          );
        },
      ),
      // TODO: سيتم إضافة مسارات (POS, Admin Dashboard) لاحقاً
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('عذراً، الصفحة غير موجودة: ${state.error}'),
      ),
    ),
  );
}