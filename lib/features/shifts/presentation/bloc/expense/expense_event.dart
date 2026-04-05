import 'package:equatable/equatable.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class AddExpenseEvent extends ExpenseEvent {
  final double amount;
  final String reason;

  const AddExpenseEvent({required this.amount, required this.reason});

  @override
  List<Object> get props => [amount, reason];
}

class LoadExpensesForShiftEvent extends ExpenseEvent {
  final int shiftId;
  const LoadExpensesForShiftEvent(this.shiftId);

  @override
  List<Object> get props => [shiftId];
}