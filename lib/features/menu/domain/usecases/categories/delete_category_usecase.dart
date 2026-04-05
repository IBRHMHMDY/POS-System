import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../repositories/menu_repository.dart';

// [Params] هنا هو int يمثل رقم تعريف القسم (categoryId)
class DeleteCategoryUseCase implements UseCase<void, int> {
  final MenuRepository repository;

  DeleteCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) async {
    return await repository.deleteCategory(params);
  }
}