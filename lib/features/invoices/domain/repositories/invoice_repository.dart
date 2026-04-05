import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../entities/invoice_item_entity.dart';

abstract class InvoiceRepository {
  /// إنشاء وحفظ فاتورة مبيعات جديدة مع جميع عناصرها كعملية واحدة (Transaction)
  Future<Either<Failure, InvoiceEntity>> createInvoice({
    required InvoiceEntity invoice,
    required List<InvoiceItemEntity> items,
  });

  /// جلب جميع الفواتير المرتبطة بوردية معينة
  Future<Either<Failure, List<InvoiceEntity>>> getInvoicesByShift(int shiftId);

  /// جلب تفاصيل وعناصر فاتورة معينة بناءً على رقمها
  Future<Either<Failure, List<InvoiceItemEntity>>> getInvoiceItems(int invoiceId);
}