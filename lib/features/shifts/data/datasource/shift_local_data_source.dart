import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/shift_model.dart';

abstract class ShiftLocalDataSource {
  Future<ShiftModel?> getCurrentActiveShift();
  Future<ShiftModel> openShift(ShiftModel shift);
  Future<ShiftModel> closeShift(ShiftModel shift);
  Future<List<ShiftModel>> getShiftHistory();
}

class ShiftLocalDataSourceImpl implements ShiftLocalDataSource {
  final AppDatabase db;

  ShiftLocalDataSourceImpl({required this.db});

  @override
  Future<ShiftModel?> getCurrentActiveShift() async {
    final query = db.select(db.shifts)..where((t) => t.isClosed.equals(false));
    final driftShift = await query.getSingleOrNull();
    if (driftShift != null) {
      return ShiftModel.fromDriftShift(driftShift);
    }
    return null;
  }

  @override
  Future<ShiftModel> openShift(ShiftModel shift) async {
    final id = await db.into(db.shifts).insert(shift.toDriftCompanion());
    final inserted = await (db.select(db.shifts)..where((t) => t.id.equals(id))).getSingle();
    return ShiftModel.fromDriftShift(inserted);
  }

  @override
  Future<ShiftModel> closeShift(ShiftModel shift) async {
    await db.update(db.shifts).replace(shift.toDriftCompanion());
    return shift;
  }

  @override
  Future<List<ShiftModel>> getShiftHistory() async {
    final query = db.select(db.shifts)..orderBy([(t) => OrderingTerm.desc(t.startTime)]);
    final result = await query.get();
    return result.map((s) => ShiftModel.fromDriftShift(s)).toList();
  }
}