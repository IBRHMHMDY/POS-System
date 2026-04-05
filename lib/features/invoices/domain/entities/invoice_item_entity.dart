import 'package:equatable/equatable.dart';

class InvoiceItemEntity extends Equatable {
  final int id;
  final int? invoiceId; // سيكون null قبل حفظ الفاتورة في قاعدة البيانات
  final int productId;
  final String productName; // حفظ الاسم وقت البيع لضمان استقرار الفواتير القديمة
  final double quantity; 
  final double unitPrice; // سعر الوحدة وقت البيع
  final double totalPrice;

  const InvoiceItemEntity({
    required this.id,
    this.invoiceId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
        id,
        invoiceId,
        productId,
        productName,
        quantity,
        unitPrice,
        totalPrice,
      ];
}