import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_system/core/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

// استدعاء الأدوات المشتركة
import '../utils/device_info_utils.dart';

// License Feature
import '../../features/licensing/data/datasources/license_local_data_source.dart';
import '../../features/licensing/data/repositories/license_repository_impl.dart';
import '../../features/licensing/domain/repositories/license_repository.dart';
import '../../features/licensing/domain/usecases/activate_license_usecase.dart';
import '../../features/licensing/domain/usecases/check_license_status_usecase.dart';
import '../../features/licensing/domain/usecases/get_device_id_usecase.dart';
import '../../features/licensing/presentation/bloc/licensing_bloc.dart';
// Auth Feature
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';


final sl = GetIt.instance; // sl: Service Locator

Future<void> initServiceLocator() async {
  // ==========================================
  // 1. Core & External (الأدوات والحزم الخارجية)
  // ==========================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DeviceInfoPlugin());
  sl.registerLazySingleton(() => DeviceInfoUtils(deviceInfoPlugin: sl()));
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  // ==========================================
  // 2. Features - Licensing (ميزة التراخيص)
  // ==========================================
  // Data Sources
  sl.registerLazySingleton<LicenseLocalDataSource>(
    () => LicenseLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<LicenseRepository>(
    () => LicenseRepositoryImpl(
      localDataSource: sl(),
      deviceInfoUtils: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDeviceIdUseCase(sl()));
  sl.registerLazySingleton(() => CheckLicenseStatusUseCase(sl()));
  sl.registerLazySingleton(() => ActivateLicenseUseCase(sl()));

  // BLoC (يتم تسجيله كـ Factory لأنه يجب إنشاء نسخة جديدة عند كل استخدام للشاشة)
  sl.registerFactory(
    () => LicensingBloc(
      getDeviceIdUseCase: sl(),
      checkLicenseStatusUseCase: sl(),
      activateLicenseUseCase: sl(),
    ),
  );

  // ==========================================
  // 3. Features - Auth (المصادقة والمستخدمين)
  // ==========================================
  
  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      db: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // BLoC (Factory لضمان إنشاء نسخة جديدة ومستقلة مع كل شاشة)
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  
}