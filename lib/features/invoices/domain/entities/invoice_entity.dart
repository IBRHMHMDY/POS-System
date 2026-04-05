import 'package:equatable/equatable.dart';

enum PaymentMethod { cash, visa, later }

class InvoiceEntity extends Equatable {
  final int id;
  final int shiftId; // ربط الفاتورة بالوردية الحالية
  final double totalAmount; // الإجمالي قبل الخصم والضريبة
  final double discount;
  final double tax;
  final double finalAmount; // الإجمالي النهائي المطلوب دفعه
  final PaymentMethod paymentMethod;
  final DateTime createdAt;

  const InvoiceEntity({
    required this.id,
    required this.shiftId,
    required this.totalAmount,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.finalAmount,
    required this.paymentMethod,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        shiftId,
        totalAmount,
        discount,
        tax,
        finalAmount,
        paymentMethod,
        createdAt,
      ];
}