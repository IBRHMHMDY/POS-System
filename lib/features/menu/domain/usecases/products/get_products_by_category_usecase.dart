import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/product_entity.dart';
import '../../repositories/menu_repository.dart';

class GetProductsByCategoryUseCase implements UseCase<List<ProductEntity>, int> {
  final MenuRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(int params) async {
    return await repository.getProductsByCategory(params);
  }
}