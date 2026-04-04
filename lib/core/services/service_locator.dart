import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// استدعاء ملفات ميزة التراخيص
import '../../features/licensing/data/datasources/license_local_data_source.dart';
import '../../features/licensing/data/repositories/license_repository_impl.dart';
import '../../features/licensing/domain/repositories/license_repository.dart';
import '../../features/licensing/domain/usecases/activate_license_usecase.dart';
import '../../features/licensing/domain/usecases/check_license_status_usecase.dart';
import '../../features/licensing/domain/usecases/get_device_id_usecase.dart';
import '../../features/licensing/presentation/bloc/licensing_bloc.dart';

// استدعاء الأدوات المشتركة
import '../utils/device_info_utils.dart';

final sl = GetIt.instance; // sl: Service Locator

Future<void> initServiceLocator() async {
  // ==========================================
  // 1. Core & External (الأدوات والحزم الخارجية)
  // ==========================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DeviceInfoPlugin());
  sl.registerLazySingleton(() => DeviceInfoUtils(deviceInfoPlugin: sl()));

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
}