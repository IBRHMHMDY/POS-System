import 'package:equatable/equatable.dart';
import 'package:pos_system/features/reports/domain/entities/report_summary_entity.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final ReportSummaryEntity reportSummary;

  const ReportLoaded(this.reportSummary);

  @override
  List<Object> get props => [reportSummary];
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object> get props => [message];
}