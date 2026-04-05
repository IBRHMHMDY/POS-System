import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/invoice_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.shiftId,
    required super.totalAmount,
    super.discount,
    super.tax,
    required super.finalAmount,
    required super.paymentMethod,
    required super.createdAt,
  });

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      shiftId: entity.shiftId,
      totalAmount: entity.totalAmount,
      discount: entity.discount,
      tax: entity.tax,
      finalAmount: entity.finalAmount,
      paymentMethod: entity.paymentMethod,
      createdAt: entity.createdAt,
    );
  }

  factory OrderModel.fromDriftOrder(db.Invoice driftOrder) {
    return OrderModel(
      id: driftOrder.id,
      shiftId: driftOrder.shiftId,
      totalAmount: driftOrder.totalAmount,
      discount: driftOrder.discount,
      tax: driftOrder.tax,
      finalAmount: driftOrder.finalAmount,
      paymentMethod: _mapStringToPaymentMethod(driftOrder.paymentMethod),
      createdAt: driftOrder.createdAt,
    );
  }

  db.OrdersCompanion toDriftCompanion() {
    return db.OrdersCompanion(
      id: id == 0 ? const drift.Value.absent() : drift.Value(id),
      shiftId: drift.Value(shiftId),
      totalAmount: drift.Value(totalAmount),
      discount: drift.Value(discount),
      tax: drift.Value(tax),
      finalAmount: drift.Value(finalAmount),
      paymentMethod: drift.Value(_mapPaymentMethodToString(paymentMethod)),
      createdAt: drift.Value(createdAt),
    );
  }

  static PaymentMethod _mapStringToPaymentMethod(String method) {
    switch (method) {
      case 'visa': return PaymentMethod.visa;
      case 'later': return PaymentMethod.later;
      case 'cash':
      default: return PaymentMethod.cash;
    }
  }

  static String _mapPaymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.visa: return 'visa';
      case PaymentMethod.later: return 'later';
      case PaymentMethod.cash: return 'cash';
    }
  }
}