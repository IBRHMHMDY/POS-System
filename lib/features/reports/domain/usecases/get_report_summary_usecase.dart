import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/report_summary_entity.dart';
import '../repositories/report_repository.dart';

class GetReportSummaryUseCase implements UseCase<ReportSummaryEntity, ReportParams> {
  final ReportRepository repository;

  GetReportSummaryUseCase(this.repository);

  @override
  Future<Either<Failure, ReportSummaryEntity>> call(ReportParams params) async {
    return await repository.getReportSummary(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

// كلاس مساعد لتمرير تواريخ التقرير كمعامل واحد
class ReportParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const ReportParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}