import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/invoice_entity.dart';
import '../entities/invoice_item_entity.dart';
import '../repositories/invoice_repository.dart';

class CreateInvoiceUseCase implements UseCase<InvoiceEntity, CreateInvoiceParams> {
  final InvoiceRepository repository;

  CreateInvoiceUseCase(this.repository);

  @override
  Future<Either<Failure, InvoiceEntity>> call(CreateInvoiceParams params) async {
    return await repository.createInvoice(
      invoice: params.invoice,
      items: params.items,
    );
  }
}

class CreateInvoiceParams extends Equatable {
  final InvoiceEntity invoice;
  final List<InvoiceItemEntity> items;

  const CreateInvoiceParams({
    required this.invoice,
    required this.items,
  });

  @override
  List<Object> get props => [invoice, items];
}