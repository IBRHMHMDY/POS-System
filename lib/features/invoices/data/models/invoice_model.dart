import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/invoice_entity.dart';

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.id,
    required super.shiftId,
    required super.userId,
    required super.subTotal,
    super.discount,
    super.tax,
    required super.grandTotal,
    required super.paymentMethod,
    required super.date,
  });

  factory InvoiceModel.fromEntity(InvoiceEntity entity) {
    return InvoiceModel(
      id: entity.id,
      shiftId: entity.shiftId,
      userId: entity.userId,
      subTotal: entity.subTotal,
      discount: entity.discount,
      tax: entity.tax,
      grandTotal: entity.grandTotal,
      paymentMethod: entity.paymentMethod,
      date: entity.date,
    );
  }

  factory InvoiceModel.fromDriftInvoice(db.Invoice driftInvoice) {
    return InvoiceModel(
      id: driftInvoice.id,
      shiftId: driftInvoice.shiftId,
      userId: driftInvoice.userId,
      subTotal: driftInvoice.subTotal,
      discount: driftInvoice.discount,
      tax: driftInvoice.tax,
      grandTotal: driftInvoice.grandTotal,
      paymentMethod: _mapStringToPaymentMethod(driftInvoice.paymentMethod),
      date: driftInvoice.date,
    );
  }

  db.InvoicesCompanion toDriftCompanion() {
    return db.InvoicesCompanion(
      id: id == 0 ? const drift.Value.absent() : drift.Value(id),
      shiftId: drift.Value(shiftId),
      userId: drift.Value(userId),
      subTotal: drift.Value(subTotal),
      discount: drift.Value(discount),
      tax: drift.Value(tax),
      grandTotal: drift.Value(grandTotal),
      paymentMethod: drift.Value(_mapPaymentMethodToString(paymentMethod)),
      date: drift.Value(date),
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
      case PaymentMethod.cash:
      default: return 'cash';
    }
  }
}