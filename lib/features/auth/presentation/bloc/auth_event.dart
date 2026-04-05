import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// حدث يُستدعى عند بدء التطبيق للتحقق مما إذا كان هناك مستخدم مسجل دخوله بالفعل
class CheckAuthStatusEvent extends AuthEvent {}

/// حدث يُستدعى عند محاولة الكاشير/المدير تسجيل الدخول برمز الدخول
class LoginEvent extends AuthEvent {
  final String passcode;

  const LoginEvent(this.passcode);

  @override
  List<Object> get props => [passcode];
}

/// حدث يُستدعى عند رغبة المستخدم في تسجيل الخروج من الوردية
class LogoutEvent extends AuthEvent {}