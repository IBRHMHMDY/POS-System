import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/invoice_item_entity.dart';

class InvoiceItemModel extends InvoiceItemEntity {
  const InvoiceItemModel({
    required super.id,
    super.invoiceId,
    required super.productId,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
  });

  factory InvoiceItemModel.fromEntity(InvoiceItemEntity entity) {
    return InvoiceItemModel(
      id: entity.id,
      invoiceId: entity.invoiceId,
      productId: entity.productId,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      totalPrice: entity.totalPrice,
    );
  }

  factory InvoiceItemModel.fromDriftInvoiceItem(db.InvoiceItem driftItem) {
    return InvoiceItemModel(
      id: driftItem.id,
      invoiceId: driftItem.invoiceId,
      productId: driftItem.productId,
      quantity: driftItem.quantity,
      unitPrice: driftItem.unitPrice,
      totalPrice: driftItem.totalPrice,
    );
  }

  db.InvoiceItemsCompanion toDriftCompanion({int? forceInvoiceId}) {
    return db.InvoiceItemsCompanion(
      id: id == 0 ? const drift.Value.absent() : drift.Value(id),
      invoiceId: drift.Value(forceInvoiceId ?? invoiceId!),
      productId: drift.Value(productId),
      quantity: drift.Value(quantity),
      unitPrice: drift.Value(unitPrice),
      totalPrice: drift.Value(totalPrice),
    );
  }
}