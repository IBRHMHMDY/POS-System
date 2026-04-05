import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../datasources/shift_local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource expenseLocalDataSource;
  final ShiftLocalDataSource shiftLocalDataSource;
  final AuthLocalDataSource authLocalDataSource;

  ExpenseRepositoryImpl({
    required this.expenseLocalDataSource,
    required this.shiftLocalDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, ExpenseEntity>> addExpense(double amount, String reason) async {
    try {
      final currentUser = await authLocalDataSource.getCurrentUser();
      if (currentUser == null) {
        return const Left(PermissionFailure('يجب تسجيل الدخول أولاً لتسجيل مصروف.'));
      }

      final activeShift = await shiftLocalDataSource.getCurrentActiveShift();
      
      final newExpenseModel = ExpenseModel(
        id: 0,
        shiftId: activeShift?.id, // قد يكون null إذا تم الصرف خارج وردية (اختياري حسب الـ Business Logic)
        userId: currentUser.id,
        amount: amount,
        reason: reason,
        date: DateTime.now(),
      );

      final addedExpense = await expenseLocalDataSource.addExpense(newExpenseModel);
      return Right(addedExpense);
    } catch (e) {
      return Left(DatabaseFailure('فشل في تسجيل المصروف: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getExpensesForShift(int shiftId) async {
    try {
      final expenses = await expenseLocalDataSource.getExpensesForShift(shiftId);
      return Right(expenses);
    } catch (e) {
      return Left(DatabaseFailure('فشل في جلب المصروفات: ${e.toString()}'));
    }
  }
}