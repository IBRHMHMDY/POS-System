import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/database/app_database.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getUserByPasscode(String passcode);
  Future<void> cacheCurrentUserId(int userId);
  Future<void> clearCurrentUserId();
  Future<UserModel?> getCurrentUser();
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
    final usersCount = await db.select(db.users).get();
    if (usersCount.isEmpty) {
      await db.into(db.users).insert(
        UsersCompanion.insert(
          name: 'المالك الافتراضي',
          role: 'owner',
          passcode: '0000',
          isActive: const Value(true), // مستخدم نشط
        ),
      );
    }
  }

  @override
  Future<UserModel?> getUserByPasscode(String passcode) async {
    await seedDefaultOwnerIfEmpty();
    
    final query = db.select(db.users)..where((u) => u.passcode.equals(passcode));
    final driftUser = await query.getSingleOrNull();

    if (driftUser != null) {
      if (!driftUser.isActive) {
        throw Exception('INACTIVE_USER'); // رمي استثناء ليتم التقاطه في الـ Repository
      }
      return UserModel.fromDriftUser(driftUser);
    }
    return null;
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
  Future<UserModel?> getCurrentUser() async {
    final userId = sharedPreferences.getInt(cachedUserIdKey);
    if (userId != null) {
      final query = db.select(db.users)..where((u) => u.id.equals(userId));
      final driftUser = await query.getSingleOrNull();
      
      if (driftUser != null && driftUser.isActive) {
        return UserModel.fromDriftUser(driftUser);
      }
    }
    return null;
  }
}