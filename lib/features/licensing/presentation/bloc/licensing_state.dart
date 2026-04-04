import 'package:equatable/equatable.dart';

abstract class LicensingState extends Equatable {
  const LicensingState();

  @override
  List<Object> get props => [];
}

class LicensingInitial extends LicensingState {}

class LicensingLoading extends LicensingState {}

/// حالة نجاح جلب البيانات الأولية (معرف الجهاز وحالة التفعيل السابقة)
class LicensingStatusLoaded extends LicensingState {
  final bool isActivated;
  final String deviceId;

  const LicensingStatusLoaded({
    required this.isActivated,
    required this.deviceId,
  });

  @override
  List<Object> get props => [isActivated, deviceId];
}

/// حالة نجاح عملية التفعيل
class LicensingSuccess extends LicensingState {}

/// حالة فشل (جلب البيانات أو التفعيل)
class LicensingFailure extends LicensingState {
  final String message;

  const LicensingFailure(this.message);

  @override
  List<Object> get props => [message];
}