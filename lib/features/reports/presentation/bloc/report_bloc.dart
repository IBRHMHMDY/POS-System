import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/features/reports/domain/usecases/get_report_summary_usecase.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetReportSummaryUseCase getReportSummaryUseCase;

  ReportBloc({required this.getReportSummaryUseCase}) : super(ReportInitial()) {
    on<LoadReportSummaryEvent>(_onLoadReportSummary);
  }

  Future<void> _onLoadReportSummary(LoadReportSummaryEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());

    final result = await getReportSummaryUseCase(
      ReportParams(startDate: event.startDate, endDate: event.endDate),
    );

    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (reportSummary) => emit(ReportLoaded(reportSummary)),
    );
  }
}