import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_local_data_source.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuLocalDataSource localDataSource;

  MenuRepositoryImpl({required this.localDataSource});

  // ==========================================
  // Categories
  // ==========================================
  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final categories = await localDataSource.getAllCategories();
      return Right(categories);
    } catch (e) {
      return Left(DatabaseFailure('فشل في جلب الأقسام: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> addCategory(CategoryEntity category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      final result = await localDataSource.addCategory(model);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure('فشل في إضافة القسم: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory(CategoryEntity category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      final result = await localDataSource.updateCategory(model);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure('فشل في تعديل القسم: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int categoryId) async {
    try {
      await localDataSource.deleteCategory(categoryId);
      return const Right(null);
    } catch (e) {
      // إذا كان هناك منتجات مرتبطة بهذا القسم، الـ Foreign Key الخاص بـ Drift سيرمي خطأ
      return Left(DatabaseFailure('لا يمكن حذف القسم لوجود منتجات مرتبطة به، أو لخطأ آخر.'));
    }
  }

  // ==========================================
  // Products
  // ==========================================
  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(int categoryId) async {
    try {
      final products = await localDataSource.getProductsByCategory(categoryId);
      return Right(products);
    } catch (e) {
      return Left(DatabaseFailure('فشل في جلب المنتجات: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    try {
      final products = await localDataSource.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(DatabaseFailure('فشل في جلب كل المنتجات: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity?>> getProductByBarcode(String barcode) async {
    try {
      final product = await localDataSource.getProductByBarcode(barcode);
      return Right(product);
    } catch (e) {
      return Left(DatabaseFailure('فشل في البحث عن المنتج: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> addProduct(ProductEntity product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final result = await localDataSource.addProduct(model);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure('فشل في إضافة المنتج: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(ProductEntity product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final result = await localDataSource.updateProduct(model);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure('فشل في تعديل المنتج: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int productId) async {
    try {
      await localDataSource.deleteProduct(productId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('فشل في حذف المنتج: ${e.toString()}'));
    }
  }
}