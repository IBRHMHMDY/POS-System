import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/invoice_item_model.dart';
import '../models/invoice_model.dart';

abstract class InvoiceLocalDataSource {
  Future<InvoiceModel> createInvoiceWithItems({required InvoiceModel invoice, required List<InvoiceItemModel> items});
  Future<List<InvoiceModel>> getInvoicesByShift(int shiftId);
  Future<List<InvoiceItemModel>> getInvoiceItems(int invoiceId);
}

class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  final AppDatabase db;

  InvoiceLocalDataSourceImpl({required this.db});

  @override
  Future<InvoiceModel> createInvoiceWithItems({
    required InvoiceModel invoice,
    required List<InvoiceItemModel> items,
  }) async {
    return await db.transaction(() async {
      // 1. إضافة الفاتورة
      final invoiceId = await db.into(db.invoices).insert(invoice.toDriftCompanion());

      // 2. تحديث المبيعات باستخدام grandTotal
      final shift = await (db.select(db.shifts)..where((t) => t.id.equals(invoice.shiftId))).getSingle();
      final newTotalSales = shift.totalSales + invoice.grandTotal;
      await (db.update(db.shifts)..where((t) => t.id.equals(shift.id))).write(
        ShiftsCompanion(totalSales: Value(newTotalSales)),
      );

      // 3. حفظ العناصر
      for (var item in items) {
        await db.into(db.invoiceItems).insert(item.toDriftCompanion(forceInvoiceId: invoiceId));
      }

      final insertedInvoice = await (db.select(db.invoices)..where((t) => t.id.equals(invoiceId))).getSingle();
      return InvoiceModel.fromDriftInvoice(insertedInvoice);
    });
  }

  @override
  Future<List<InvoiceModel>> getInvoicesByShift(int shiftId) async {
    final query = db.select(db.invoices)
      ..where((t) => t.shiftId.equals(shiftId))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]); // تم تصحيح الحقل إلى date
    final result = await query.get();
    return result.map((i) => InvoiceModel.fromDriftInvoice(i)).toList();
  }

  @override
  Future<List<InvoiceItemModel>> getInvoiceItems(int invoiceId) async {
    final query = db.select(db.invoiceItems)..where((t) => t.invoiceId.equals(invoiceId));
    final result = await query.get();
    return result.map((i) => InvoiceItemModel.fromDriftInvoiceItem(i)).toList();
  }
}