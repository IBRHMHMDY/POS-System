import '../../domain/entities/report_summary_entity.dart';

class ReportSummaryModel extends ReportSummaryEntity {
  const ReportSummaryModel({
    required super.startDate,
    required super.endDate,
    required super.totalSales,
    required super.totalDiscounts,
    required super.totalTaxes,
    required super.totalExpenses,
    required super.netIncome,
  });

  // هنا لا نحتاج إلى fromDrift عادي لأننا سنقوم ببناء هذا الموديل 
  // يدوياً من نتائج التجميع (SUM) القادمة من قاعدة البيانات.
}