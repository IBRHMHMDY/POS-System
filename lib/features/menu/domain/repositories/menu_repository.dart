import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class MenuRepository {
  // ==========================================
  // عمليات الأقسام (Categories Operations)
  // ==========================================
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, CategoryEntity>> addCategory(CategoryEntity category);
  Future<Either<Failure, CategoryEntity>> updateCategory(CategoryEntity category);
  Future<Either<Failure, void>> deleteCategory(int categoryId);

  // ==========================================
  // عمليات المنتجات (Products Operations)
  // ==========================================
  /// جلب المنتجات التابعة لقسم معين
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(int categoryId);
  
  /// جلب جميع المنتجات (مفيدة في شاشة البحث السريع أو الجرد)
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();
  
  /// البحث عن منتج بواسطة الباركود السريع
  Future<Either<Failure, ProductEntity?>> getProductByBarcode(String barcode);
  
  Future<Either<Failure, ProductEntity>> addProduct(ProductEntity product);
  Future<Either<Failure, ProductEntity>> updateProduct(ProductEntity product);
  Future<Either<Failure, void>> deleteProduct(int productId);
}