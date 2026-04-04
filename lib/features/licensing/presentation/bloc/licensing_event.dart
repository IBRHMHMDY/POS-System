import 'package:equatable/equatable.dart';

abstract class LicensingEvent extends Equatable {
  const LicensingEvent();

  @override
  List<Object> get props => [];
}

/// حدث للتحقق من حالة الترخيص وجلب معرف الجهاز عند بدء تشغيل التطبيق
class CheckLicenseStatus extends LicensingEvent {}

/// حدث لمحاولة تفعيل النظام باستخدام الكود المدخل
class SubmitActivationCode extends LicensingEvent {
  final String code;

  const SubmitActivationCode(this.code);

  @override
  List<Object> get props => [code];
}