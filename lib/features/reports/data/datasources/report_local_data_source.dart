import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/report_summary_model.dart';

abstract class ReportLocalDataSource {
  Future<ReportSummaryModel> getReportSummary(DateTime startDate, DateTime endDate);
}

class ReportLocalDataSourceImpl implements ReportLocalDataSource {
  final AppDatabase db;

  ReportLocalDataSourceImpl({required this.db});

  @override
  Future<ReportSummaryModel> getReportSummary(DateTime startDate, DateTime endDate) async {
    // 1. حساب إجمالي المبيعات، الخصومات، والضرائب من جدول (invoices)
    final invoicesQuery = db.selectOnly(db.invoices)
      ..addColumns([
        db.invoices.grandTotal.sum(),
        db.invoices.discount.sum(),
        db.invoices.tax.sum(),
      ])
      ..where(db.invoices.date.isBetweenValues(startDate, endDate));

    final invoiceResult = await invoicesQuery.getSingle();
    final totalSales = invoiceResult.read(db.invoices.grandTotal.sum()) ?? 0.0;
    final totalDiscounts = invoiceResult.read(db.invoices.discount.sum()) ?? 0.0;
    final totalTaxes = invoiceResult.read(db.invoices.tax.sum()) ?? 0.0;

    // 2. حساب إجمالي المصروفات النثرية من جدول (expenses)
    final expensesQuery = db.selectOnly(db.expenses)
      ..addColumns([db.expenses.amount.sum()])
      ..where(db.expenses.date.isBetweenValues(startDate, endDate));

    final expenseResult = await expensesQuery.getSingle();
    final totalExpenses = expenseResult.read(db.expenses.amount.sum()) ?? 0.0;

    // 3. حساب صافي الدخل
    final netIncome = totalSales - totalExpenses;

    return ReportSummaryModel(
      startDate: startDate,
      endDate: endDate,
      totalSales: totalSales,
      totalDiscounts: totalDiscounts,
      totalTaxes: totalTaxes,
      totalExpenses: totalExpenses,
      netIncome: netIncome,
    );
  }
}