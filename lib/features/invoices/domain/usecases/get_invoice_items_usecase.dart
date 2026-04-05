import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/invoice_item_entity.dart';
import '../repositories/invoice_repository.dart';

class GetInvoiceItemsUseCase implements UseCase<List<InvoiceItemEntity>, int> {
  final InvoiceRepository repository;

  GetInvoiceItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InvoiceItemEntity>>> call(int params) async {
    return await repository.getInvoiceItems(params);
  }
}