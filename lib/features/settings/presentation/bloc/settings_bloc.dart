import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_setting_entity.dart';
import '../../domain/usecases/get_all_settings_usecase.dart';
import '../../domain/usecases/save_settings_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetAllSettingsUseCase getAllSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  SettingsBloc({
    required this.getAllSettingsUseCase,
    required this.saveSettingsUseCase,
  }) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());

    final result = await getAllSettingsUseCase(const NoParams());

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settingsList) {
        // تهيئة المتغيرات بالقيم الافتراضية
        String storeName = 'متجري (POS)';
        double taxRate = 0.0;
        String phone = '';
        String address = '';

        // استخراج القيم من قاعدة البيانات بناءً على المفتاح (Key)
        for (var setting in settingsList) {
          switch (setting.key) {
            case 'store_name': storeName = setting.value; break;
            case 'tax_rate': taxRate = double.tryParse(setting.value) ?? 0.0; break;
            case 'store_phone': phone = setting.value; break;
            case 'store_address': address = setting.value; break;
          }
        }

        emit(SettingsLoaded(
          storeName: storeName,
          taxRate: taxRate,
          phone: phone,
          address: address,
        ));
      },
    );
  }

  Future<void> _onSaveSettings(SaveSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());

    // تجميع المتغيرات وتحويلها إلى كيانات ليتم حفظها ككتلة واحدة (Transaction)
    final settingsToSave = [
      AppSettingEntity(key: 'store_name', value: event.storeName),
      AppSettingEntity(key: 'tax_rate', value: event.taxRate.toString()),
      AppSettingEntity(key: 'store_phone', value: event.phone),
      AppSettingEntity(key: 'store_address', value: event.address),
    ];

    final result = await saveSettingsUseCase(settingsToSave);

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) {
        // بعد نجاح الحفظ، نُصدر الحالة الجديدة مع إشعار بالنجاح
        emit(SettingsLoaded(
          storeName: event.storeName,
          taxRate: event.taxRate,
          phone: event.phone,
          address: event.address,
          message: 'تم حفظ إعدادات النظام بنجاح',
        ));
      },
    );
  }
}