import 'package:equatable/equatable.dart';

enum PaymentMethod { cash, visa, later }

class InvoiceEntity extends Equatable {
  final int id;
  final int shiftId;
  final int userId; // تم إضافة حقل المستخدم الذي أنشأ الفاتورة
  final double subTotal; // تعديل المسمى
  final double discount;
  final double tax;
  final double grandTotal; // تعديل المسمى
  final PaymentMethod paymentMethod;
  final DateTime date; // تعديل المسمى

  const InvoiceEntity({
    required this.id,
    required this.shiftId,
    required this.userId,
    required this.subTotal,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.grandTotal,
    required this.paymentMethod,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        shiftId,
        userId,
        subTotal,
        discount,
        tax,
        grandTotal,
        paymentMethod,
        date,
      ];
}