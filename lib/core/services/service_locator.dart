import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_system/core/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

// استدعاء الأدوات المشتركة
import '../utils/device_info_utils.dart';

// License Feature
import 'package:pos_system/features/licensing/data/datasources/license_local_data_source.dart';
import 'package:pos_system/features/licensing/data/repositories/license_repository_impl.dart';
import 'package:pos_system/features/licensing/domain/repositories/license_repository.dart';
import 'package:pos_system/features/licensing/domain/usecases/activate_license_usecase.dart';
import 'package:pos_system/features/licensing/domain/usecases/check_license_status_usecase.dart';
import 'package:pos_system/features/licensing/domain/usecases/get_device_id_usecase.dart';
import 'package:pos_system/features/licensing/presentation/bloc/licensing_bloc.dart';
// Auth Feature
import 'package:pos_system/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pos_system/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pos_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:pos_system/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:pos_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:pos_system/features/auth/domain/usecases/logout_usecase.dart';
import 'package:pos_system/features/auth/presentation/bloc/auth_bloc.dart';
// Menu Feature
import 'package:pos_system/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:pos_system/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:pos_system/features/menu/domain/repositories/menu_repository.dart';
import 'package:pos_system/features/menu/domain/usecases/categories/add_category_usecase.dart';
import 'package:pos_system/features/menu/domain/usecases/categories/delete_category_usecase.dart';
import 'package:pos_system/features/menu/domain/usecases/categories/get_all_categories_usecase.dart';
import 'package:pos_system/features/menu/domain/usecases/categories/update_category_usecase.dart';
import 'package:pos_system/features/menu/domain/usecases/products/add_product_usecase.dart';
import 'package:pos_system/features/menu/domain/usecases/products/delete_product_usecase.dart';
import 'package:pos_system/features/menu/domain/usecases/products/get_all_products_usecase.dart';
import 'package:pos_system/features/menu/domain/usecases/products/get_product_by_barcode_usecase.dart';
import 'package:pos_system/features/menu/domain/usecases/products/get_products_by_category_usecase.dart';
import 'package:pos_system/features/menu/domain/usecases/products/update_product_usecase.dart';
import 'package:pos_system/features/menu/presentation/bloc/category/category_bloc.dart';
import 'package:pos_system/features/menu/presentation/bloc/product/product_bloc.dart';
// استدعاء ملفات ميزة الورديات (Shifts & Expenses)
import 'package:pos_system/features/shifts/data/datasource/expense_local_data_source.dart';
import 'package:pos_system/features/shifts/data/datasource/shift_local_data_source.dart';
import 'package:pos_system/features/shifts/data/repositories/expense_repository_impl.dart';
import 'package:pos_system/features/shifts/data/repositories/shift_repository_impl.dart';
import 'package:pos_system/features/shifts/domain/repositories/expense_repository.dart';
import 'package:pos_system/features/shifts/domain/repositories/shift_repository.dart';
import 'package:pos_system/features/shifts/domain/usecases/expenses/add_expense_usecase.dart';
import 'package:pos_system/features/shifts/domain/usecases/expenses/get_expenses_for_shift_usecase.dart';
import 'package:pos_system/features/shifts/domain/usecases/shifts/close_shift_usecase.dart';
import 'package:pos_system/features/shifts/domain/usecases/shifts/get_current_active_shift_usecase.dart';
import 'package:pos_system/features/shifts/domain/usecases/shifts/get_shift_history_usecase.dart';
import 'package:pos_system/features/shifts/domain/usecases/shifts/open_shift_usecase.dart';
import 'package:pos_system/features/shifts/presentation/bloc/expense/expense_bloc.dart';
import 'package:pos_system/features/shifts/presentation/bloc/shift/shift_bloc.dart';
// استدعاء ملفات ميزة المبيعات (Invoices & Cart)
import 'package:pos_system/features/invoices/data/datasources/invoice_local_data_source.dart';
import 'package:pos_system/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:pos_system/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:pos_system/features/invoices/domain/usecases/create_invoice_usecase.dart';
import 'package:pos_system/features/invoices/domain/usecases/get_invoice_items_usecase.dart';
import 'package:pos_system/features/invoices/domain/usecases/get_invoices_by_shift_usecase.dart';
import 'package:pos_system/features/invoices/presentation/bloc/cart/cart_bloc.dart';


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

  // ==========================================
  // 4. Features - Menu (قوائم الطعام)
  // ==========================================
  
  // Data Sources
  sl.registerLazySingleton<MenuLocalDataSource>(
    () => MenuLocalDataSourceImpl(db: sl()),
  );

  // Repositories
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(localDataSource: sl()),
  );

  // Categories Use Cases
  sl.registerLazySingleton(() => GetAllCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => AddCategoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));

  // Products Use Cases
  sl.registerLazySingleton(() => GetProductsByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetAllProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByBarcodeUseCase(sl()));
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));

  // BLoCs
  sl.registerFactory(
    () => CategoryBloc(
      getAllCategoriesUseCase: sl(),
      addCategoryUseCase: sl(),
      updateCategoryUseCase: sl(),
      deleteCategoryUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ProductBloc(
      getAllProductsUseCase: sl(),
      getProductsByCategoryUseCase: sl(),
      getProductByBarcodeUseCase: sl(),
      addProductUseCase: sl(),
      updateProductUseCase: sl(),
      deleteProductUseCase: sl(),
    ),
  );

  // ==========================================
  // 5. Features - Shifts & Expenses (الورديات والمصروفات)
  // ==========================================
  
  // Data Sources
  sl.registerLazySingleton<ShiftLocalDataSource>(
    () => ShiftLocalDataSourceImpl(db: sl()),
  );
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(db: sl()),
  );

  // Repositories
  // نلاحظ هنا تمرير authLocalDataSource و shiftLocalDataSource كما صممناهم
  sl.registerLazySingleton<ShiftRepository>(
    () => ShiftRepositoryImpl(
      shiftLocalDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      expenseLocalDataSource: sl(),
      shiftLocalDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );

  // Shifts Use Cases
  sl.registerLazySingleton(() => GetCurrentActiveShiftUseCase(sl()));
  sl.registerLazySingleton(() => OpenShiftUseCase(sl()));
  sl.registerLazySingleton(() => CloseShiftUseCase(sl()));
  sl.registerLazySingleton(() => GetShiftHistoryUseCase(sl()));

  // Expenses Use Cases
  sl.registerLazySingleton(() => AddExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetExpensesForShiftUseCase(sl()));

  // BLoCs
  sl.registerFactory(
    () => ShiftBloc(
      getCurrentActiveShiftUseCase: sl(),
      openShiftUseCase: sl(),
      closeShiftUseCase: sl(),
      getShiftHistoryUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ExpenseBloc(
      addExpenseUseCase: sl(),
      getExpensesForShiftUseCase: sl(),
    ),
  );

  // ==========================================
  // 6. Features - Invoices & Cart (المبيعات والفواتير)
  // ==========================================
  
  // Data Sources
  sl.registerLazySingleton<InvoiceLocalDataSource>(
    () => InvoiceLocalDataSourceImpl(db: sl()),
  );

  // Repositories
  sl.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepositoryImpl(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateInvoiceUseCase(sl()));
  sl.registerLazySingleton(() => GetInvoicesByShiftUseCase(sl()));
  sl.registerLazySingleton(() => GetInvoiceItemsUseCase(sl()));

  // BLoCs
  sl.registerFactory(
    () => CartBloc(
      createInvoiceUseCase: sl(),
    ),
  );



}