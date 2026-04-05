import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class MenuLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> addCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<void> deleteCategory(int categoryId);

  Future<List<ProductModel>> getProductsByCategory(int categoryId);
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductByBarcode(String barcode);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(int productId);
}

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  final AppDatabase db;

  MenuLocalDataSourceImpl({required this.db});

  // ==========================================
  // Categories
  // ==========================================
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final query = db.select(db.categories)..orderBy([(t) => OrderingTerm.asc(t.name)]);
    final result = await query.get();
    return result.map((c) => CategoryModel.fromDriftCategory(c)).toList();
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    final id = await db.into(db.categories).insert(category.toDriftCompanion());
    final inserted = await (db.select(db.categories)..where((t) => t.id.equals(id))).getSingle();
    return CategoryModel.fromDriftCategory(inserted);
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    await db.update(db.categories).replace(category.toDriftCompanion());
    return category; // نعيد نفس الكائن لأنه يحمل البيانات المحدثة
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    await (db.delete(db.categories)..where((t) => t.id.equals(categoryId))).go();
  }

  // ==========================================
  // Products
  // ==========================================
  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final query = db.select(db.products)
      ..where((t) => t.categoryId.equals(categoryId))
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    final result = await query.get();
    return result.map((p) => ProductModel.fromDriftProduct(p)).toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final query = db.select(db.products)..orderBy([(t) => OrderingTerm.asc(t.name)]);
    final result = await query.get();
    return result.map((p) => ProductModel.fromDriftProduct(p)).toList();
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    final query = db.select(db.products)..where((t) => t.barcode.equals(barcode));
    final result = await query.getSingleOrNull();
    if (result != null) {
      return ProductModel.fromDriftProduct(result);
    }
    return null;
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final id = await db.into(db.products).insert(product.toDriftCompanion());
    final inserted = await (db.select(db.products)..where((t) => t.id.equals(id))).getSingle();
    return ProductModel.fromDriftProduct(inserted);
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await db.update(db.products).replace(product.toDriftCompanion());
    return product;
  }

  @override
  Future<void> deleteProduct(int productId) async {
    await (db.delete(db.products)..where((t) => t.id.equals(productId))).go();
  }
}