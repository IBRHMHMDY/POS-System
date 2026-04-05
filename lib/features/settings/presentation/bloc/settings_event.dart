import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class SaveSettingsEvent extends SettingsEvent {
  final String storeName;
  final double taxRate;
  final String phone;
  final String address;

  const SaveSettingsEvent({
    required this.storeName,
    required this.taxRate,
    required this.phone,
    required this.address,
  });

  @override
  List<Object?> get props => [storeName, taxRate, phone, address];
}