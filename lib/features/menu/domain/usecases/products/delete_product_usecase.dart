import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../repositories/menu_repository.dart';

class DeleteProductUseCase implements UseCase<void, int> {
  final MenuRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) async {
    return await repository.deleteProduct(params);
  }
}