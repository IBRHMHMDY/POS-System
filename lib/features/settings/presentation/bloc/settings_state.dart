import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final String storeName;
  final double taxRate;
  final String phone;
  final String address;
  final String? message; // نستخدمه لعرض رسالة (SnackBar) عند نجاح الحفظ

  const SettingsLoaded({
    this.storeName = 'متجري (POS)', // القيمة الافتراضية
    this.taxRate = 0.0,
    this.phone = '',
    this.address = '',
    this.message,
  });

  SettingsLoaded copyWith({
    String? storeName,
    double? taxRate,
    String? phone,
    String? address,
    String? message,
    bool clearMessage = false,
  }) {
    return SettingsLoaded(
      storeName: storeName ?? this.storeName,
      taxRate: taxRate ?? this.taxRate,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [storeName, taxRate, phone, address, message];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}