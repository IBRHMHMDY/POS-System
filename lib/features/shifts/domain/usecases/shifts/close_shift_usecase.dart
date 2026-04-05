import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/shift_entity.dart';
import '../../repositories/shift_repository.dart';

// [Params] هنا هو double يمثل النقدية الفعلية بعد الجرد (Actual Cash)
class CloseShiftUseCase implements UseCase<ShiftEntity, double> {
  final ShiftRepository repository;

  CloseShiftUseCase(this.repository);

  @override
  Future<Either<Failure, ShiftEntity>> call(double params) async {
    return await repository.closeShift(params);
  }
}