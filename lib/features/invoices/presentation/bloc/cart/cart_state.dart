import 'package:equatable/equatable.dart';
import '../../../../menu/domain/entities/product_entity.dart';

// موديل مساعد للواجهة فقط لسهولة عرض اسم وصورة المنتج في السلة
class CartItem extends Equatable {
  final ProductEntity product;
  final double quantity;

  const CartItem({required this.product, this.quantity = 1.0});

  double get totalPrice => product.price * quantity;

  CartItem copyWith({ProductEntity? product, double? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];
}

enum CartStatus { initial, updated, loading, checkoutSuccess, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItem> items;
  final double subTotal;
  final double discount;
  final double tax;
  final double grandTotal;
  final String? message;
  final bool clearMessage = true;
  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.subTotal = 0.0,
    this.discount = 0.0,
    this.tax = 0.0,
    this.grandTotal = 0.0,
    this.message,
    clearMessage,
  });

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    double? subTotal,
    double? discount,
    double? tax,
    double? grandTotal,
    String? message,
    bool clearMessage = false, // للتحكم في مسح رسائل الإشعارات السابقة
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      subTotal: subTotal ?? this.subTotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      grandTotal: grandTotal ?? this.grandTotal,
      message: clearMessage ? null : (message ?? this.message),
      clearMessage: true,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    subTotal,
    discount,
    tax,
    grandTotal,
    message,
  ];
}
