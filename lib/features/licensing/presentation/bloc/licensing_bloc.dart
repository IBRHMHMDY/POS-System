import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/activate_license_usecase.dart';
import '../../domain/usecases/check_license_status_usecase.dart';
import '../../domain/usecases/get_device_id_usecase.dart';
import 'licensing_event.dart';
import 'licensing_state.dart';

class LicensingBloc extends Bloc<LicensingEvent, LicensingState> {
  final GetDeviceIdUseCase getDeviceIdUseCase;
  final CheckLicenseStatusUseCase checkLicenseStatusUseCase;
  final ActivateLicenseUseCase activateLicenseUseCase;

  LicensingBloc({
    required this.getDeviceIdUseCase,
    required this.checkLicenseStatusUseCase,
    required this.activateLicenseUseCase,
  }) : super(LicensingInitial()) {
    on<CheckLicenseStatus>(_onCheckLicenseStatus);
    on<SubmitActivationCode>(_onSubmitActivationCode);
  }

  Future<void> _onCheckLicenseStatus(
    CheckLicenseStatus event,
    Emitter<LicensingState> emit,
  ) async {
    emit(LicensingLoading());

    // تنفيذ متوازي لجلب معرف الجهاز وحالة التفعيل (لتحسين الأداء)
    final deviceIdResult = await getDeviceIdUseCase(const NoParams());
    final statusResult = await checkLicenseStatusUseCase(const NoParams());

    // معالجة النتائج
    deviceIdResult.fold(
      (failure) => emit(LicensingFailure(failure.message)),
      (deviceId) {
        statusResult.fold(
          (failure) => emit(LicensingFailure(failure.message)),
          (isActivated) => emit(LicensingStatusLoaded(
            isActivated: isActivated,
            deviceId: deviceId,
          )),
        );
      },
    );
  }

  Future<void> _onSubmitActivationCode(
    SubmitActivationCode event,
    Emitter<LicensingState> emit,
  ) async {
    emit(LicensingLoading());

    final result = await activateLicenseUseCase(event.code);

    result.fold(
      (failure) => emit(LicensingFailure(failure.message)),
      (license) => emit(LicensingSuccess()),
    );
  }
}