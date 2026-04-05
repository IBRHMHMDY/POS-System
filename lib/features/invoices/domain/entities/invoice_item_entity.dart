import 'package:equatable/equatable.dart';

class InvoiceItemEntity extends Equatable {
  final int id;
  final int? invoiceId;
  final int productId;
  // تم إزالة productName لأنه غير موجود في قاعدة البيانات
  final double quantity;
  final double unitPrice;
  final double totalPrice;

  const InvoiceItemEntity({
    required this.id,
    this.invoiceId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
        id,
        invoiceId,
        productId,
        quantity,
        unitPrice,
        totalPrice,
      ];
}