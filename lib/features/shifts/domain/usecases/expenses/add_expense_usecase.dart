import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/expense_entity.dart';
import '../../repositories/expense_repository.dart';

class AddExpenseUseCase implements UseCase<ExpenseEntity, AddExpenseParams> {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, ExpenseEntity>> call(AddExpenseParams params) async {
    return await repository.addExpense(params.amount, params.reason);
  }
}

class AddExpenseParams extends Equatable {
  final double amount;
  final String reason;

  const AddExpenseParams({required this.amount, required this.reason});

  @override
  List<Object> get props => [amount, reason];
}