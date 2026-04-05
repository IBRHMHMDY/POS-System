import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.price,
    super.barcode,
    super.imagePath,
    super.isActive,
  });

  factory ProductModel.fromDriftProduct(db.Product driftProduct) {
    return ProductModel(
      id: driftProduct.id,
      categoryId: driftProduct.categoryId,
      name: driftProduct.name,
      price: driftProduct.price,
      barcode: driftProduct.barcode,
      imagePath: driftProduct.imagePath,
      isActive: driftProduct.isActive,
    );
  }

  db.ProductsCompanion toDriftCompanion() {
    return db.ProductsCompanion(
      id: id == 0 ? const drift.Value.absent() : drift.Value(id),
      categoryId: drift.Value(categoryId),
      name: drift.Value(name),
      price: drift.Value(price),
      barcode: drift.Value(barcode),
      imagePath: drift.Value(imagePath),
      isActive: drift.Value(isActive),
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      categoryId: entity.categoryId,
      name: entity.name,
      price: entity.price,
      barcode: entity.barcode,
      imagePath: entity.imagePath,
      isActive: entity.isActive,
    );
  }
}