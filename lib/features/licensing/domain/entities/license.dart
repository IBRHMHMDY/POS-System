import 'package:equatable/equatable.dart';

class License extends Equatable {
  final String deviceId;
  final bool isActivated;

  const License({
    required this.deviceId,
    required this.isActivated,
  });

  @override
  List<Object> get props => [deviceId, isActivated];
}