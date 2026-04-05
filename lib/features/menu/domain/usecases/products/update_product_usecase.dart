import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/product_entity.dart';
import '../../repositories/menu_repository.dart';

class UpdateProductUseCase implements UseCase<ProductEntity, ProductEntity> {
  final MenuRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(ProductEntity params) async {
    return await repository.updateProduct(params);
  }
}