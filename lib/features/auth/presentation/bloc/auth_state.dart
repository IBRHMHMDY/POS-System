import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// الحالة المبدئية قبل القيام بأي إجراء
class AuthInitial extends AuthState {}

/// حالة التحميل (أثناء التحقق من قاعدة البيانات)
class AuthLoading extends AuthState {}

/// حالة النجاح في تسجيل الدخول (تحتوي على بيانات المستخدم وصلاحياته)
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

/// حالة عدم وجود مستخدم مسجل دخوله (يجب عرض شاشة تسجيل الدخول)
class AuthUnauthenticated extends AuthState {}

/// حالة الفشل (كلمة مرور خاطئة، حساب غير نشط، إلخ)
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}