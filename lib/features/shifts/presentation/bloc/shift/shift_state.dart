import 'package:equatable/equatable.dart';
import '../../../domain/entities/shift_entity.dart';

abstract class ShiftState extends Equatable {
  const ShiftState();

  @override
  List<Object?> get props => [];
}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class CurrentShiftLoaded extends ShiftState {
  final ShiftEntity? shift; // قد يكون null إذا لم تكن هناك وردية مفتوحة
  const CurrentShiftLoaded(this.shift);

  @override
  List<Object?> get props => [shift];
}

class ShiftHistoryLoaded extends ShiftState {
  final List<ShiftEntity> shifts;
  const ShiftHistoryLoaded(this.shifts);

  @override
  List<Object> get props => [shifts];
}

class ShiftActionSuccess extends ShiftState {
  final String message;
  const ShiftActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ShiftError extends ShiftState {
  final String message;
  const ShiftError(this.message);

  @override
  List<Object> get props => [message];
}