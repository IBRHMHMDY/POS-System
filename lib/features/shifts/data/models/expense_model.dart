import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    super.shiftId,
    required super.userId,
    required super.amount,
    required super.reason,
    required super.date,
  });

  factory ExpenseModel.fromDriftExpense(db.Expense driftExpense) {
    return ExpenseModel(
      id: driftExpense.id,
      shiftId: driftExpense.shiftId,
      userId: driftExpense.userId,
      amount: driftExpense.amount,
      reason: driftExpense.reason,
      date: driftExpense.date,
    );
  }

  db.ExpensesCompanion toDriftCompanion() {
    return db.ExpensesCompanion(
      id: id == 0 ? const drift.Value.absent() : drift.Value(id),
      shiftId: drift.Value(shiftId),
      userId: drift.Value(userId),
      amount: drift.Value(amount),
      reason: drift.Value(reason),
      date: drift.Value(date),
    );
  }
}