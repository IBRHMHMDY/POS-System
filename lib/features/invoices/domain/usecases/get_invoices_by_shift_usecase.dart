import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/invoice_entity.dart';
import '../repositories/invoice_repository.dart';

class GetInvoicesByShiftUseCase implements UseCase<List<InvoiceEntity>, int> {
  final InvoiceRepository repository;

  GetInvoicesByShiftUseCase(this.repository);

  @override
  Future<Either<Failure, List<InvoiceEntity>>> call(int params) async {
    return await repository.getInvoicesByShift(params);
  }
}