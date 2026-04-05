import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/usecases/usecase.dart';
import '../../../domain/usecases/shifts/close_shift_usecase.dart';
import '../../../domain/usecases/shifts/get_current_active_shift_usecase.dart';
import '../../../domain/usecases/shifts/get_shift_history_usecase.dart';
import '../../../domain/usecases/shifts/open_shift_usecase.dart';
import 'shift_event.dart';
import 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final GetCurrentActiveShiftUseCase getCurrentActiveShiftUseCase;
  final OpenShiftUseCase openShiftUseCase;
  final CloseShiftUseCase closeShiftUseCase;
  final GetShiftHistoryUseCase getShiftHistoryUseCase;

  ShiftBloc({
    required this.getCurrentActiveShiftUseCase,
    required this.openShiftUseCase,
    required this.closeShiftUseCase,
    required this.getShiftHistoryUseCase,
  }) : super(ShiftInitial()) {
    on<CheckCurrentShiftEvent>(_onCheckCurrentShift);
    on<OpenShiftEvent>(_onOpenShift);
    on<CloseShiftEvent>(_onCloseShift);
    on<LoadShiftHistoryEvent>(_onLoadShiftHistory);
  }

  Future<void> _onCheckCurrentShift(CheckCurrentShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await getCurrentActiveShiftUseCase(const NoParams());
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shift) => emit(CurrentShiftLoaded(shift)),
    );
  }

  Future<void> _onOpenShift(OpenShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await openShiftUseCase(event.startingCash);
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (_) {
        emit(const ShiftActionSuccess('تم فتح الوردية بنجاح'));
        add(CheckCurrentShiftEvent()); // إعادة جلب الوردية الحالية لتحديث الواجهة
      },
    );
  }

  Future<void> _onCloseShift(CloseShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await closeShiftUseCase(event.actualCash);
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (_) {
        emit(const ShiftActionSuccess('تم إغلاق الوردية بنجاح'));
        add(CheckCurrentShiftEvent());
      },
    );
  }

  Future<void> _onLoadShiftHistory(LoadShiftHistoryEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await getShiftHistoryUseCase(const NoParams());
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shifts) => emit(ShiftHistoryLoaded(shifts)),
    );
  }
}