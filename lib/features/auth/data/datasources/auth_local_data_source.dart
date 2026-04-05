import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/database/app_database.dart';

abstract class AuthLocalDataSource {
  Future<User?> getUserByPasscode(String passcode);
  Future<void> cacheCurrentUserId(int userId);
  Future<void> clearCurrentUserId();
  Future<User?> getCurrentUser();
  Future<void> seedDefaultOwnerIfEmpty();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase db;
  final SharedPreferences sharedPreferences;

  static const String cachedUserIdKey = 'CACHED_USER_ID';

  AuthLocalDataSourceImpl({
    required this.db,
    required this.sharedPreferences,
  });

  @override
  Future<void> seedDefaultOwnerIfEmpty() async {
    // التحقق مما إذا كان جدول المستخدمين فارغاً
    final usersCount = await db.select(db.users).get();
    if (usersCount.isEmpty) {
      // إنشاء مستخدم افتراضي بصلاحية المالك (Owner) برمز دخول 0000
      await db.into(db.users).insert(
        UsersCompanion.insert(
          name: 'المالك الافتراضي',
          role: 'owner',
          passcode: '0000',
          isActive: const Value(true),
        ),
      );
    }
  }

  @override
  Future<User?> getUserByPasscode(String passcode) async {
    await seedDefaultOwnerIfEmpty(); // التأكد من وجود مستخدمين أولاً
    
    final query = db.select(db.users)..where((u) => u.passcode.equals(passcode));
    return await query.getSingleOrNull();
  }

  @override
  Future<void> cacheCurrentUserId(int userId) async {
    await sharedPreferences.setInt(cachedUserIdKey, userId);
  }

  @override
  Future<void> clearCurrentUserId() async {
    await sharedPreferences.remove(cachedUserIdKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final userId = sharedPreferences.getInt(cachedUserIdKey);
    if (userId != null) {
      final query = db.select(db.users)..where((u) => u.id.equals(userId));
      return await query.getSingleOrNull();
    }
    return null;
  }
}