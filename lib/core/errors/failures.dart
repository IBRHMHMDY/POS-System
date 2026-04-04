import 'package:equatable/equatable.dart';

/// الكلاس الأساسي لجميع أنواع الأخطاء في النظام
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// أخطاء متعلقة بقاعدة البيانات المحلية (Drift)
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// أخطاء متعلقة بصلاحيات النظام أو التراخيص
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// أخطاء متعلقة بالتعامل مع العتاد (الطابعات، أدراج النقدية)
class HardwareFailure extends Failure {
  const HardwareFailure(super.message);
}

/// أخطاء غير متوقعة
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
