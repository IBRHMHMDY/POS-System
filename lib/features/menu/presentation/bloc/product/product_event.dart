import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadAllProductsEvent extends ProductEvent {}

class LoadProductsByCategoryEvent extends ProductEvent {
  final int categoryId;
  const LoadProductsByCategoryEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SearchProductByBarcodeEvent extends ProductEvent {
  final String barcode;
  const SearchProductByBarcodeEvent(this.barcode);

  @override
  List<Object> get props => [barcode];
}

class AddProductEvent extends ProductEvent {
  final ProductEntity product;
  const AddProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class UpdateProductEvent extends ProductEvent {
  final ProductEntity product;
  const UpdateProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final int productId;
  const DeleteProductEvent(this.productId);

  @override
  List<Object> get props => [productId];
}