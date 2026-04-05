import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/features/auth/presentation/screens/login_screen.dart';
import 'package:pos_system/features/licensing/presentation/screens/licensing_screen.dart';
import 'package:pos_system/features/shifts/presentation/bloc/expense/expense_bloc.dart';
import 'package:pos_system/features/shifts/presentation/bloc/shift/shift_bloc.dart';
import 'package:pos_system/features/shifts/presentation/screens/shift_screen.dart';

// Licensing
import 'package:pos_system/features/licensing/presentation/bloc/licensing_bloc.dart';

// Auth
import 'package:pos_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pos_system/features/auth/presentation/bloc/auth_event.dart';
// Menu
import 'package:pos_system/features/menu/presentation/bloc/category/category_bloc.dart';
import 'package:pos_system/features/menu/presentation/bloc/product/product_bloc.dart';
import 'package:pos_system/features/menu/presentation/screens/menu_admin_screen.dart';
// POS & Invoices
import '../../features/invoices/presentation/bloc/cart/cart_bloc.dart';
import '../../features/invoices/presentation/screens/pos_screen.dart';

import '../services/service_locator.dart';



class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/license', // يبدأ بالتراخيص للتحقق منها أولاً
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
      GoRoute(
        path: '/menu-admin',
        name: 'menu_admin',
        builder: (context, state) {
          // الشاشة تحتاج إلى 2 BLoC معاً، لذلك نستخدم MultiBlocProvider
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CategoryBloc>()),
              BlocProvider(create: (_) => sl<ProductBloc>()),
            ],
            child: const MenuAdminScreen(),
          );
        },
      ),
      GoRoute(
        path: '/shifts',
        name: 'shifts',
        builder: (context, state) {
          // الشاشة تحتاج إلى ShiftBloc و ExpenseBloc معاً
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<ShiftBloc>()),
              BlocProvider(create: (_) => sl<ExpenseBloc>()),
            ],
            child: const ShiftScreen(),
          );
        },
      ),
      GoRoute(
        path: '/pos',
        name: 'pos',
        builder: (context, state) {
          // شاشة الـ POS هي الشاشة الأكبر وتتطلب 4 BLoCs لتعمل معاً بكفاءة
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<ShiftBloc>()),
              BlocProvider(create: (_) => sl<CategoryBloc>()),
              BlocProvider(create: (_) => sl<ProductBloc>()),
              BlocProvider(create: (_) => sl<CartBloc>()),
            ],
            child: const PosScreen(),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('عذراً، الصفحة غير موجودة: ${state.error}'),
      ),
    ),
  );
}