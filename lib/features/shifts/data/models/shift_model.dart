import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/shift_entity.dart';

class ShiftModel extends ShiftEntity {
  const ShiftModel({
    required super.id,
    required super.userId,
    required super.startTime,
    super.endTime,
    required super.startingCash,
    required super.totalSales,
    required super.totalExpenses,
    super.actualCash,
    required super.isClosed,
  });

  factory ShiftModel.fromDriftShift(db.Shift driftShift) {
    return ShiftModel(
      id: driftShift.id,
      userId: driftShift.userId,
      startTime: driftShift.startTime,
      endTime: driftShift.endTime,
      startingCash: driftShift.startingCash,
      totalSales: driftShift.totalSales,
      totalExpenses: driftShift.totalExpenses,
      actualCash: driftShift.actualCash,
      isClosed: driftShift.isClosed,
    );
  }

  db.ShiftsCompanion toDriftCompanion() {
    return db.ShiftsCompanion(
      id: id == 0 ? const drift.Value.absent() : drift.Value(id),
      userId: drift.Value(userId),
      startTime: drift.Value(startTime),
      endTime: drift.Value(endTime),
      startingCash: drift.Value(startingCash),
      totalSales: drift.Value(totalSales),
      totalExpenses: drift.Value(totalExpenses),
      actualCash: drift.Value(actualCash),
      isClosed: drift.Value(isClosed),
    );
  }
}