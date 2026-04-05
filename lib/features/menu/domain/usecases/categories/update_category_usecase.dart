import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/category_entity.dart';
import '../../repositories/menu_repository.dart';

class UpdateCategoryUseCase implements UseCase<CategoryEntity, CategoryEntity> {
  final MenuRepository repository;

  UpdateCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(CategoryEntity params) async {
    return await repository.updateCategory(params);
  }
}