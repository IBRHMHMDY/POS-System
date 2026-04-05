import '../../../../core/database/app_database.dart' as db_models;
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.role,
  });

  /// دالة مساعدة لتحويل كائن (User) القادم من جداول Drift إلى (UserModel)
  factory UserModel.fromDriftUser(db_models.User driftUser) {
    return UserModel(
      id: driftUser.id,
      name: driftUser.name,
      role: _mapRoleStringToEnum(driftUser.role),
    );
  }

  /// دالة مساعدة لتحويل النص المحفوظ في قاعدة البيانات إلى Enum
  static UserRole _mapRoleStringToEnum(String roleStr) {
    switch (roleStr) {
      case 'owner':
        return UserRole.owner;
      case 'manager':
        return UserRole.manager;
      case 'cashier':
      default:
        return UserRole.cashier;
    }
  }
}