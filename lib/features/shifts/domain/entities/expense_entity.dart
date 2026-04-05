import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final int id;
  final int? shiftId; // الوردية التي تم الصرف خلالها
  final int userId; // من قام بالصرف
  final double amount;
  final String reason;
  final DateTime date;

  const ExpenseEntity({
    required this.id,
    this.shiftId,
    required this.userId,
    required this.amount,
    required this.reason,
    required this.date,
  });

  @override
  List<Object?> get props => [id, shiftId, userId, amount, reason, date];
}