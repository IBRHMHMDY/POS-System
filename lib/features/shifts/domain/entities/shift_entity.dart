import 'package:equatable/equatable.dart';

class ShiftEntity extends Equatable {
  final int id;
  final int userId; // الكاشير الذي فتح الوردية
  final DateTime startTime;
  final DateTime? endTime;
  final double startingCash; // العهدة أو الدرج الافتتاحي
  final double totalSales;
  final double totalExpenses;
  final double? actualCash; // المبلغ الفعلي الذي تم جرده عند الإغلاق
  final bool isClosed;

  const ShiftEntity({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.startingCash,
    required this.totalSales,
    required this.totalExpenses,
    this.actualCash,
    required this.isClosed,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        startTime,
        endTime,
        startingCash,
        totalSales,
        totalExpenses,
        actualCash,
        isClosed,
      ];
}