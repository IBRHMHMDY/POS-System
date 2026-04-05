import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/product_entity.dart';
import '../../repositories/menu_repository.dart';

class GetAllProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final MenuRepository repository;

  GetAllProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}