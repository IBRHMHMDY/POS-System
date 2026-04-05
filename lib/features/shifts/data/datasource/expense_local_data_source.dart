import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<ExpenseModel> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpensesForShift(int shiftId);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final AppDatabase db;

  ExpenseLocalDataSourceImpl({required this.db});

  @override
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    return await db.transaction(() async {
      // 1. إضافة المصروف
      final expenseId = await db.into(db.expenses).insert(expense.toDriftCompanion());
      
      // 2. تحديث إجمالي المصروفات في الوردية (إذا كان مرتبطاً بوردية)
      if (expense.shiftId != null) {
        final shift = await (db.select(db.shifts)..where((t) => t.id.equals(expense.shiftId!))).getSingle();
        final newTotalExpenses = shift.totalExpenses + expense.amount;
        await (db.update(db.shifts)..where((t) => t.id.equals(shift.id))).write(
          ShiftsCompanion(totalExpenses: Value(newTotalExpenses)),
        );
      }

      final inserted = await (db.select(db.expenses)..where((t) => t.id.equals(expenseId))).getSingle();
      return ExpenseModel.fromDriftExpense(inserted);
    });
  }

  @override
  Future<List<ExpenseModel>> getExpensesForShift(int shiftId) async {
    final query = db.select(db.expenses)
      ..where((t) => t.shiftId.equals(shiftId))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    final result = await query.get();
    return result.map((e) => ExpenseModel.fromDriftExpense(e)).toList();
  }
}