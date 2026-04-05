import 'package:equatable/equatable.dart';

abstract class ShiftEvent extends Equatable {
  const ShiftEvent();

  @override
  List<Object> get props => [];
}

class CheckCurrentShiftEvent extends ShiftEvent {}

class OpenShiftEvent extends ShiftEvent {
  final double startingCash;
  const OpenShiftEvent(this.startingCash);

  @override
  List<Object> get props => [startingCash];
}

class CloseShiftEvent extends ShiftEvent {
  final double actualCash;
  const CloseShiftEvent(this.actualCash);

  @override
  List<Object> get props => [actualCash];
}

class LoadShiftHistoryEvent extends ShiftEvent {}