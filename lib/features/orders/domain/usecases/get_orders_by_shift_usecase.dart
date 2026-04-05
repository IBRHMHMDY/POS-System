import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

// [Params] هنا هو int يمثل رقم الوردية (shiftId)
class GetOrdersByShiftUseCase implements UseCase<List<OrderEntity>, int> {
  final OrderRepository repository;

  GetOrdersByShiftUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(int params) async {
    return await repository.getOrdersByShift(params);
  }
}