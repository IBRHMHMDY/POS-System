import 'package:equatable/equatable.dart';

class ReportSummaryEntity extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final double totalSales; // إجمالي المبيعات (من الفواتير)
  final double totalDiscounts; // إجمالي الخصومات الممنوحة
  final double totalTaxes; // إجمالي الضرائب المحصلة
  final double totalExpenses; // إجمالي المصروفات النثرية
  final double netIncome; // صافي الدخل (المبيعات - المصروفات)

  const ReportSummaryEntity({
    required this.startDate,
    required this.endDate,
    required this.totalSales,
    required this.totalDiscounts,
    required this.totalTaxes,
    required this.totalExpenses,
    required this.netIncome,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        totalSales,
        totalDiscounts,
        totalTaxes,
        totalExpenses,
        netIncome,
      ];
}