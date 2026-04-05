import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_item_entity.dart';
import '../repositories/order_repository.dart';

// [Params] هنا هو int يمثل رقم الفاتورة (orderId)
class GetOrderItemsUseCase implements UseCase<List<OrderItemEntity>, int> {
  final OrderRepository repository;

  GetOrderItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderItemEntity>>> call(int params) async {
    return await repository.getOrderItems(params);
  }
}