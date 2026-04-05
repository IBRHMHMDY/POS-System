import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/report_summary_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_local_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportLocalDataSource localDataSource;

  ReportRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, ReportSummaryEntity>> getReportSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final reportModel = await localDataSource.getReportSummary(startDate, endDate);
      return Right(reportModel);
    } catch (e) {
      return Left(DatabaseFailure('فشل في حساب التقرير المالي: ${e.toString()}'));
    }
  }
}