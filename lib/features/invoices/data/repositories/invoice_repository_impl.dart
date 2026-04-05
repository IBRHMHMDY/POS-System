import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_local_data_source.dart';
import '../models/invoice_item_model.dart';
import '../models/invoice_model.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceLocalDataSource localDataSource;

  InvoiceRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, InvoiceEntity>> createInvoice({
    required InvoiceEntity invoice,
    required List<InvoiceItemEntity> items,
  }) async {
    try {
      final invoiceModel = InvoiceModel.fromEntity(invoice);
      final itemsModels = items.map((i) => InvoiceItemModel.fromEntity(i)).toList();

      final result = await localDataSource.createInvoiceWithItems(
        invoice: invoiceModel,
        items: itemsModels,
      );

      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure('فشل في حفظ الفاتورة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceEntity>>> getInvoicesByShift(int shiftId) async {
    try {
      final invoices = await localDataSource.getInvoicesByShift(shiftId);
      return Right(invoices);
    } catch (e) {
      return Left(DatabaseFailure('فشل في جلب الفواتير: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceItemEntity>>> getInvoiceItems(int invoiceId) async {
    try {
      final items = await localDataSource.getInvoiceItems(invoiceId);
      return Right(items);
    } catch (e) {
      return Left(DatabaseFailure('فشل في جلب تفاصيل الفاتورة: ${e.toString()}'));
    }
  }
}