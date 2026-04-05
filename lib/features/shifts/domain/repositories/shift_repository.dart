import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/shift_entity.dart';

abstract class ShiftRepository {
  /// جلب الوردية المفتوحة حالياً (إن وجدت)
  Future<Either<Failure, ShiftEntity?>> getCurrentActiveShift();
  
  /// فتح وردية جديدة بعهدة محددة
  Future<Either<Failure, ShiftEntity>> openShift(double startingCash);
  
  /// إغلاق الوردية الحالية مع تسجيل النقدية الفعلية (الجرد)
  Future<Either<Failure, ShiftEntity>> closeShift(double actualCash);
  
  /// جلب سجل الورديات السابقة (للتقارير)
  Future<Either<Failure, List<ShiftEntity>>> getShiftHistory();
}