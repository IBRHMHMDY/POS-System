import 'package:equatable/equatable.dart';
import '../../../../menu/domain/entities/product_entity.dart';
import '../../../domain/entities/invoice_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddProductToCartEvent extends CartEvent {
  final ProductEntity product;
  const AddProductToCartEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveProductFromCartEvent extends CartEvent {
  final int productId;
  const RemoveProductFromCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateCartItemQuantityEvent extends CartEvent {
  final int productId;
  final double quantity;
  const UpdateCartItemQuantityEvent(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class ApplyDiscountEvent extends CartEvent {
  final double discount;
  const ApplyDiscountEvent(this.discount);

  @override
  List<Object?> get props => [discount];
}

class ApplyTaxEvent extends CartEvent {
  final double tax;
  const ApplyTaxEvent(this.tax);

  @override
  List<Object?> get props => [tax];
}

class ClearCartEvent extends CartEvent {}

class CheckoutCartEvent extends CartEvent {
  final int shiftId;
  final int userId;
  final PaymentMethod paymentMethod;

  const CheckoutCartEvent({
    required this.shiftId,
    required this.userId,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [shiftId, userId, paymentMethod];
}