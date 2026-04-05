import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/report_summary_entity.dart';

abstract class ReportRepository {
  /// جلب ملخص تقرير مالي مجمع لفترة زمنية محددة
  Future<Either<Failure, ReportSummaryEntity>> getReportSummary({
    required DateTime startDate,
    required DateTime endDate,
  });
}