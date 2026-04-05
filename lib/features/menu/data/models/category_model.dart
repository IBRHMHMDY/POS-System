import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    super.imagePath,
    super.isActive,
  });

  /// تحويل من جدول (Drift) إلى (Model)
  factory CategoryModel.fromDriftCategory(db.Category driftCategory) {
    return CategoryModel(
      id: driftCategory.id,
      name: driftCategory.name,
      imagePath: driftCategory.imagePath,
      isActive: driftCategory.isActive,
    );
  }

  /// تحويل من (Model / Entity) إلى (Drift Companion) للإدخال والتعديل
  db.CategoriesCompanion toDriftCompanion() {
    return db.CategoriesCompanion(
      // إذا كان الـ ID يساوي 0 (عند الإضافة الجديدة)، نتركه ليتولد تلقائياً
      id: id == 0 ? const drift.Value.absent() : drift.Value(id),
      name: drift.Value(name),
      imagePath: drift.Value(imagePath),
      isActive: drift.Value(isActive),
    );
  }

  /// تحويل من (Entity) عام إلى (Model)
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      imagePath: entity.imagePath,
      isActive: entity.isActive,
    );
  }
}