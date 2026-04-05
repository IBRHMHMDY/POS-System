import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/product_entity.dart';
import '../../repositories/menu_repository.dart';

class GetProductByBarcodeUseCase implements UseCase<ProductEntity?, String> {
  final MenuRepository repository;

  GetProductByBarcodeUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity?>> call(String params) async {
    return await repository.getProductByBarcode(params);
  }
}