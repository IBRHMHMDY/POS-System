import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/expense_entity.dart';
import '../../repositories/expense_repository.dart';

// [Params] هنا هو int يمثل رقم تعريف الوردية (shiftId)
class GetExpensesForShiftUseCase implements UseCase<List<ExpenseEntity>, int> {
  final ExpenseRepository repository;

  GetExpensesForShiftUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExpenseEntity>>> call(int params) async {
    return await repository.getExpensesForShift(params);
  }
}