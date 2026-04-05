import 'package:dartz/dartz.dart';
import 'package:pos_system/features/shifts/data/datasource/shift_local_data_source.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../models/shift_model.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftLocalDataSource shiftLocalDataSource;
  final AuthLocalDataSource authLocalDataSource;

  ShiftRepositoryImpl({
    required this.shiftLocalDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, ShiftEntity?>> getCurrentActiveShift() async {
    try {
      final shift = await shiftLocalDataSource.getCurrentActiveShift();
      return Right(shift);
    } catch (e) {
      return Left(DatabaseFailure('فشل في جلب الوردية الحالية: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ShiftEntity>> openShift(double startingCash) async {
    try {
      final currentUser = await authLocalDataSource.getCurrentUser();
      if (currentUser == null) {
        return const Left(PermissionFailure('يجب تسجيل الدخول أولاً لفتح وردية.'));
      }

      final activeShift = await shiftLocalDataSource.getCurrentActiveShift();
      if (activeShift != null) {
        return const Left(UnexpectedFailure('هناك وردية مفتوحة بالفعل، يجب إغلاقها أولاً.'));
      }

      final newShiftModel = ShiftModel(
        id: 0,
        userId: currentUser.id,
        startTime: DateTime.now(),
        startingCash: startingCash,
        totalSales: 0.0,
        totalExpenses: 0.0,
        isClosed: false,
      );

      final openedShift = await shiftLocalDataSource.openShift(newShiftModel);
      return Right(openedShift);
    } catch (e) {
      return Left(DatabaseFailure('فشل في فتح الوردية: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ShiftEntity>> closeShift(double actualCash) async {
    try {
      final activeShift = await shiftLocalDataSource.getCurrentActiveShift();
      if (activeShift == null) {
        return const Left(UnexpectedFailure('لا توجد وردية مفتوحة لإغلاقها.'));
      }

      final closedShiftModel = ShiftModel(
        id: activeShift.id,
        userId: activeShift.userId,
        startTime: activeShift.startTime,
        endTime: DateTime.now(),
        startingCash: activeShift.startingCash,
        totalSales: activeShift.totalSales,
        totalExpenses: activeShift.totalExpenses,
        actualCash: actualCash,
        isClosed: true,
      );

      final result = await shiftLocalDataSource.closeShift(closedShiftModel);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure('فشل في إغلاق الوردية: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ShiftEntity>>> getShiftHistory() async {
    try {
      final shifts = await shiftLocalDataSource.getShiftHistory();
      return Right(shifts);
    } catch (e) {
      return Left(DatabaseFailure('فشل في جلب سجل الورديات: ${e.toString()}'));
    }
  }
}