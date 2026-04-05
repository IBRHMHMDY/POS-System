import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  /// إضافة مصروف جديد على الوردية الحالية
  Future<Either<Failure, ExpenseEntity>> addExpense(double amount, String reason);
  
  /// جلب المصروفات المرتبطة بوردية معينة
  Future<Either<Failure, List<ExpenseEntity>>> getExpensesForShift(int shiftId);
}