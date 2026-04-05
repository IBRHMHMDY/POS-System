import 'package:equatable/equatable.dart';

class AppSettingEntity extends Equatable {
  final String key;
  final String value;

  const AppSettingEntity({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}