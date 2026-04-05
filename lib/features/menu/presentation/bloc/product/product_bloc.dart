import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/usecases/usecase.dart';
import '../../../domain/usecases/products/add_product_usecase.dart';
import '../../../domain/usecases/products/delete_product_usecase.dart';
import '../../../domain/usecases/products/get_all_products_usecase.dart';
import '../../../domain/usecases/products/get_product_by_barcode_usecase.dart';
import '../../../domain/usecases/products/get_products_by_category_usecase.dart';
import '../../../domain/usecases/products/update_product_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  final GetProductByBarcodeUseCase getProductByBarcodeUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductBloc({
    required this.getAllProductsUseCase,
    required this.getProductsByCategoryUseCase,
    required this.getProductByBarcodeUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(ProductInitial()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<LoadProductsByCategoryEvent>(_onLoadProductsByCategory);
    on<SearchProductByBarcodeEvent>(_onSearchProductByBarcode);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadAllProducts(LoadAllProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getAllProductsUseCase(const NoParams());
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> _onLoadProductsByCategory(LoadProductsByCategoryEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProductsByCategoryUseCase(event.categoryId);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> _onSearchProductByBarcode(SearchProductByBarcodeEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProductByBarcodeUseCase(event.barcode);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) {
        if (product != null) {
          emit(SingleProductLoaded(product));
        } else {
          emit(const ProductError('لم يتم العثور على منتج بهذا الباركود'));
        }
      },
    );
  }

  Future<void> _onAddProduct(AddProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await addProductUseCase(event.product);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) {
        emit(const ProductActionSuccess('تمت إضافة المنتج بنجاح'));
        add(LoadAllProductsEvent()); // تحديث القائمة بعد الإضافة
      },
    );
  }

  Future<void> _onUpdateProduct(UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await updateProductUseCase(event.product);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) {
        emit(const ProductActionSuccess('تم تعديل المنتج بنجاح'));
        add(LoadAllProductsEvent());
      },
    );
  }

  Future<void> _onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await deleteProductUseCase(event.productId);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) {
        emit(const ProductActionSuccess('تم حذف المنتج بنجاح'));
        add(LoadAllProductsEvent());
      },
    );
  }
}