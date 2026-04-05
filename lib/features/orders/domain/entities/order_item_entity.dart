import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final int? orderId; // سيكون null قبل حفظ الفاتورة في قاعدة البيانات
  final int productId;
  final String productName; // حفظ الاسم وقت البيع لضمان استقرار الفواتير
  final double quantity; // double للسماح ببيع المنتجات بالوزن (مثل 1.5 كجم)
  final double unitPrice; // سعر الوحدة وقت البيع
  final double totalPrice;

  const OrderItemEntity({
    required this.id,
    this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        productId,
        productName,
        quantity,
        unitPrice,
        totalPrice,
      ];
}